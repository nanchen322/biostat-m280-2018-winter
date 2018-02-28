library(tidyverse)
library(ggplot2)
library(magrittr)

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
pay2 <- LApayroll %>% select(Year, Basepay, Overpay, Otherpay) %>%
              group_by(Year) %>%
              summarise(TotBasepay = sum(Basepay, na.rm = TRUE),
                        TotOverpay = sum(Overpay, na.rm = TRUE),
                        TotOtherpay = sum(Otherpay, na.rm = TRUE)) %>%
             gather(TotBasepay, TotOverpay, TotOtherpay, key = "variable", 
                    value = "value")


library(shiny)
# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("LA City Employee Payroll"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
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
      selectInput(inputId = "Method",
                  label = "Choose a method:",
                  choices = c("Median", "Mean"))
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: plot and table for data summary ----
      plotOutput("barPlot"),
      tableOutput("table1"),
      tableOutput("table2"),
      tableOutput("table3")
      
    )
  )
)

server <- function(input, output) {

  output$barPlot <- renderPlot({
    ggplot(pay2, aes(x = Year, y = Type, fill = variable)) +
    geom_col() +
    labs(title = "Total payroll by LA City")
  })
  
  output$table1 <- renderTable({
    head(aaa, n = input$n1)
  })
  
  output$table1 <- renderTable({
    head(aaa, n = input$n1)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

