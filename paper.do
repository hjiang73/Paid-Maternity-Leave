*********************
*********************
clear all
collapse (mean) dbirwt dgestat gestat3 dtotord, by(datayear birmon statenat dmage dmeduc mrace frace dfage dfeduc csex citrspop metrores dmar)

drop if dgestat == 00
drop if dgestat == 99
drop if dbirwt == 9999
drop if dtotord == 99
drop if dmeduc>17
drop if mrace ==9
drop if frace ==9

drop if dfeduc>17
drop if citrspop =="9"
drop if citrspop =="Z"
drop if metrores =="Z"

gen post = datayear>1978
replace post =1 if datayear ==1978 & birmon ==12

gen treatment = statenat=="05"|statenat=="12"|statenat=="31"|statenat=="33"|statenat=="40"

gen pt = post*treatment

use "/Users/hanjiang0325/Desktop/dataset/collapseddata.dta"
*********************
**birthweight********
*********************
*1. OLS
reg dbirwt post treatment pt, r
est sto m1
*2. fixed effects
**(year of birth fixed ,month of birth fixed, state fixed effects)
xi: reg dbirwt post treatment pt i.datayear i.birmon i.state 
est sto m2
*3.timetrend

xi: reg dbirwt post treatment pt i.state*datayear
est sto m3
*4 add controls
*controls
*mwhite mblack mother mage19 mage25 mage35 mage45 meduchs meducsc meducc 
*fwhite fblack fother fage19 fage25 fage35 fage45 feduchs feducsc feducc 
*citrspop
*metrores
xi: reg dbirwt post treatment pt csex mwhite mblack mother mage19 mage25 mage35 mage45 meduchs meducsc meducc fwhite fblack fother fage19 fage25 fage35 fage45 feduchs feducsc feducc citrspop metrores i.state*datayear 
est sto m4

esttab m1 m2 m3 m4, label nonumber title("Effects of TDI maternity leave on birth weight(grams)") mtitle("DD" "DD with fixed effects" "DD with time trend" "DD with controls") coeflabel(post "POST" treatment "TREATMENT"  pt "POST*TREATMENT" _cons "Constant")



*lowbirthweight
gen lowwt = dbirwt<2500
logit lowwt post treatment pt, r
est sto m1
xi: logit lowwt post treatment pt i.datayear i.birmon i.state
est sto m2
xi: logit lowwt post treatment pt i.state*datayear
est sto m3
xi: logit lowwt post treatment pt csex mwhite mblack mother mage19 mage25 mage35 mage45 meduchs meducsc meducc fwhite fblack fother fage19 fage25 fage35 fage45 feduchs feducsc feducc citrspop metrores i.state*datayear 
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Effects of TDI maternity leave on low birth weight") mtitle("DD" "DD with fixed effects" "DD with time trend" "DD with controls") coeflabel(post "POST" treatment "TREATMENT"  pt "POST*TREATMENT" _cons "Constant")

*gestitation in weeks
reg dgestat post treatment pt, r
est sto m1
xi: reg dgestat post treatment pt i.datayear i.birmon i.state 
est sto m2
xi: reg dgestat post treatment pt i.state*datayear
est sto m3
xi: reg dgestat post treatment pt csex mwhite mblack mother mage19 mage25 mage35 mage45 meduchs meducsc meducc fwhite fblack fother fage19 fage25 fage35 fage45 feduchs feducsc feducc citrspop metrores i.state*datayear 
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Effects of TDI maternity leave on gestation weeks") mtitle("DD" "DD with fixed effects" "DD with time trend" "DD with controls") coeflabel(post "POST" treatment "TREATMENT"  pt "POST*TREATMENT" _cons "Constant")


*premature
gen premature = dgestat<37
logit premature post treatment pt, r
est sto m1
xi: logit premature post treatment pt i.datayear i.birmon i.state
est sto m2
xi: logit premature post treatment pt i.state*datayear
est sto m3
xi: logit premature post treatment pt csex mwhite mblack mother mage19 mage25 mage35 mage45 meduchs meducsc meducc fwhite fblack fother fage19 fage25 fage35 fage45 feduchs feducsc feducc citrspop metrores i.state*datayear 
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Effects of TDI maternity leave on premature") mtitle("DD" "DD with fixed effects" "DD with time trend" "DD with controls") coeflabel(post "POST" treatment "TREATMENT"  pt "POST*TREATMENT" _cons "Constant")



*robust check
gen t1 = datayear ==1972
gen t2 = datayear ==1973
gen t3 = datayear ==1974
gen t4 = datayear ==1975
gen t5 = datayear ==1976
gen t6 = datayear ==1977
gen t7 = datayear ==1978
gen t8 = datayear ==1979
gen t9 = datayear ==1980
gen t10 = datayear ==1981
gen t11= datayear ==1982
gen t12 = datayear ==1983
gen t13 = datayear ==1984
gen t14 = datayear ==1985

gen t1t= t1*treatment 
gen t2t= t2*treatment 
gen t3t= t3*treatment 
gen t4t= t4*treatment 
gen t5t= t5*treatment 
gen t6t= t6*treatment 
gen t7t= t7*treatment 
gen t8t= t8*treatment 
gen t9t= t9*treatment 
gen t10t= t10*treatment 
gen t11t= t11*treatment 
gen t12t= t12*treatment 
gen t13t= t13*treatment 
gen t14t= t14*treatment 

xi: reg dbirwt post treatment pt t6t i.state*datayear
est sto m1
xi: logit lowwt post treatment pt t6t i.state*datayear
est sto m2
xi: reg dgestat post treatment pt t6t i.state*datayear
est sto m3
xi: logit premature post treatment pt t6t i.state*datayear
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Placebo effects") mtitle("Birthweight" "Low Birthweight" "Gestation" "Premature")


xi: reg dbirwt post treatment pt t7t i.state*datayear
est sto m1
xi: logit lowwt post treatment pt t7t i.state*datayear
est sto m2
xi: reg dgestat post treatment pt t7t i.state*datayear
est sto m3
xi: logit premature post treatment pt t7t i.state*datayear
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Placebo effects") mtitle("Birthweight" "Low Birthweight" "Gestation" "Premature")

xi: reg dbirwt post treatment pt t8t i.state*datayear
est sto m1
xi: logit lowwt post treatment pt t8t i.state*datayear
est sto m2
xi: reg dgestat post treatment pt t8t i.state*datayear
est sto m3
xi: logit premature post treatment pt t8t i.state*datayear
est sto m4
esttab m1 m2 m3 m4, label nonumber title("Placebo effects") mtitle("Birthweight" "Low Birthweight" "Gestation" "Premature")


xi: reg dbirwt post treatment pt i.datayear i.birmon i.state if !(mwhite==1&meducc==1&fwhite==1&feducc==1&(mage19==1|mage25==1))
est sto m1
xi: logit lowwt post treatment pt i.datayear i.birmon i.state if !(mwhite==1&meducc==1&fwhite==1&feducc==1&(mage19==1|mage25==1))
est sto m2
xi: reg dgestat post treatment pt i.datayear i.birmon i.state if !(mwhite==1&meducc==1&fwhite==1&feducc==1&(mage19==1|mage25==1))
est sto m3
xi: logit premature post treatment pt i.datayear i.birmon i.state if !(mwhite==1&meducc==1&fwhite==1&feducc==1&(mage19==1|mage25==1))
est sto m4

reg dgestat post treatment pt if mwhite ==1 & meducc==1,r
esttab m1 m2 m3 m4, label nonumber title("Sample from other families") mtitle("Birthweight" "Low Birthweight" "Gestation" "Premature") coeflabel(post "POST" treatment "TREATMENT"  pt "POST*TREATMENT")





