# PLSQL-Fix results (333 runs, 22 tasks, models: gemma4:e4b)

### By setting

| setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|
| none | 66 | 48% | 20% | 29% | 23% | 23% | 2.27 | 763 | 72 |
| dense | 66 | 80% | 71% | 9% | 89% | 80% | 1.48 | 1600 | 44 |
| hybrid | 66 | 86% | 77% | 9% | 91% | 82% | 1.38 | 1588 | 40 |
| graph | 66 | 82% | 73% | 9% | 95% | 80% | 1.45 | 1046 | 32 |
| graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| hybrid_graph | 66 | 85% | 80% | 5% | 100% | 91% | 1.38 | 2023 | 42 |

### By bug location and setting

| category | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| cross_object | none | 51 | 37% | 0% | 37% | 0% | 0% | 2.55 | 779 | 86 |
| cross_object | dense | 51 | 75% | 63% | 12% | 86% | 75% | 1.59 | 1591 | 47 |
| cross_object | hybrid | 51 | 82% | 71% | 12% | 88% | 76% | 1.47 | 1565 | 43 |
| cross_object | graph | 51 | 80% | 69% | 12% | 94% | 75% | 1.45 | 1144 | 34 |
| cross_object | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| cross_object | hybrid_graph | 51 | 82% | 76% | 6% | 100% | 88% | 1.41 | 2133 | 45 |
| local | none | 15 | 87% | 87% | 0% | 100% | 100% | 1.33 | 711 | 23 |
| local | dense | 15 | 100% | 100% | 0% | 100% | 100% | 1.13 | 1630 | 31 |
| local | hybrid | 15 | 100% | 100% | 0% | 100% | 100% | 1.07 | 1665 | 32 |
| local | graph | 15 | 87% | 87% | 0% | 100% | 100% | 1.47 | 711 | 27 |
| local | hybrid_graph | 15 | 93% | 93% | 0% | 100% | 100% | 1.27 | 1650 | 30 |

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
| t012_scholarship_fee | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 804 | 132 |
| t012_scholarship_fee | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1588 | 32 |
| t012_scholarship_fee | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.67 | 1575 | 32 |
| t012_scholarship_fee | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1120 | 20 |
| t012_scholarship_fee | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2091 | 25 |
| t013_stock_moves | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 890 | 67 |
| t013_stock_moves | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1562 | 27 |
| t013_stock_moves | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1562 | 22 |
| t013_stock_moves | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1162 | 16 |
| t013_stock_moves | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2098 | 25 |
| t014_item_margin | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 665 | 59 |
| t014_item_margin | dense | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1446 | 69 |
| t014_item_margin | hybrid | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1354 | 41 |
| t014_item_margin | graph | 3 | 0% | 0% | 0% | 100% | 33% | 3.00 | 974 | 52 |
| t014_item_margin | hybrid_graph | 3 | 0% | 0% | 0% | 100% | 100% | 3.00 | 1884 | 85 |
| t015_vat_synonym | none | 3 | 100% | 0% | 100% | 0% | 0% | 1.33 | 746 | 47 |
| t015_vat_synonym | dense | 3 | 100% | 0% | 100% | 0% | 0% | 1.00 | 1667 | 39 |
| t015_vat_synonym | hybrid | 3 | 100% | 0% | 100% | 0% | 0% | 1.00 | 1667 | 37 |
| t015_vat_synonym | graph | 3 | 100% | 0% | 100% | 100% | 0% | 1.33 | 974 | 40 |
| t015_vat_synonym | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1996 | 26 |
| t016_active_staff | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 644 | 38 |
| t016_active_staff | dense | 3 | 67% | 67% | 0% | 100% | 100% | 1.67 | 1307 | 31 |
| t016_active_staff | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1261 | 19 |
| t016_active_staff | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 800 | 16 |
| t016_active_staff | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1898 | 23 |
| t017_overdraft_limit | none | 3 | 100% | 0% | 100% | 0% | 0% | 1.00 | 813 | 29 |
| t017_overdraft_limit | dense | 3 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1605 | 36 |
| t017_overdraft_limit | hybrid | 3 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1605 | 40 |
| t017_overdraft_limit | graph | 3 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1019 | 35 |
| t017_overdraft_limit | hybrid_graph | 3 | 100% | 0% | 100% | 100% | 0% | 1.00 | 2365 | 45 |
| t018_loyalty_points | none | 3 | 67% | 0% | 67% | 0% | 0% | 2.33 | 824 | 105 |
| t018_loyalty_points | dense | 3 | 67% | 67% | 0% | 100% | 100% | 2.00 | 1493 | 42 |
| t018_loyalty_points | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1218 | 20 |
| t018_loyalty_points | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1210 | 19 |
| t018_loyalty_points | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2287 | 26 |
| t019_net_pay | none | 3 | 100% | 0% | 100% | 0% | 0% | 1.00 | 731 | 38 |
| t019_net_pay | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1595 | 22 |
| t019_net_pay | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.33 | 1595 | 29 |
| t019_net_pay | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1052 | 23 |
| t019_net_pay | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2157 | 26 |
| t020_phone_format | none | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 733 | 17 |
| t020_phone_format | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1663 | 25 |
| t020_phone_format | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1617 | 33 |
| t020_phone_format | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 733 | 17 |
| t020_phone_format | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1617 | 25 |
| t021_ticket_due | none | 3 | 0% | 0% | 0% | 0% | 0% | 3.00 | 726 | 97 |
| t021_ticket_due | dense | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1621 | 25 |
| t021_ticket_due | hybrid | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1620 | 25 |
| t021_ticket_due | graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 905 | 17 |
| t021_ticket_due | hybrid_graph | 3 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1893 | 25 |
