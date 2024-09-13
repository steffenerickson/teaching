/*
add chat gpt prompt and answer 
pick numbers that will be proportional to these numbers. I do not want the total to exceed 100,000
2.1 million were White;
14.4 million were Hispanic;
7.4 million were Black;
2.7 million were Asian;
2.5 million were of Two or more races;
449,000 million were American Indian/Alaska Native; and
182,000 were Pacific Islander.
*/

// ---------------------------------------------------------------------------//
// What is a scale score?
// How do we compare groups on a norm referenced score scale? 
// ---------------------------------------------------------------------------//
clear all 
mata categories = "White","Hispanic","Black","Asian","Two or more races","American Indian/Alaska Native","Pacific Islander"
mata counts = (44439,28955,14880,5429,5027,902,365)' // based on national distribution of student race categories
mata race = J(0,1,"")
mata for (i=1;i<=rows(counts);i++) race = race \ J(counts[i],1,categories[i])
tempvar temp
getmata `temp' = race
encode `temp', gen(race)
qui tab race, gen(race_)
gen ability = rnormal()
gen ses = .25*race_7 +  .1*race_6 + .15*race_5 + -.2*race_4 + -.3*race_3 + .35*race_2 + -.35*race_1
gen zscore = .8*ability + .9*ses + .2*rnormal()
sum zscore 
local min_value = r(min)
local max_value = r(max)
gen scalescore = 0 + (zscore  - `min_value') * (500 / (`max_value' - `min_value'))
// controlling for SES 
regress scalescore ses 
predict res, r 
sum res
local min_value = r(min)
local max_value = r(max)
gen newtest = 0 + (res  - `min_value') * (500 / (`max_value' - `min_value'))

//What is a scale score?
sum zscore
local mean1 = r(mean)
local sd1 = r(sd)
local gain1 = round(`mean1' + `sd1',.001)
sum scalescore
local mean2 = r(mean)
local sd2 = r(sd)
local gain2 = round(`mean2' + `sd2',.001)
twoway  (hist zscore, color(purple%20) frequency xline(`mean1' `gain1' ,lcolor(red))) , name(g1,replace) title("Z Scores") xlabel(-4(1)4)  
twoway  (hist scalescore, color(purple%20) frequency xline(`mean2' `gain2' ,lcolor(red))), name(g2,replace) title("Scale Scores") xlabel(0(50)500) xline(`mean2' `gain2' ,lcolor(red))
graph combine g1 g2 , title("Achievement Tests Are Norm Referenced") note("Students with a scale score of `gain2' are 1 standard deviation above the mean, performing better than 84% of the population")

// How do we compare groups on a norm referenced score scale? 
sum scalescore if race == 4
local race4 = r(mean)
sum scalescore if race == 7
local race7 = r(mean)
local diff = round(`race7' - `race4',.01)
twoway  (hist scalescore, color(purple%20) frequency) (hist scalescore if race == 4, color(blue%20) frequency) (hist scalescore if race == 7, color(green%20) frequency), xline(`race4' `race7' ,lcolor(red)) legend(order(1 "Total Population" 2 "Hispanic" 3 "White") pos(6) rows(1))  text(7000  390 "Avg(score|White) - Avg(score|Hispanic) = `diff'" , size(small)) xlabel(0(50)500) title("Comparing Groups with the Population Norm Referenced Scale" , size(medium))

// Explain away gaps with other factors
sum newtest if race == 4
local race4 = r(mean)
sum newtest if race == 7
local race7 = r(mean)
local diff = round(`race7' - `race4',.01)
twoway  (hist newtest, color(purple%20) frequency) (hist newtest if race == 4, color(blue%20) frequency) (hist scalescore if race == 7, color(green%20) frequency), xline(`race4' `race7' ,lcolor(red)) legend(order(1 "Total Population" 2 "Hispanic" 3 "White") pos(6) rows(1))  text(7000  390 "Avg(score|White,SES) - Avg(score|Hispanic,SES) = `diff'" , size(small)) xlabel(0(50)500) title("Other Factors Can Explain Gaps" , size(medium))
