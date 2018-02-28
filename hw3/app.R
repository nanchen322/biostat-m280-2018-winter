lapayroll <- read.csv("/home/m280-data/la_payroll/LA_City_Employee_Payroll.csv")
lapayroll1 <- lapayroll[, c(2, 3, 6, 16, 17, 22, 24, 30, 33)]
lapayroll1$Totpay = as.numeric(gsub("\\$", "", lapayroll1$Total.Payments))
lapayroll1$Basepay = as.numeric(gsub("\\$", "", lapayroll1$Base.Pay))
lapayroll1$Overpay = as.numeric(gsub("\\$", "", lapayroll1$Overtime.Pay))
lapayroll1$Otherpay = as.numeric(gsub("\\$", "", 
                                      lapayroll1$Other.Pay..Payroll.Explorer))
lapayroll1$Totcost = as.numeric(gsub("\\$", "", 
                                     lapayroll1$Average.Benefit.Cost))
lapayroll1$Healthcost = as.numeric(gsub("\\$", "", 
                                        lapayroll1$Average.Health.Cost))
lapayroll1 <- lapayroll1[, -c(4,5,6,7,8,9)]



library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

