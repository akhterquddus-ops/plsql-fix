# PLSQL-Fix results (183 runs, 12 tasks, models: gemma4:e4b)

### By setting

| setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|
| none | 36 | 50% | 28% | 22% | 33% | 33% | 2.36 | 768 | 80 |
| dense | 36 | 78% | 78% | 0% | 97% | 89% | 1.58 | 1637 | 51 |
| hybrid | 36 | 83% | 83% | 0% | 92% | 92% | 1.44 | 1655 | 49 |
| graph | 36 | 75% | 75% | 0% | 92% | 86% | 1.64 | 1089 | 38 |
| graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| hybrid_graph | 36 | 81% | 81% | 0% | 100% | 92% | 1.53 | 2018 | 50 |

### By bug location and setting

| category | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| cross_object | none | 24 | 33% | 0% | 33% | 0% | 0% | 2.83 | 800 | 107 |
| cross_object | dense | 24 | 67% | 67% | 0% | 96% | 83% | 1.79 | 1645 | 60 |
| cross_object | hybrid | 24 | 75% | 75% | 0% | 88% | 88% | 1.62 | 1643 | 57 |
| cross_object | graph | 24 | 71% | 71% | 0% | 88% | 79% | 1.67 | 1280 | 42 |
| cross_object | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| cross_object | hybrid_graph | 24 | 75% | 75% | 0% | 100% | 88% | 1.62 | 2198 | 58 |
| local | none | 12 | 83% | 83% | 0% | 100% | 100% | 1.42 | 706 | 25 |
| local | dense | 12 | 100% | 100% | 0% | 100% | 100% | 1.17 | 1622 | 32 |
| local | hybrid | 12 | 100% | 100% | 0% | 100% | 100% | 1.08 | 1677 | 32 |
| local | graph | 12 | 83% | 83% | 0% | 100% | 100% | 1.58 | 706 | 30 |
| local | hybrid_graph | 12 | 92% | 92% | 0% | 100% | 100% | 1.33 | 1658 | 32 |

### By task and setting

| task | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| demo_leap_year | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 493 | 13 |
| demo_leap_year | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1416 | 22 |
| demo_leap_year | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1416 | 20 |
| demo_leap_year | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 493 | 13 |
| demo_leap_year | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1416 | 15 |
| t001_order_discount | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 686 | 53 |
| t001_order_discount | dense | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1539 | 40 |
| t001_order_discount | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1539 | 33 |
| t001_order_discount | graph | 3 | 33% | 33% | 0% | 100% | 100% | 2.33 | 1069 | 37 |
| t001_order_discount | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.67 | 1840 | 34 |
| t002_working_days | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 929 | 38 |
| t002_working_days | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.67 | 1851 | 56 |
| t002_working_days | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 1989 | 55 |
| t002_working_days | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 929 | 55 |
| t002_working_days | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.67 | 1912 | 56 |
| t003_transfer_fee | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 873 | 220 |
| t003_transfer_fee | dense | 3 | 33% | 33% | 0% | 100% | 67% | 2.67 | 1988 | 77 |
| t003_transfer_fee | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 1989 | 45 |
| t003_transfer_fee | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1634 | 30 |
| t003_transfer_fee | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2699 | 57 |
| t004_late_fee | none | 3 | 67% | 0% | 67% | 0% | 0% | 2.67 | 729 | 73 |
| t004_late_fee | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1400 | 20 |
| t004_late_fee | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1400 | 17 |
| t004_late_fee | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 985 | 18 |
| t004_late_fee | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1876 | 21 |
| t005_stock_reserve | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 717 | 126 |
| t005_stock_reserve | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1483 | 27 |
| t005_stock_reserve | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 1483 | 42 |
| t005_stock_reserve | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1241 | 36 |
| t005_stock_reserve | hybrid_graph | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1930 | 66 |
| t006_income_tax | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 857 | 21 |
| t006_income_tax | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1906 | 29 |
| t006_income_tax | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1905 | 36 |
| t006_income_tax | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 857 | 17 |
| t006_income_tax | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1906 | 30 |
| t007_region_summary | none | 3 | 100% | 0% | 100% | 0% | 0% | 2.00 | 883 | 66 |
| t007_region_summary | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1794 | 29 |
| t007_region_summary | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1780 | 26 |
| t007_region_summary | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1287 | 23 |
| t007_region_summary | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2371 | 39 |
| t008_overpayment | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 703 | 97 |
| t008_overpayment | dense | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1602 | 49 |
| t008_overpayment | hybrid | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1602 | 44 |
| t008_overpayment | graph | 3 | 67% | 67% | 0% | 100% | 67% | 1.67 | 1098 | 36 |
| t008_overpayment | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2246 | 40 |
| t009_shipping_weight | none | 3 | 33% | 0% | 33% | 0% | 0% | 3.00 | 753 | 157 |
| t009_shipping_weight | dense | 3 | 0% | 0% | 0% | 67% | 0% | 3.00 | 1629 | 173 |
| t009_shipping_weight | hybrid | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1583 | 168 |
| t009_shipping_weight | graph | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1345 | 94 |
| t009_shipping_weight | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| t009_shipping_weight | hybrid_graph | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 2179 | 129 |
| t010_loan_payment | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1053 | 63 |
| t010_loan_payment | dense | 3 | 67% | 67% | 0% | 100% | 100% | 2.33 | 1723 | 67 |
| t010_loan_payment | hybrid | 3 | 33% | 33% | 0% | 100% | 100% | 2.67 | 1771 | 84 |
| t010_loan_payment | graph | 3 | 67% | 67% | 0% | 100% | 67% | 2.33 | 1581 | 66 |
| t010_loan_payment | hybrid_graph | 3 | 33% | 33% | 0% | 100% | 100% | 2.67 | 2445 | 82 |
| t011_full_name | none | 3 | 33% | 33% | 0% | 100% | 100% | 2.33 | 544 | 27 |
| t011_full_name | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1315 | 23 |
| t011_full_name | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1398 | 19 |
| t011_full_name | graph | 3 | 33% | 33% | 0% | 100% | 100% | 3.00 | 543 | 36 |
| t011_full_name | hybrid_graph | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1397 | 26 |
