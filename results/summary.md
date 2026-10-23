# PLSQL-Fix results (233 runs, 22 tasks, models: gemma4:e4b)

### By setting

| setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|
| none | 46 | 48% | 24% | 24% | 28% | 28% | 2.33 | 766 | 76 |
| dense | 46 | 76% | 72% | 4% | 93% | 85% | 1.59 | 1621 | 48 |
| hybrid | 46 | 85% | 80% | 4% | 91% | 87% | 1.41 | 1623 | 45 |
| graph | 46 | 78% | 74% | 4% | 93% | 83% | 1.54 | 1068 | 35 |
| graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| hybrid_graph | 46 | 83% | 80% | 2% | 100% | 91% | 1.46 | 2019 | 46 |

### By bug location and setting

| category | setting | runs | solved | right_fix | workaround | bug_in_ctx | touched_bug | attempts | prompt_tok | seconds |
|---|---|---|---|---|---|---|---|---|---|---|
| cross_object | none | 33 | 33% | 0% | 33% | 0% | 0% | 2.70 | 789 | 97 |
| cross_object | dense | 33 | 67% | 61% | 6% | 91% | 79% | 1.76 | 1620 | 54 |
| cross_object | hybrid | 33 | 79% | 73% | 6% | 88% | 82% | 1.55 | 1603 | 50 |
| cross_object | graph | 33 | 76% | 70% | 6% | 91% | 76% | 1.55 | 1210 | 37 |
| cross_object | graph_h3 | 3 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1476 | 99 |
| cross_object | hybrid_graph | 33 | 79% | 76% | 3% | 100% | 88% | 1.52 | 2163 | 52 |
| local | none | 13 | 85% | 85% | 0% | 100% | 100% | 1.38 | 708 | 24 |
| local | dense | 13 | 100% | 100% | 0% | 100% | 100% | 1.15 | 1625 | 32 |
| local | hybrid | 13 | 100% | 100% | 0% | 100% | 100% | 1.08 | 1672 | 32 |
| local | graph | 13 | 85% | 85% | 0% | 100% | 100% | 1.54 | 708 | 29 |
| local | hybrid_graph | 13 | 92% | 92% | 0% | 100% | 100% | 1.31 | 1655 | 31 |

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
| t012_scholarship_fee | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 804 | 176 |
| t012_scholarship_fee | dense | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1588 | 30 |
| t012_scholarship_fee | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1589 | 28 |
| t012_scholarship_fee | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1120 | 21 |
| t012_scholarship_fee | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2091 | 25 |
| t013_stock_moves | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 891 | 60 |
| t013_stock_moves | dense | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1562 | 27 |
| t013_stock_moves | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1561 | 22 |
| t013_stock_moves | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1162 | 17 |
| t013_stock_moves | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2097 | 25 |
| t014_item_margin | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 665 | 57 |
| t014_item_margin | dense | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 1446 | 40 |
| t014_item_margin | hybrid | 1 | 0% | 0% | 0% | 100% | 0% | 3.00 | 1354 | 49 |
| t014_item_margin | graph | 1 | 0% | 0% | 0% | 100% | 0% | 3.00 | 974 | 32 |
| t014_item_margin | hybrid_graph | 1 | 0% | 0% | 0% | 100% | 100% | 3.00 | 1883 | 103 |
| t015_vat_synonym | none | 1 | 100% | 0% | 100% | 0% | 0% | 1.00 | 746 | 58 |
| t015_vat_synonym | dense | 1 | 100% | 0% | 100% | 0% | 0% | 1.00 | 1667 | 40 |
| t015_vat_synonym | hybrid | 1 | 100% | 0% | 100% | 0% | 0% | 1.00 | 1667 | 36 |
| t015_vat_synonym | graph | 1 | 100% | 0% | 100% | 100% | 0% | 1.00 | 974 | 33 |
| t015_vat_synonym | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1996 | 25 |
| t016_active_staff | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 644 | 39 |
| t016_active_staff | dense | 1 | 0% | 0% | 0% | 100% | 100% | 3.00 | 1398 | 50 |
| t016_active_staff | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1260 | 18 |
| t016_active_staff | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 800 | 18 |
| t016_active_staff | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1898 | 23 |
| t017_overdraft_limit | none | 1 | 100% | 0% | 100% | 0% | 0% | 1.00 | 813 | 28 |
| t017_overdraft_limit | dense | 1 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1605 | 35 |
| t017_overdraft_limit | hybrid | 1 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1605 | 40 |
| t017_overdraft_limit | graph | 1 | 100% | 0% | 100% | 100% | 0% | 1.00 | 1019 | 35 |
| t017_overdraft_limit | hybrid_graph | 1 | 100% | 0% | 100% | 100% | 0% | 1.00 | 2365 | 47 |
| t018_loyalty_points | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 824 | 133 |
| t018_loyalty_points | dense | 1 | 0% | 0% | 0% | 100% | 100% | 3.00 | 1493 | 64 |
| t018_loyalty_points | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1218 | 21 |
| t018_loyalty_points | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1210 | 18 |
| t018_loyalty_points | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2222 | 24 |
| t019_net_pay | none | 1 | 100% | 0% | 100% | 0% | 0% | 1.00 | 730 | 51 |
| t019_net_pay | dense | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1595 | 23 |
| t019_net_pay | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 2.00 | 1595 | 37 |
| t019_net_pay | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1051 | 17 |
| t019_net_pay | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 2157 | 25 |
| t020_phone_format | none | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 733 | 15 |
| t020_phone_format | dense | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1663 | 26 |
| t020_phone_format | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1616 | 25 |
| t020_phone_format | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 733 | 15 |
| t020_phone_format | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1617 | 26 |
| t021_ticket_due | none | 1 | 0% | 0% | 0% | 0% | 0% | 3.00 | 726 | 25 |
| t021_ticket_due | dense | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1621 | 26 |
| t021_ticket_due | hybrid | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1620 | 26 |
| t021_ticket_due | graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 905 | 15 |
| t021_ticket_due | hybrid_graph | 1 | 100% | 100% | 0% | 100% | 100% | 1.00 | 1893 | 26 |
