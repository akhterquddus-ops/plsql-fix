# PLSQL-Fix results (24 runs, 4 tasks, models: gemma4:e4b)

### By setting

| setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|
| none | 12 | 58% | 50% | 8% | 50% | 50% | 2.08 | 745 | 81 |
| graph | 12 | 83% | 83% | 0% | 100% | 100% | 1.42 | 1031 | 34 |

### By bug location and setting

| category | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| cross_object | none | 6 | 17% | 0% | 17% | 0% | 0% | 3.00 | 780 | 136 |
| cross_object | graph | 6 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1352 | 33 |
| local | none | 6 | 100% | 100% | 0% | 100% | 100% | 1.17 | 711 | 26 |
| local | graph | 6 | 100% | 100% | 0% | 100% | 100% | 1.17 | 711 | 34 |

### By task and setting

| task | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| demo_leap_year | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 493 | 13 |
| demo_leap_year | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 493 | 13 |
| t001_order_discount | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 686 | 53 |
| t001_order_discount | graph | 3 | 33% | 33% | 0% | 100% | 100% | 2.33 | 1069 | 37 |
| t002_working_days | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 929 | 38 |
| t002_working_days | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 929 | 55 |
| t003_transfer_fee | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 873 | 220 |
| t003_transfer_fee | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1634 | 30 |
