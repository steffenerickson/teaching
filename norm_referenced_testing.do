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
gen testscore = .8*ability + .9*ses + .2*rnormal()
sum testscore 
local min_value = r(min)
local max_value = r(max)
gen scalescore = 0 + (testscore  - `min_value') * (500 / (`max_value' - `min_value'))

sum testscore
local mean1 = r(mean)
local sd1 = r(sd)
local gain1 = round(`mean1' + `sd1',.001)
sum scalescore
local mean2 = r(mean)
local sd2 = r(sd)
local gain2 = round(`mean2' + `sd2',.001)
twoway  (hist testscore, color(purple%20) frequency xline(`mean1' `gain1' ,lcolor(red))) , name(g1,replace) title("Standardized Scores") xlabel(-4(1)4)  
twoway  (hist scalescore, color(purple%20) frequency xline(`mean2' `gain2' ,lcolor(red))), name(g2,replace) title("Scale scores") xlabel(0(50)500) xline(`mean2' `gain2' ,lcolor(red))
graph combine g1 g2 , title("Achievement Tests Are Norm Referenced") note("Students with a Scale Score of `gain2' are 1 standard deviation above the mean, performing better than 84% of the population.")

sum scalescore if race == 4
local race4 = r(mean)
sum scalescore if race == 7
local race7 = r(mean)
local diff = round(`race7' - `race4',.01)
twoway  (hist scalescore, color(purple%20) frequency)  (hist scalescore if race == 4, color(blue%20) frequency)  (hist scalescore if race == 7, color(green%20) frequency), xline(`race4' `race7' ,lcolor(red)) legend(order(1 "Total Population" 2 "Hispanic" 3 "White") pos(6) rows(1))  text(7000  390 "Avg(Scalescore|White) - Avg(score|Hispanic) = `diff'" , size(small)) xlabel(0(50)500) title("Comparing Groups with the Population Norm Referenced Scale" , size(medium))


// ---------------------------------------------------------------------------//
// How do we add meaning to norm referenced scales? 
// ---------------------------------------------------------------------------//

clear 
set obs 100000
gen student = _n
egen grade = cut(student) ,group(12)
tab grade, gen(grade_)
gen ability = rnormal()
gen testscore  = 1.7*ability + 1.5*grade_2 + 2.5*grade_3 + 3.2*grade_4 + 3.8*grade_5 + 4.2*grade_6 + 4.6*grade_7 + 5*grade_8 + 5.2*grade_9 + 5.4*grade_10 + 5.6*grade_11 + 5.7*grade_12 // loosely based on (Bloom, Howard S., et al.,2008) figure 1
sum testscore 
local min_value = r(min)
local max_value = r(max)
gen scalescore = 0 + (testscore  - `min_value') * (500 / (`max_value' - `min_value'))
hist scalescore 

sum scalescore if grade == 6
local grade6 = r(mean)
sum scalescore if grade == 7
local grade7 = r(mean)
sum scalescore if grade == 8
local grade8 = r(mean)
 
twoway   (hist scalescore if grade == 6, color(blue%20) frequency)  ///
		(hist scalescore if grade == 7, color(green%20) frequency) ///
		(hist scalescore if grade == 8, color(orange%20) frequency) ///
		, xline(`grade6' `grade7' `grade8' ,lcolor(red)) legend(order(1 "6th" 2 "*7th" 3 "8th") pos(6) rows(1))  /*text(7000  390 "Avg(Scalescore|White) - Avg(score|Hispanic) = `diff'" , size(small))*/ xlabel(0(50)500) title("Comparing Groups with the Population Norm Referenced Scale" , size(medium))

(hist scalescore if grade > 5 & grade < 9, color(purple%20) frequency)  /// 



sum scalescore if grade == 6
local grade6 = r(mean)
sum scalescore if grade == 7
local grade7 = r(mean)
twoway  (hist scalescore if grade == 6, color(blue%20) frequency)  ///
		(hist scalescore if grade == 7, color(green%20) frequency) ///
		, xline(`grade6' `grade7' ,lcolor(red)) legend(order(1 "6th" 2 "*7th") pos(6) rows(1))  xlabel(0(50)500) title("Comparing Groups with the Population Norm Referenced Scale" , size(medium))


hist scalescore if grade > 5 & grade < 9








twoway (hist testscore, color(purple%100)) 
sum testscore if race == 7
local race7 = r(mean)
sum testscore if race == 3
local race2 = r(mean)
twoway (hist testscore if race == 7, color(blue%20))  (hist testscore if race == 3, color(green%20)), xline(`race7' `race2' ,lcolor(red)) 

sum scalescore if race == 4
local race7 = r(mean)
sum scalescore if race == 2
local race2 = r(mean)
twoway (hist scalescore if race == 2, color(blue%20) frequency)  (hist scalescore if race == 4, color(green%20) frequency), xline(`race7' `race2' ,lcolor(red)) 

