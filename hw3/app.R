library(tidyverse)
library(ggplot2)
library(magrittr)
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
                  choices = c("2017", "2014", "2015", "2016", "2013")),
      numericInput(inputId = "n1",
                   label = "Number of employees to view:",
                   value = 10),
      numericInput(inputId = "n2",
                   label = "Number of departments to view:",
                   value = 5),
      radioButtons(inputId = "Method",
                  label = "Choose a method:",
                  choices = c("Median", "Mean"))
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: plot and table for data summary ----
      tabsetPanel(type = "tabs",
                  tabPanel("LA Total Payroll Plot", plotOutput("barPlot")),
                  
                  tabPanel("Who Earned Most", tableOutput("table_Q3")),
                  
                  tabPanel("Which Department Earn Most", 
                           tableOutput("table_Q4")),
                  
                  tabPanel("Which Department Cost Most",
                           tableOutput("table_Q5"))
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
    data_Q3 <- LApayroll %>%
      filter(Year == input$Year) %>%
      select(Totpay, Basepay, Overpay, Otherpay, Department.Title, 
             Job.Class.Title) %>%
      arrange(desc(Totpay))
      head(data_Q3, n = input$n1)
  })
  
  #choose a method
  output$table_Q4 <- renderTable({
    if (input$Method == "Median") {
      data_median_Q4 <- LApayroll %>% filter(Year == input$Year) %>%
        group_by(Department.Title) %>%
        summarise(MedianTotal = median(Totpay, na.rm = TRUE),
                  MedianBase = median(Basepay, na.rm = TRUE),
                  MedianOver = median(Overpay, na.rm = TRUE),
                  MedianOther = median(Otherpay, na.rm = TRUE)) %>%
        arrange(desc(MedianTotal)) %>%
        select(Department.Title, MedianTotal, MedianBase, MedianOver, 
               MedianOther)
      head(data_median_Q4, n = input$n2)
    }else{
      
    }
      
      
      
      
    data_Q4 <- LApayroll %>%
      filter(Year == input$Year) %>%
      select(Totpay, Basepay, Overpay, Otherpay, Department.Title, 
             Job.Class.Title) %>%
      arrange(desc(Totpay))
    head(data_Q3, n = input$n1)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

