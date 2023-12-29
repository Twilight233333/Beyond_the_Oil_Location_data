
*************************************
* PREAMBLE
*************************************
clear all
set more off

log using "12391802 Extension Figure2.log", replace 

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

drop if year > 1990

*************************************
* DESCRIPTIVE PLOTS
*************************************

gen mean_Oil_index = 3.919
bysort country: egen mean_escalations =mean(escal) 
collapse mean_escalations Oil_index mean_Oil_index avg_on_w avg_off_w avg_tot_w, by(country)
keep if mean_escalations>0
gsort mean_escalations avg_tot_w
drop if avg_tot_w<0.01 
drop if avg_tot_w==.
g count=_n
egen max= max( count)
g Attractive_d=0 if Oil_index<mean_Oil_index
replace Attractive_d=1 if Oil_index>mean_Oil_index

separate mean_escalations, by(Attractive_d)
label var mean_escalations0 "Non Attractive"
label var mean_escalations1 "Attractive"
replace country="DR Congo" if country=="Democratic Republic of Congo"

graph hbar mean_escalations0 mean_escalations1 if count>max-15, over( country, sort(mean_escalations) descending label(angle(40) labsize(small))  )  bar(1,color(gs9)) bar(2, color(gs3)) nofill legend(order( 2 "Attractive" 1 "Non Attractive"))  vertical ytitle("Average conflict escalations (1962-1990)") scheme(sj)

graph export "f2.png", replace
