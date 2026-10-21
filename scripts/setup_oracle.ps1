<#
.SYNOPSIS
  PLSQL-Fix setup: starts Oracle Database Free in Docker, installs utPLSQL,
  and runs the demo task (expects 1 failed -> 0 failed).

.USAGE
  From the repo root:
    powershell -ExecutionPolicy Bypass -File .\scripts\setup_oracle.ps1

.NOTES
  Passwords below are LOCAL DEMO values only. Safe to re-run: each step
  is skipped if already done.
#>
param(
    [string]$Container   = "plsqlfix-ora",
    [string]$Image       = "gvenzl/oracle-free:23-faststart",
    [string]$SysPassword = "Oracle123",
    [string]$AppUser     = "plsqlfix",
    [string]$AppPassword = "plsqlfix123",
    [string]$Ut3Password = "ut3pass123"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot   # repo root (script lives in scripts\)

function Write-Step([string]$Text) { Write-Host "`n=== $Text ===" -ForegroundColor Cyan }

# Run SQL text through SQL*Plus inside the container; returns output lines.
function Invoke-Sql([string]$Sql, [switch]$AsSys) {
    if ($AsSys) { $conn = "sys/$SysPassword@FREEPDB1 as sysdba" }
    else        { $conn = "$AppUser/$AppPassword@FREEPDB1" }
    ("set heading off feedback off pagesize 0`n" + $Sql + "`nexit`n") |
        docker exec -i $Container sqlplus -s -L $conn
}

# Run a .sql file that is already inside the container.
function Invoke-SqlFile([string]$Dir, [string]$File) {
    docker exec -w $Dir $Container sqlplus -s "$AppUser/$AppPassword@FREEPDB1" "@$File"
}

# ---------------------------------------------------------------- 1. Docker
Write-Step "1/5 Checking Docker"
docker info *> $null
if ($LASTEXITCODE -ne 0) { throw "Docker is not running. Start Docker Desktop and wait for 'Engine running'." }
Write-Host "Docker is running."

# ---------------------------------------------------------------- 2. Oracle container
Write-Step "2/5 Starting Oracle container '$Container'"
$exists  = docker ps -a --filter "name=^/$Container$" --format "{{.Names}}"
$running = docker ps    --filter "name=^/$Container$" --format "{{.Names}}"
if (-not $exists) {
    Write-Host "Creating container from $Image (first run downloads ~2-3 GB)..."
    docker run -d --name $Container -p 1521:1521 `
        -e ORACLE_PASSWORD=$SysPassword `
        -e APP_USER=$AppUser -e APP_USER_PASSWORD=$AppPassword `
        -v plsqlfix-oradata:/opt/oracle/oradata `
        $Image | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "docker run failed." }
} elseif (-not $running) {
    docker start $Container | Out-Null
} else {
    Write-Host "Already running."
}

Write-Host "Waiting for the database to accept logins (up to 5 minutes)..."
$deadline = (Get-Date).AddMinutes(5)
do {
    Start-Sleep -Seconds 5
    $out = (Invoke-Sql "select 'DB_' || 'READY' from dual;" -AsSys) -join "`n"
} until (($out -match "DB_READY") -or ((Get-Date) -gt $deadline))
if ($out -notmatch "DB_READY") { throw "Database did not become ready in time. Check: docker logs $Container" }
Write-Host "Database is ready."

# ---------------------------------------------------------------- 3. utPLSQL
Write-Step "3/5 Checking utPLSQL"
$check = (Invoke-Sql @"
select (select count(*) from dba_objects
         where owner = 'UT3' and object_name = 'UT'
           and object_type = 'PACKAGE BODY' and status = 'VALID')
     + (select count(*) from dba_synonyms
         where owner = 'PUBLIC' and synonym_name = 'UT')
from dual;
"@ -AsSys) -join ""

if ($check.Trim() -eq "2") {
    Write-Host "utPLSQL already installed."
} else {
    $src = Join-Path $Root "utPLSQL\source\install_headless.sql"
    if (-not (Test-Path $src)) {
        Write-Host "Downloading latest utPLSQL release..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $rel   = Invoke-RestMethod https://api.github.com/repos/utPLSQL/utPLSQL/releases/latest
        $asset = $rel.assets | Where-Object name -eq "utPLSQL.zip"
        $zip   = Join-Path $Root "utPLSQL.zip"
        Invoke-WebRequest $asset.browser_download_url -OutFile $zip
        Expand-Archive $zip -DestinationPath $Root -Force
        Write-Host "Downloaded $($rel.tag_name)."
    }

    Write-Host "Removing any partial UT3 install..."
    Invoke-Sql @"
begin
  for u in (select 1 from dba_users where username = 'UT3') loop
    execute immediate 'drop user ut3 cascade';
  end loop;
end;
/
"@ -AsSys | Out-Null

    Write-Host "Copying utPLSQL into the container..."
    docker exec -u root $Container rm -rf /tmp/utPLSQL
    docker cp (Join-Path $Root "utPLSQL") "${Container}:/tmp/utPLSQL" | Out-Null
    # docker cp copies as root; the oracle user must own the folder,
    # otherwise the installer cannot write params.sql.tmp and the grants step fails.
    docker exec -u root $Container chown -R oracle /tmp/utPLSQL

    Write-Host "Installing utPLSQL into schema UT3 (1-3 minutes)..."
    docker exec -w /tmp/utPLSQL/source $Container sqlplus -s "sys/$SysPassword@FREEPDB1" as sysdba "@install_headless.sql" ut3 $Ut3Password users |
        Select-String -Pattern "Installation completed|ORA-|SP2-"
}

$ver = (Invoke-Sql "select ut.version() from dual;") -join ""
if ($ver -notmatch "v\.?3") { throw "utPLSQL check failed as $AppUser. Output: $ver" }
Write-Host "utPLSQL version: $($ver.Trim())"

# ---------------------------------------------------------------- 4. Demo task: buggy
Write-Step "4/5 Demo task: buggy code (expect 1 failed)"
$task = Join-Path $Root "tasks\demo_leap_year"
docker exec -u root $Container rm -rf /tmp/demo
docker cp "$task\." "${Container}:/tmp/demo" | Out-Null
Invoke-SqlFile /tmp/demo 01_buggy.sql | Out-Null
Invoke-SqlFile /tmp/demo 02_test.sql  | Out-Null
$before = (Invoke-SqlFile /tmp/demo run_tests.sql) -join "`n"
Write-Host $before

# ---------------------------------------------------------------- 5. Demo task: fixed
Write-Step "5/5 Demo task: reference fix (expect 0 failed)"
Invoke-SqlFile /tmp/demo 03_fixed.sql | Out-Null
$after = (Invoke-SqlFile /tmp/demo run_tests.sql) -join "`n"
Write-Host $after

if (($before -match "3 tests, 1 failed") -and ($after -match "3 tests, 0 failed")) {
    Write-Host "`nSETUP OK: demo task goes from 1 failed to 0 failed." -ForegroundColor Green
} else {
    Write-Host "`nSETUP CHECK FAILED: see the test output above." -ForegroundColor Red
    exit 1
}
