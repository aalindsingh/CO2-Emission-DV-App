#Author - Alind Singh
#Load all the libraries required to build the shiny app
library(shiny)
library(tidyverse)
library(data.table)

#Load the data set
dataset <- read.csv('vehicles.csv',stringsAsFactors = TRUE)
View(dataset)
str(dataset)
head(dataset)
names(dataset)

#Convert variables into suitable form
dataset$Vehicle.Class <- as.factor(dataset$Vehicle.Class)
dataset$Transmission <- ifelse(grepl('A',dataset$Transmission),'Automatic','Manual')
dataset$Transmission <- as.factor(dataset$Transmission)
dataset$Cylinders <- as.numeric(dataset$Cylinders)
dataset$Fuel.Type <- as.factor(dataset$Fuel.Type)
dataset$Fuel.Consumption.City..L.100.km. <- 
  as.numeric(dataset$Fuel.Consumption.City..L.100.km.)
dataset$Fuel.Consumption.Comb..L.100.km. <-
  as.numeric(dataset$Fuel.Consumption.Comb..L.100.km.)
dataset$Fuel.Consumption.Comb..mpg. <- 
  as.numeric(dataset$Fuel.Consumption.Comb..mpg.)
dataset$Fuel.Consumption.Hwy..L.100.km. <-
  as.numeric(dataset$Fuel.Consumption.Hwy..L.100.km.)
dataset$CO2.Emissions.g.km. <- as.numeric(dataset$CO2.Emissions.g.km.)

#Convert into data frame
dataset_df <- data.frame(dataset)
str(dataset_df)
head(dataset_df)

non_numeric_data <- sapply(names(dataset_df), function(x) !is.numeric(dataset_df[[x]]))
dataset <- dataset_df

#Application's UI
app_ui <- fluidPage(
  titlePanel(
    h1("CO2 Emissions in Vehicles", align = "center", style='background-color:red;
       padding-left: 14px')
  ),
  
  sidebarPanel(
    sliderInput(
      "sampleSize", "Sample size (n)", min = 1, max = nrow(dataset),
      value = min(1000, nrow(dataset)), step = nrow(dataset)/50, round = 0
    ),
    radioButtons(
      "sampleType", "Sample type",
      choices = list("Random sample" = "random", "First 'n' sample" = "first")
    ),
    numericInput(
      "sampleSeed", "Sample seed", value = 1
    ),
    selectInput("x", "X-Axis", names(dataset)),
    selectInput("y", "Y-Axis", c("None", names(dataset)), names(dataset)[[2]]),
    selectInput("color", "Color", c("None", names(dataset)[non_numeric_data])),
    p("Jitter & Smoothing are available when 2 numeric variables are selected (Scatterplot)"),
    checkboxInput("jitter", "Add jitter to plotted graph"),
    checkboxInput("smooth", "Add best fit line to plotted graph")
  ),
  
  mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel("Plot", plotOutput("plot")),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabPanel("Monte Carlo Simulation", verbatimTextOutput("anova"))
    )
  )
)

#Server for shiny app
server <- function(input,output) {
  output$summary <- renderPrint({
    summary(dataset_df)
  })
  
  output$anova <- renderPrint({
    reduced_model = lm(CO2.Emissions.g.km. ~ Engine.Size.L.
                     + Cylinders + Fuel.Consumption.Comb..L.100.km.
                     + Fuel.Consumption.Comb..mpg., data = dataset_df)
    summary(reduced_model)
    anova(reduced_model)
    
    full_model = lm(CO2.Emissions.g.km. ~ Engine.Size.L.
                  + Cylinders + Fuel.Consumption.Comb..L.100.km.
                  + Fuel.Consumption.Comb..mpg. + Fuel.Consumption.City..L.100.km.
                  + Fuel.Consumption.Hwy..L.100.km., data = dataset_df)
    summary(full_model)
    anova(full_model)
    
    output1 <- anova(reduced_model,full_model)
    print(output1)
    
    predict(reduced_model, newdata = dataset_df)
    
    output2 <- predict(reduced_model, newdata = dataset_df,
                       interval = 'confidence')
    print(output2)
    
    output3 <- summary(reduced_model)
    print(output3)
    coef(summary(reduced_model))[,"Std. Error"]
  })
  
  exp1 <- reactive({
    if (input$sampleType == 'first') {
      1:input$sampleSize
    } else {
      set.seed(input$sampleSeed)
      sample(nrow(dataset_df), input$sampleSize)
    }
  })
  dataset <- reactive(dataset_df[exp1(),,drop = FALSE])
  
  plotType <- reactive({
    if(input$y != 'None')
      is.numeric(dataset_df[[input$x]]) + is.numeric(dataset_df[[input$y]])
    else
      -1
  })
  
  output$plot <- renderPlot({
    if(plotType() == 2){
      plot1 <- ggplot(dataset(), aes_string(x = input$x, y = input$y))
      
      if(input$jitter)
        plot1 <- plot1 + geom_jitter(alpha = 0.5)
      else 
        plot1 <- plot1 + geom_point(alpha = 0.5)
      
      if(input$smooth)
        plot1 <- plot1 + geom_smooth(method = 'lm')
    }
    else if(plotType() == 1){
      plot1 <- ggplot(dataset(), aes_string(x=input$x,y=input$y)) +
        geom_boxplot()
      if(input$color != 'None')
        plot1 <- plot1 + aes_string(fill=input$color)
    }
    else if(plotType() == 0){
      plot1 <- ggplot(dataset(), aes_string(x=input$x)) +
        geom_bar()
      if(input$color != 'None')
        plot1 <- plot1 + aes_string(fill=input$color)
    }
    else{
      plot1 <- ggplot(dataset(), aes_string(x=input$x))
      if(is.numeric(dataset_df[[input$x]])) {
        plot1 <- plot1 + geom_histogram()
      } else{
        plot1 <- plot1 + geom_bar()
      }
      
      if(input$color != 'None'){
        plot1 <- plot1 + aes_string(fill=input$color)
      }
    }
    
    if(plotType() == 0){
      plot1 <- plot1 + labs(title = paste("Barplot for ",input$y,'v/s',input$x))
    }
    else if(plotType() == 1){
      plot1 <- plot1 + labs(title = paste("Boxplot for ",input$y,'v/s',input$x))
    }
    else if(plotType() == 2){
      plot1 <- plot1 + labs(title = paste("Scatterplot for ",input$y,'v/s',input$x))
    }
    else{
      plot1 <- plot1 + labs(title = paste("Histogram of ",input$x))
    }
    
    plot1 <- plot1 + theme_bw() +
      theme(plot.title = element_text(size = rel(1.9), face = 'bold', hjust = 0.6),
            axis.title = element_text(size = rel(1.6)))
    print(plot1)
  }, height = 700)
}

#Run the application
shinyApp(ui = app_ui, server = server)