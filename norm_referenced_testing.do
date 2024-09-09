/*
add chat gpt prompt and answer 

pick number that will be proportional to these numbers. I do not want the total to exceed 100,000

2.1 million were White;
14.4 million were Hispanic;
7.4 million were Black;
2.7 million were Asian;
2.5 million were of Two or more races;
449,000 million were American Indian/Alaska Native; and
182,000 were Pacific Islander.

*/

clear all 
mata categories = "White","Hispanic","Black","Asian","Two or more races","American Indian/Alaska Native","Pacific Islander"
mata counts = (44439,28955,14880,5429,5027,902,365)'
mata race = J(0,1,"")
mata for (i=1;i<=rows(counts);i++) race = race \ J(counts[i],1,categories[i])
tempvar temp
getmata `temp' = race
encode `temp', gen(race)
qui tab race, gen(race_)
gen ability = rnormal()
gen testscore = .8*ability + -.5*race_1 + .7*race_2 + -.8*race_3 + -.3*race_4 + .4*race_5 + .07*race_6 + .2*rnormal()
sum testscore 
local min_value = r(min)
local max_value = r(max)
gen scalescore = 400 + (testscore  - `min_value') * (200 / (`max_value' - `min_value'))

twoway (hist testscore, color(purple%100)) 
sum testscore if race == 7
local race7 = r(mean)
sum testscore if race == 3
local race2 = r(mean)
twoway (hist testscore if race == 7, color(blue%20))  (hist testscore if race == 3, color(green%20)), xline(`race7' `race2' ,lcolor(red)) 

sum scalescore if race == 7
local race7 = r(mean)
sum scalescore if race == 3
local race2 = r(mean)
twoway (hist scalescore if race == 7, color(blue%20))  (hist scalescore if race == 3, color(green%20)), xline(`race7' `race2' ,lcolor(red)) 


