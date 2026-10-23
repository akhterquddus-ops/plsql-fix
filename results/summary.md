# PLSQL-Fix results (75 runs, 12 tasks, models: gemma4:e4b)

### By setting

| setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|
| none | 36 | 50% | 28% | 22% | 33% | 33% | 2.36 | 768 | 80 |
| graph | 36 | 75% | 75% | 0% | 92% | 86% | 1.64 | 1089 | 38 |
| graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |

### By bug location and setting

| category | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| cross_object | none | 24 | 33% | 0% | 33% | 0% | 0% | 2.83 | 800 | 107 |
| cross_object | graph | 24 | 71% | 71% | 0% | 88% | 79% | 1.67 | 1280 | 42 |
| cross_object | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| local | none | 12 | 83% | 83% | 0% | 100% | 100% | 1.42 | 706 | 25 |
| local | graph | 12 | 83% | 83% | 0% | 100% | 100% | 1.58 | 706 | 30 |

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
| t004_late_fee | none | 3 | 67% | 0% | 67% | 0% | 0% | 2.67 | 729 | 73 |
| t004_late_fee | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 985 | 18 |
| t005_stock_reserve | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 717 | 126 |
| t005_stock_reserve | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1241 | 36 |
| t006_income_tax | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 857 | 21 |
| t006_income_tax | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 857 | 17 |
| t007_region_summary | none | 3 | 100% | 0% | 100% | 0% | 0% | 2.00 | 883 | 66 |
| t007_region_summary | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1287 | 23 |
| t008_overpayment | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 703 | 97 |
| t008_overpayment | graph | 3 | 67% | 67% | 0% | 100% | 67% | 1.67 | 1098 | 36 |
| t009_shipping_weight | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 753 | 157 |
| t009_shipping_weight | graph | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1345 | 94 |
| t009_shipping_weight | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| t010_loan_payment | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1053 | 63 |
| t010_loan_payment | graph | 3 | 67% | 67% | 0% | 100% | 67% | 2.33 | 1581 | 66 |
| t011_full_name | none | 3 | 33% | 33% | 0% | 100% | 100% | 2.33 | 544 | 27 |
| t011_full_name | graph | 3 | 33% | 33% | 0% | 100% | 100% | 3.00 | 543 | 36 |
