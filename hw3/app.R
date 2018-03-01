library(tidyverse)
library(ggplot2)
library(shiny)

lapayroll <- read.csv("/home/m280-data/la_payroll/LA_City_Employee_Payroll.csv")
lapayroll1 <- lapayroll[, c(2, 3, 6, 16, 17, 22, 24, 30, 33)]
# substract dollar sign
lapayroll1$Totpay = abs(as.numeric(gsub("\\$", "", lapayroll1$Total.Payments)))
lapayroll1$Basepay = abs(as.numeric(gsub("\\$", "", lapayroll1$Base.Pay)))
lapayroll1$Overpay = abs(as.numeric(gsub("\\$", "", lapayroll1$Overtime.Pay)))
lapayroll1$Otherpay = abs(as.numeric(gsub("\\$", "", 
                                      lapayroll1$Other.Pay..Payroll.Explorer)))
lapayroll1$Totcost = abs(as.numeric(gsub("\\$", "", 
                                     lapayroll1$Average.Benefit.Cost)))
lapayroll1$Healthcost = abs(as.numeric(gsub("\\$", "", 
                                        lapayroll1$Average.Health.Cost)))
lapayroll1 <- lapayroll1[, -c(4,5,6,7,8,9)]
names(lapayroll1)[2] <- "Department"
names(lapayroll1)[3] <- "Job"

#delete large numbers
lapayroll1 <- lapayroll1[complete.cases(lapayroll1),]

# save as RDS file
saveRDS(lapayroll1, file = "lapayroll1.rds")
LApayroll <- readRDS(file = "lapayroll1.rds")

#generate a new dataset to show LA payroll (Q1.2)
pay2 <- LApayroll %>% select(Year, Basepay, Overpay, Otherpay) %>%
              group_by(Year) %>%
              summarise(TotBasepay = sum(Basepay, na.rm = TRUE),
                        TotOverpay = sum(Overpay, na.rm = TRUE),
                        TotOtherpay = sum(Otherpay, na.rm = TRUE)) %>%
             gather(TotBasepay, TotOverpay, TotOtherpay, key = "variable", 
                    value = "value")

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("LA City Employee Payroll"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "Year",
                  label = "Year:",
                  choices = c("2017", "2016", "2015", "2014", "2013")),
      numericInput(inputId = "n1",
                   label = "Number of employees to view:",
                   value = 10),
      numericInput(inputId = "n2",
                   label = "Number of departments to view:",
                   value = 5),
      radioButtons(inputId = "Method",
                  label = "Choose a method:",
                  choices = c("Median", "Mean")),
      textInput(inputId = "Department",
                label = "Department:",
                value = "Police (LAPD)")
     
    ),
    # Main panel for displaying outputs ----
    mainPanel(
    h3("By: Nan Chen", align = "Right"),
      # Output: plot and table for data summary ----
      tabsetPanel(type = "tabs",
                  tabPanel("LA Total Payroll Plot", plotOutput("barPlot")),
                  
                  tabPanel("Who Earned Most", tableOutput("table_Q3")),
                  
                  tabPanel("Which Department Earn Most", 
                           tableOutput("table_Q4")),
                  
                  tabPanel("Which Department Cost Most",
                           tableOutput("table_Q5")),
                  
                  tabPanel("Healthcost Trend over Years",
                           plotOutput("smoothPlot"))
                  )
      
    )
  )
)

server <- function(input, output) {

  output$barPlot <- renderPlot({
    ggplot(pay2, aes(x = Year, y = value / 1000000, fill = variable)) +
    geom_col() +
    labs(x = "Year", y = "Pay(million)") +
    scale_fill_manual(values = c("#D55E00", "#009E73", "#0072B2"),
                      name="Type of Pay",
                      breaks=c("TotBasepay", "TotOverpay", "TotOtherpay"),
                      labels=c("Total Basepay", "Total Overtimepay", 
                                 "Total Otherpay"))
  })
  
  output$table_Q3 <- renderTable({
    LApayroll %>%
      filter(Year == input$Year) %>%
      select(Totpay, Basepay, Overpay, Otherpay, Department, Job) %>%
      arrange(desc(Totpay)) %>%
      head(n = input$n1)
  })
  
  #choose a method
  output$table_Q4 <- renderTable({
    if (input$Method == "Median") {
      LApayroll %>% filter(Year == input$Year) %>%
        group_by(Department) %>%
        summarise(MedianTotal = median(Totpay, na.rm = TRUE),
                  MedianBase = median(Basepay, na.rm = TRUE),
                  MedianOver = median(Overpay, na.rm = TRUE),
                  MedianOther = median(Otherpay, na.rm = TRUE)) %>%
        arrange(desc(MedianTotal)) %>%
        select(Department, MedianTotal, MedianBase, MedianOver, MedianOther) %>%
        head(n = input$n2)
    }else{
      LApayroll %>% filter(Year == input$Year) %>%
        group_by(Department) %>%
        summarise(MeanTotal = mean(Totpay, na.rm = TRUE),
                  MeanBase = mean(Basepay, na.rm = TRUE),
                  MeanOver = mean(Overpay, na.rm = TRUE),
                  MeanOther = mean(Otherpay, na.rm = TRUE)) %>%
        arrange(desc(MeanTotal)) %>%
        select(Department, MeanTotal, MeanBase, MeanOver, MeanOther) %>%
        head(n = input$n2)
    }
      })
  
  output$table_Q5 <- renderTable({
    LApayroll %>%
      filter(Year == input$Year) %>% 
      group_by(Department) %>%
      summarise(
        sumTotcost = sum(Totcost), sumBasepay = sum(Basepay), 
        sumOverpay = sum(Overpay), sumOtherpay = sum(Otherpay)
      ) %>%
      arrange(desc(sumTotcost)) %>%
      select(Department, sumTotcost, sumBasepay, sumOverpay, sumOtherpay) %>%
      head(n = input$n2)
    
  })
  
  output$smoothPlot <- renderPlot({
    health6 <- LApayroll %>% filter(Department == input$Department) %>%
      group_by(Year) %>%
      summarise(TotHealthcost = sum(Healthcost, na.rm = TRUE)) %>%
      select(Year, TotHealthcost)
    ggplot(health6, aes(x = Year, y = TotHealthcost / 1000000)) +
      labs(x = "Year", y = "Health Cost (million)") +
      geom_point() +
      geom_smooth()
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)


