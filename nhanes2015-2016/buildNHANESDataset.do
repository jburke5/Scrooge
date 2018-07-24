cd "/Users/burke/Documents/research/scrooge/nhanes2015-2016/"

use using DEMO_I.dta

rename riagendr gender

label define genderLab 1 "Male" 2 "Female"
label values gender genderLab

rename ridageyr age

keep if age > 18

rename RIDRETH1  raceEth
label define raceEthLab 1	"Mexican American" 2 "Other Hispanic" 3	"Non-Hispanic White" 4 "Non-Hispanic Black" 6 "Non-Hispanic Asian"	7	"Other Race - Including Multi-Racial"
label values raceEth raceEthLab

keep seqn age gender raceEth WTINT2YR WTMEC2YR sdmvpsu sdmvstra

merge 1:1 seqn using BMX_I.dta, keepusing(bmxbmi) keep(master match) nogen
rename bmxbmi bmi

merge 1:1 seqn using DIQ_i.dta, keepusing(DIQ010) keep(master match) nogen
rename DIQ010 selfReportDiabetes

label define selfReportDMLab  1 "Yes" 2 "No" 3 "Borderline" 7 "Refused" 9 "Don't Know"
label values selfReportDiabetes selfReportDMLab

merge 1:1 seqn using SMQ_i.dta, keepusing(SMQ020 SMQ040 SMQ621 ) keep(master match) nogen


label define smokingStatusLab 0 "Never" 1 "Current" 2 "Former"
gen smokingStatus =  .
replace smokingStatus = 0 if SMQ020 == 2
replace smokingStatus = 1 if SMQ040 ==1 | SMQ040 == 2
replace smokingStatus = 2 if SMQ040 == 3

drop SMQ*


merge 1:1 seqn using BPQ_I.dta, keepusing(BPQ020 BPQ080 ) keep(master match) nogen

label define selfReportLab 1 "Yes" 2 "No" 7 "Refused" 9 "Don't Know"

rename BPQ020 selfReportHtn
rename BPQ080 selfReportHyperlipidemia

label values selfReportHtn selfReportLab
label values selfReportHyperlipidemia selfReportLab


svyset [w= WTINT2YR], psu( sdmvpsu) strata(sdmvstra)

rename seqn patientID

save nhanesForScrooge.dta, replace
