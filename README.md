# CO2-Emission-DV-App
R-Shiny application for data visualization of CO2 emissions on a vehicles dataset. 

The dataset captures the details of how CO2 emissions of a vehicle can vary depending on the different features 
of each vehicle. The sample is taken from a Canada Government official open data website 
(https://open.canada.ca/data/en/dataset/98f1a129-f628-4ce4-b24d-6f16bf24dd64#wb-auto-6). The 
dataset contains information for a total of 7,385 models. There are 12 columns showing information 
for the different models. The description of the headings is as follows: 
- Manufacturer: 42 different car makers 
- Model: sample models from each car maker   
- Vehicle Class: 16 categories of vehicle 
depending on the size and type of the vehicle  
- Engine Size (L): size of the engine of the vehicle 
in litres ranging from 0.9 to 8.4 
- Cylinders ( # of cylinders): number of cylinders 
from 3 to 16 
- Transmission: Indicates Manual/Automatic and 
number of gears 
 
- Fuel Type: fuel used for the vehicle  
- Fuel Consumption City (L/100 km): City 
consumption 
- Fuel Consumption Hwy (L/100 km): 
Highway consumption 
- Fuel Consumption Comb (L/100 km): 
Combined consumption 
- Fuel Consumption Comb (mpg): combined 
consumption in miles per gallon    
- CO2 Emissions(g/km) 
The abbreviations used for the different types of transmissions and fuel are the following: 
- Transmission: 
A = Automatic 
AM = Automated manual 
AS = Automatic with select shift 
AV = Continuously variable 
M = Manual 
3 - 10 = Number of gears 
 
- Fuel Type:  
X = Regular gasoline 
Z = Premium gasoline 
D = Diesel 
E = Ethanol (E85) 
N = Natural gas  
 
We read this data into R and complete a number of tasks.  
We collapse the levels of the following categorical variable into fewer categories as indicated next: 
- Transmission: collapse into either “Manual” or “Automatic” transmission 
  
1) We build  a  Shiny  app  or  dashboard  allowing  a  plot  for  any  combination  of  two  variables  to  be 
displayed.  
a. If two numerical variables are selected by the user, a scatterplot is shown.  
b. If one categorical variable and one numerical variable are chosen, the app instead 
display an appropriate boxplot.  
c. If two categorical variables are chosen, it display an appropriate barplot or 
count plot.  
d. Additionally, the app contain tabs that show the summary details of the dataset and 
histograms of the chosen variables (if appropriate). The user is informed of the plot(s) 
shown (or not shown) with the tab titles.  
2) We include a check box that will show the best straight line that fits the scatterplot, 
with  the  line  equation  and  coefficient  of  determination  value  also  shown  on  the  plot. We 
further  include  the  ability  to  show  different  factor  variables  by  colour  in  the  plot 
(scatterplot or boxplot). Neither of these abilities affect any other plots or tabs. The 
model only  be  fit  if  appropriate  variables  are  selected,  the  user  is informed 
otherwise  with  a  warning  message  that  the  regression  line  and/or  factor  separation  is  not 
applicable. 
3) Using Monte Carlo simulations, we attempt to predict the average CO2 emissions of 
a  vehicle  using  this  dataset.  For  this, we simulate  the  variable  CO2  emissions  using 
regression models fitted previously. One of the models should be the “reduced 
model” (best fitted model); for the other model/s we use a combination of independent 
variables  of  your  choice  (e.g.  find  the  best  regression  models  for  the  emissions  variable. 
Generate Monte Carlo simulations for the full and the reduced regression models to predict 
the average CO2 emissions of the vehicles). 
Note: the reduced regression model in this problem would be the following 
 𝐶𝑂2=𝛽0 +𝛽1𝐸𝑛𝑔.𝑠𝑖𝑧𝑒+𝛽2𝐶𝑦𝑙𝑖𝑛𝑑𝑒𝑟𝑠+𝛽3𝐹𝑢𝑒𝑙.𝑐𝑜𝑛𝑠𝑐𝑜𝑚𝑏+𝛽4𝐹𝑢𝑒𝑙.𝑐𝑜𝑛𝑠𝑚𝑝𝑔 + 𝜖  
4) We use the Monte Carlo simulations from before to  estimate the  values of the 
parameter  coefficients  of  the  reduced  regression  model  and  provide  an  estimation  of  the 
standard errors of the coefficients (i.e. estimate the 𝛽𝑖 parameters and their S.E.) 
