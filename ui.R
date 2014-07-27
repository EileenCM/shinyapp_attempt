shinyUI(
  
  #Running this app requires you be in RStudio in a directory with ui.R and server.R
  #runApp to start.
  
  #When you apply for a mortgage, very often the lender will offer you two rates:
  #one rate with no points required, and a lower rate that requires points. 
  #Points are a percentage of the loan amount paid upfront on the day of settlement.
  #More money is required at settlement, but the return is a lower monthly note (P&I)
  #consisting of Principle (the amount that goes to pay down your loan balance) and
  #Interest (the amount paid each month to the lender for allowing you to use his money 
  #to buy your house).
  
  #This app does not deal with the tax implications of a mortgage, not the Escrow
  #amounts that may be required each month.
  
  #The user enters the purchase price of the home, the down payment, the length of the
  #loan, and the competing interest rate offers.  The bottom check box basically
  #gauges how valuable your money is:  is it only earning .5% in a savings account, 
  #or do you usually put your savings into CDs or a money market fund.  These have
  #higher rates of return in general, and makes your money more valuable to you.
  
  #The output allows you to compare the monthly payments, and the graph shows the
  #Break-even point.  If you are only going to be in the home a short while (2 - 5 years)
  #the initial cost of the points is not worth the monthly savings.  The break-even
  #point is usually between 8 and 20 years.  After that time you will begin to see the
  #advantage of having a lower interest rate.
  
  
  fluidPage(
  titlePanel("Mortgage Rate Comparison"),
  sidebarPanel(
    numericInput('iPrice','House price:', 0,min=50000,max=750000),
    numericInput('iDown',"Down payment:", 0,min=0,max=700000),
    
    checkboxGroupInput('iYears','Years:',c("30","15","7","5"),selected="30",inline=TRUE),
    numericInput('irate1','Rate 1:', min=0,max=6,value=4,step=.125),
    numericInput('irate2','Rate 2:', min=0,max=6,value=4,step=.125),
    numericInput('iPts2','points:', 0, min=0,max=4),
    checkboxGroupInput('iaccumrate','I normally put my savings in a:',
                       c('savings account'='0.005','CD'='0.02',
                         'mutual fund or stocks'='0.06'),selected='0'),
    submitButton("Compare")
    ),
  mainPanel(
    p('Monthly P&I 1:'),
    verbatimTextOutput('text1'),
    p('Monthly P&I 2:'),
    verbatimTextOutput('text2'),
    plotOutput('compaccum')
    
    
    )
))
