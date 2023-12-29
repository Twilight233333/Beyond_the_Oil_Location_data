
*************************************
* PREAMBLE
*************************************
clear all
set more off

log using "12391802 Extension.log", replace 

global dir "/Users/jiaxuan/Desktop/Replication HW"

global raw "$dir/raw_data"
global gen "$dir/generated_data"
global aux "$dir/generated_data/auxiliary_data"
global tab "$dir/raw_tables"
global edit_tab "$dir/Tex/tables"

*************************************
* LOAD AND TIDY DATA
*************************************
use dataset, replace 

* label variables
label variable on_conf onset_conflict
label variable escal escalation
label variable deescal de_escalation

* merge with my own data
merge 1:1 code year using "$dir/Oil_difficulty.dta"
drop if _merge == 2
drop _merge

* generate my independent variable
gen Oil_index = log(Oil_difficulty * price_bp)

sort group year

*************************************
* DESCRIPTIVE STATISTICS
*************************************

outreg2 using descriptive.doc, replace sum(log) keep(**country** **year** **conf** **on_conf** **end_conf** **war** **on_war** **end_war** **escal** **deescal** **num_reb** **avg_rebstr** **max_rebstr** **w_on_pr_g** **w_off_pr_g** **w_pr_g** **Oil_difficulty** **Oil_index**) title(Decriptive statistics)

*************************************
* Table 2 CONFLICT AND OIL WELL LOCATION (BREAK YEARS)
*************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Dependent: Conflict Escalation and De-escalation [binary variables]

set matsize 5000

xi:reghdfe escal w_pr_g, abs(group year) cluster(group)
outreg2 using t2.doc,replace tstat bdec(3) tdec(2) ctitle(escal)

xi:reghdfe escal w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(escal)

xi:reghdfe deescal w_pr_g, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(deescal)

xi:reghdfe deescal w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(deescal)

xi: reghdfe escal w_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(escal(1962-1990))

xi:reghdfe escal w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(escal(1962-1990))

xi:reghdfe deescal w_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(deescal(1962-1990))

xi:reghdfe deescal w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t2.doc,append tstat bdec(3) tdec(2) ctitle(deescal(1962-1990))
*******************************************
* Table 3C ONSET / INCIDENCE / TERMINATION OF CONFLICT (BREAK YEAR)
*******************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Dependent: Civil Conflict Onset / Incidence / Termination 

*CONFLICT*
xi:reghdfe on_c w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t3c.doc,replace tstat bdec(3) tdec(2) ctitle(on conflict)

xi:reghdfe conf w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t3c.doc,append tstat bdec(3) tdec(2) ctitle(conflict)

xi:reghdfe end_c w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t3c.doc,append tstat bdec(3) tdec(2) ctitle(off conflict)

xi:reghdfe on_c w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3c.doc,append tstat bdec(3) tdec(2) ctitle(on conflict(1962-1990))

xi:reghdfe conf w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3c.doc,append tstat bdec(3) tdec(2) ctitle(conflict(1962-1990))

xi:reghdfe end_c w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3c.doc,append tstat bdec(3) tdec(2) ctitle(off conflict(1962-1990))

*******************************************
* Table 3W ONSET / INCIDENCE / TERMINATION OF WAR (BREAK YEAR)
*******************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Dependent: Civil War Onset / Incidence / Termination 

*WAR*
xi:reghdfe on_w w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t3w.doc,replace tstat bdec(3) tdec(2) ctitle(on war)

xi:reghdfe war w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t3w.doc,append tstat bdec(3) tdec(2) ctitle(war)

xi:reghdfe end_w w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t3w.doc,append tstat bdec(3) tdec(2) ctitle(off war)

xi:reghdfe on_w w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3w.doc,append tstat bdec(3) tdec(2) ctitle(on war(1962-1990))

xi:reghdfe war w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3w.doc,append tstat bdec(3) tdec(2) ctitle(war(1962-1990))

xi:reghdfe end_w w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t3w.doc,append tstat bdec(3) tdec(2) ctitle(off war(1962-1990))

*************************************
* Table 4 REBEL NUMBER & STRENGTH (BREAK YEAR)
*************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Dependent: Number of rebel groups, Average & Maximum strength

xi:reghdfe d.num_reb w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t4.doc,replace tstat bdec(3) tdec(2) ctitle(number)

xi:reghdfe d.avg_rebstr w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t4.doc,append tstat bdec(3) tdec(2) ctitle(average)

xi:reghdfe d.max_rebstr w_on_pr_g w_off_pr_g , abs(group year) cluster(group)
outreg2 using t4.doc,append tstat bdec(3) tdec(2) ctitle(max)

xi:reghdfe d.num_reb w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t4.doc,append tstat bdec(3) tdec(2) ctitle(number(1962-1990))

xi:reghdfe d.avg_rebstr w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t4.doc,append tstat bdec(3) tdec(2) ctitle(average(1962-1990))

xi:reghdfe d.max_rebstr w_on_pr_g w_off_pr_g if year < 1991, abs(group year) cluster(group)
outreg2 using t4.doc,append tstat bdec(3) tdec(2) ctitle(max(1962-1990))

*************************************
* NARROW DOWN SCOPE TO 1962-1990
*************************************
drop if year > 1990

*************************************
* Table 5 CONFLICT AND OIL WELL LOCATION (REPLACE VARIABLE)
*************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Independent: Oil difficulty index
* Dependent: Conflict Escalation and De-escalation [binary variables]

set matsize 5000

xi:reghdfe escal w_pr_g, abs(group year) cluster(group)
outreg2 using t5.doc,replace tstat bdec(3) tdec(2) ctitle(escal)


xi:reghdfe escal w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t5.doc,append tstat bdec(3) tdec(2) ctitle(escal)

xi:reghdfe escal Oil_index, abs(group year) cluster(group)
outreg2 using t5.doc,append tstat bdec(3) tdec(2) ctitle(escal)


xi:reghdfe deescal w_pr_g, abs(group year) cluster(group)
outreg2 using t5.doc,append tstat bdec(3) tdec(2) ctitle(deescal)

xi:reghdfe deescal w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t5.doc,append tstat bdec(3) tdec(2) ctitle(deescal)

xi:reghdfe deescal Oil_index, abs(group year) cluster(group)
outreg2 using t5.doc,append tstat bdec(3) tdec(2) ctitle(deescal)

*******************************************
* Table 6C ONSET / INCIDENCE / TERMINATION OF CONFLICT (REPLACE VARIABLE)
*******************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Independent: Oil difficulty index
* Dependent: Civil Conflict Onset / Incidence / Termination 

*CONFLICT*
xi:reghdfe on_c w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t6c.doc,replace tstat bdec(3) tdec(2) ctitle(on conflict)

xi:reghdfe conf w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t6c.doc,append tstat bdec(3) tdec(2) ctitle(conflict)

xi:reghdfe end_c w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t6c.doc,append tstat bdec(3) tdec(2) ctitle(off conflict)

xi:reghdfe on_c Oil_index, abs(group year) cluster(group)
outreg2 using t6c.doc,append tstat bdec(3) tdec(2) ctitle(on conflict)

xi:reghdfe conf Oil_index, abs(group year) cluster(group)
outreg2 using t6c.doc,append tstat bdec(3) tdec(2) ctitle(conflict)

xi:reghdfe end_c Oil_index, abs(group year) cluster(group)
outreg2 using t6c.doc,append tstat bdec(3) tdec(2) ctitle(off conflict)

*******************************************
* Table 6W ONSET / INCIDENCE / TERMINATION OF WAR (REPLACE VARIABLE)
*******************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Independent: Oil difficulty index
* Dependent: Civil War Onset / Incidence / Termination 

*WAR*
xi:reghdfe on_w w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t6w.doc,replace tstat bdec(3) tdec(2) ctitle(on war)

xi:reghdfe war w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t6w.doc,append tstat bdec(3) tdec(2) ctitle(war)

xi:reghdfe end_w w_on_pr_g w_off_pr_g  , abs(group year) cluster(group)
outreg2 using t6w.doc,append tstat bdec(3) tdec(2) ctitle(off war)

xi:reghdfe on_w Oil_index, abs(group year) cluster(group)
outreg2 using t6w.doc,append tstat bdec(3) tdec(2) ctitle(on war)

xi:reghdfe war Oil_index, abs(group year) cluster(group)
outreg2 using t6w.doc,append tstat bdec(3) tdec(2) ctitle(war)

xi:reghdfe end_w Oil_index, abs(group year) cluster(group)
outreg2 using t6w.doc,append tstat bdec(3) tdec(2) ctitle(off war)

*************************************
* Table 7 REBEL NUMBER & STRENGTH (REPLACE VARIABLE)
*************************************
* Model: high-dimensional fixed effects panel data model
* Independent: Onshore and offshore oil production （𝛥 Price * % of GDP）
* Independent: Oil difficulty index
* Dependent: Number of rebel groups, Average & Maximum strength

xi:reghdfe d.num_reb w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t7.doc,replace tstat bdec(3) tdec(2) ctitle(number)

xi:reghdfe d.avg_rebstr w_on_pr_g w_off_pr_g, abs(group year) cluster(group)
outreg2 using t7.doc,append tstat bdec(3) tdec(2) ctitle(average)

xi:reghdfe d.max_rebstr w_on_pr_g w_off_pr_g , abs(group year) cluster(group)
outreg2 using t7.doc,append tstat bdec(3) tdec(2) ctitle(max)

xi:reghdfe d.num_reb Oil_index, abs(group year) cluster(group)
outreg2 using t7.doc,append tstat bdec(3) tdec(2) ctitle(number)

xi:reghdfe d.avg_rebstr Oil_index, abs(group year) cluster(group)
outreg2 using t7.doc,append tstat bdec(3) tdec(2) ctitle(average)

xi:reghdfe d.max_rebstr Oil_index, abs(group year) cluster(group)
outreg2 using t7.doc,append tstat bdec(3) tdec(2) ctitle(max)
