#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

##########

##### Set working directory #####

setwd("/Users/jarrettphillips/Desktop/HAC simulation")

##### Clear memory #####

remove(list = ls())

##### Load packages #####

library(shiny)

devtools::install_github("rstudio/shiny-incubator", force = TRUE)
library(shinyIncubator)

# library(HACSim)

##########

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("HACSim: Haplotype Accumulation Curve Simulator"),
    tabsetPanel(
        tabPanel("Main algorithm parameters",
            sidebarLayout(
                sidebarPanel(
                    numericInput(inputId = "perms",
                                 label = "Number of permutations (perms)",
                                 value = 10000,
                                 min = 2,
                                 step = 1),
                
                    numericInput(inputId = "p",
                                 label = "Proportion of haplotypes to recover (p)",
                                 value = 0.95,
                                 min = 0,
                                 max = 1,
                                 step = 0.01), 
        
                    numericInput(inputId = "conf.level",
                                 label = "Confidence level for calculations and plotting (conf.level)",
                                 value = 0.95,
                                 min = 0.01,
                                 max = 0.99,
                                 step = 0.01),
                
              
                
                        ), # end sidebarPanel
            
                    mainPanel(
                    
                    )
                   
                ), # end sidebarLayout
            
            actionButton(inputId = "submit", 
                         label = "Submit"),
            
        ), # end tabPanel

            br(),
                tabPanel("Hypothetical species", 
                    sidebarLayout(
                        sidebarPanel(
                            numericInput(inputId = "N",
                                         label = "Number of observed specimens (N)",
                                         value = 100,
                                         min = 2),
                                 
                            numericInput(inputId = "Hstar",
                                         label = "Number of observed haplotypes (H*)",
                                         value = 5,
                                         min = 1),
                                 
                            textInput(inputId = "probs",
                                      label = "Haplotype frequency distribution",
                                      value = "0.20, 0.20, 0.20, 0.20, 0.20"),
                                 
                              
                             
                         ), # end sidebarPanel
                         
                         
                     
                    mainPanel(
                        
                    )
               
                    
                ), # end sidebarLayout
                
                checkboxInput(inputId = "subsamplehaps", 
                              label = "Subsample DNA haplotype labels",
                              value = FALSE),
                
                conditionalPanel(condition = "input.subsamplehaps == 1",
                                 numericInput(inputId = "prop",
                                              label = "Proportion of DNA haplotype labels to subsample",
                                              value = NULL,
                                              min = 0,
                                              max = 1,
                                              step = 0.01)
                ),
                
            ), # end tabPanel
                
                br(),         
                tabPanel("Real species", 
                         fileInput(inputId = "file", 
                                   label = "Choose FASTA file",
                                   accept = ".fas",
                                   buttonLabel = "Browse..."),
                         
                                   checkboxInput(inputId = "subsampleseqs", 
                                                 label = "Subsample DNA sequences",
                                                 value = FALSE),
                                    
                                   conditionalPanel(condition = "input.subsampleseqs == 1",
                                                    numericInput(inputId = "prop",
                                                                 label = "Proportion of DNA sequences to subsample",
                                                                 value = NULL,
                                                                 min = 0,
                                                                 max = 1,
                                                                 step = 0.01)
                                                    ),
                         
                         
                ), # end tabPanel
        
            br(),
            tabPanel("About",
                     
            ) # end tanPanel
                     
               
            ), # end tabsetPanel
    
        
) # end fluidPage








# Define server logic
server <- function(input, output) {

    output$distPlot <- renderPlot({ })
}

# Run the application 
shinyApp(ui = ui, server = server)
