import excel "C:\Users\DELL\OneDrive\FMT EXCEL (Source File) (final).xlsx", sheet("SUMMARY") firstrow

gen daily_date = date(DATE, "MDY")   // Convert Excel text data into Stata daily date format
format daily_date %td // Display the date in daily format (dd/mm/yyyy)
gen mdate = mofd(daily_date)
format mdate %tm
tsset mdate // Declare the data as monthly time series

rename INFLATION inf // Rename var Inflation as inf
rename BOEBASERATE intrate // Rename var BOE BASE RATE  as intrate
rename UNEMPLOYMENTRATE Unemp // Rename var Unemployment rate as Unemp
rename BRENTCRUDEOIL Cop // Rename var Brent Crude Oil Price as Cop

gen l_Cop = ln(Cop) // oil price (logged)

tsline inf intrate Unemp l_Cop // Plot time series graphs for all variables

hist inf // Show distribution of Inflation
hist intrate // Show distribution of BOE BASE RATE
hist Unemp // Show distribution of Exchange rate 
hist l_Cop // Show distribution of Brent Crude Oil Price 

scatter intrate Unemp l_Cop inf // Scatter plot of variables to see relationships

dfuller inf // ADF Test for Inflation 
dfuller intrate // ADF Test for BOE BASE RATE
dfuller Unemp // ADF Test for Unemployment rate
dfuller l_Cop // ADF Test for Crude Oil Price  

dfuller D.inf // ADF test on Inflation
dfuller D.intrate // ADF test on differenced BOE BASE RATE 
dfuller D.Unemp // ADF test on differenced Unemployment rate 
dfuller D.l_Cop // ADF test on differenced Crude Oil Price 

varsoc inf intrate Unemp l_Cop, maxlag(12) // Determine optimal VAR lag length for Variables

vecrank inf intrate Unemp l_Cop, lags(7) trend(constant)  // Determine number of cointegration relationships 

vec inf intrate Unemp l_Cop, lags(7) rank(1) trend(constant) // Estimate VEC 

veclmar // Test VECM residuals for autocorrelation using LM test

vecstable, graph // Check VECM stability using eigenvalue stability condition
