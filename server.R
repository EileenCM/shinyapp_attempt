library(shiny)

#This function does a lot more calculation than you usually see in a Shiny app.
#Because evaluations and calculations require a reactive environment, I had to
#use the reactive() function in almost every line.  (There's probably a better way to 
#do this.)

shinyServer(
  function(input,output) {
    
    #Basic variable assignments.
    
    price<-reactive({as.numeric(input$iPrice)})
    down<-reactive({as.numeric(input$iDown)})
    
    term<-reactive({12*as.numeric(input$iYears)})
    rate1<-reactive({as.numeric(input$irate1)})
  
    rate2<-reactive({as.numeric(input$irate2)})
    points2<-reactive({as.numeric(input$iPts2)})
    
    #Calculations of monthly payment amounts. The formulas are standard in the
    #actuarial world where I used to work, but are probably difficult for an
    #outsider to follow.
    
    net<-reactive({price()-down()})
    vn1<-reactive({1/((1+rate1()/1200)^term())})
    factor1<-reactive({(1-vn1())/(rate1()/1200)})
    monthly1<-reactive({net()/factor1()})
                            
    vn2<-reactive({1/((1+rate2()/1200)^term())})
    factor2<-reactive({(1-vn2())/(rate2()/1200)})
    monthly2<-reactive({net()/factor2()})   
   
    #This section applies the time value of your money (what you earn on your savings)
    #and calculates the accumulated costs of each mortgage for each month. (FV1 and
    #FV2)
    
    accumrate<-reactive({(as.numeric(input$iaccumrate))/12})
    
    vns<-reactive({1/(1+accumrate())^(1:term())})
    PV1<-reactive({c(0,(monthly1()*vns()))})
    PV11<-reactive({cumsum(PV1())})
    FV1<-reactive({PV11()*(1+accumrate())^(0:term())})
    
    PV2<-reactive({c((points2()*net()/100),(monthly2()*vns()))})
    PV22<-reactive({cumsum(PV2())})
    FV2<-reactive({PV22()*(1+accumrate())^(0:term())})
    
    #Accumulated cost with points, minus accumulated costs without.
    #The break even is when diff == 0.
    
    diff<-reactive({FV2()-FV1()})
    
    output$compaccum<-renderPlot({
      plot(as.numeric(0:term()),as.numeric(diff()),type="l",col="red",main="Accumulated Difference of Payments Made")
      abline(h=0,col="black")
    })                 
                      
    output$text1<-renderText({monthly1()})
    output$text2<-renderText({monthly2()})
    
  }
  )