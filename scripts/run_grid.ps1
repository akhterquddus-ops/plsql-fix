<#
.SYNOPSIS
  Runs the agent over tasks x settings x seeds. Resume-safe: a run whose log already
  exists in results\<task>\ is skipped, so the script can simply be started again.

.EXAMPLES
  # Bigger model on a remote Ollama (Kaggle GPU via tunnel), hidden-dependency batch, seed 1
  $env:OLLAMA_URL = "https://<your-tunnel>.trycloudflare.com"
  $env:PLSQLFIX_DEVICE = "kaggle-t4x2"
  .\scripts\run_grid.ps1 -Model gemma4:26b -Seeds 1

  # Local model on CPU (as in the main grid)
  .\scripts\run_grid.ps1 -Model gemma4:e4b -Seeds 1,2,3 -Cpu
#>
param(
    [string]$Model = "gemma4:26b",
    [int[]]$Seeds = @(1),
    [string[]]$Settings = @("none", "dense", "hybrid", "graph", "hybrid_graph"),
    [string[]]$Tasks = @("t012_scholarship_fee", "t013_stock_moves", "t014_item_margin",
                         "t015_vat_synonym", "t016_active_staff", "t017_overdraft_limit",
                         "t018_loyalty_points", "t019_net_pay", "t021_ticket_due"),
    [double]$Temperature = 0.2,
    [int]$Timeout = 600,
    [switch]$Cpu
)

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root
$safeModel = $Model -replace '[^\w.-]', '_'
$total = $Tasks.Count * $Settings.Count * $Seeds.Count
$n = 0; $done = 0; $failed = 0
$start = Get-Date

foreach ($seed in $Seeds) {
    foreach ($task in $Tasks) {
        foreach ($setting in $Settings) {
            $n++
            $pattern = Join-Path $Root "results\$task\${setting}_${safeModel}_s${seed}_*.json"
            if (Test-Path $pattern) {
                Write-Host "[$n/$total] skip $task $setting s$seed (log exists)" -ForegroundColor DarkGray
                continue
            }
            Write-Host "[$n/$total] $task $setting s$seed  ($(Get-Date -Format HH:mm:ss))" -ForegroundColor Cyan
            $pyArgs = @("agent\run_task.py", "tasks\$task", "--setting", $setting, "--model", $Model,
                      "--seed", $seed, "--temperature", $Temperature, "--timeout", $Timeout)
            if ($Cpu) { $pyArgs += "--cpu" }
            python @pyArgs
            if ($LASTEXITCODE -eq 0) { $done++ } else { $failed++; Write-Host "  run failed (exit $LASTEXITCODE)" -ForegroundColor Yellow }
        }
    }
}

$mins = [math]::Round(((Get-Date) - $start).TotalMinutes, 1)
Write-Host "`nFinished: $done new runs, $failed failed, in $mins min. Run again to retry failures." -ForegroundColor Green
