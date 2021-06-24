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
                                              label = "Proportion of DNA haplotype labels to subsample (prop.haps)",
                                              value = NULL,
                                              min = 0,
                                              max = 1,
                                              step = 0.01)
                ), # end conditionPanel
                
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
                                                                 label = "Proportion of DNA sequences to subsample (prop.seqs)",
                                                                 value = NULL,
                                                                 min = 0,
                                                                 max = 1,
                                                                 step = 0.01),
                                                    
                                   ), # end conditionPanel
                         
                                 helpText("Note: Inputted DNA sequences should not contain missing and/or ambiguous 
	                                       nucleotides, which may lead to overestimation of the number of 
	                                       observed unique haplotypes. Consider excluding sequences or alignment 
	                                       sites containing these data. If missing and/or ambiguous bases occur 
	                                       at the ends of sequences, further alignment trimming is an option."),
                         
                         
                ), # end tabPanel
        
            br(),
            tabPanel("About",
                     h1("What is HACSim and how does it work?"),
                     p("HACSim (",strong("H"),"aplotype",strong("A"),"ccumulation",strong("C"),"urve",strong("Sim"),"ulator) is 
                        a novel nonparametric stochastic (Monte Carlo) local search optimization algorithm written in R for the 
                        simulation of haplotype accumulation curves. It can be employed to determine likely required sample sizes 
                        for DNA barcoding, specifically pertaining to recovery of total haplotype variation that may exist for 
                        a given species."),
                     p("Most DNA barcoding studies conducted to date suggest sampling between 5-10 individuals per 
                        species due to research costs. However, it has been shown that low sample sizes can greatly 
                        underestimate haplotype diversity for geograpically-widespread taxa. The present algorithm 
                        is in place to more accurately determine sample sizes that are needed to uncover all putative 
                        haplotypes that may exist for a given species. Implications of such an approach include 
                        accelerating the construction and growth of DNA barcode reference libraries for species of 
                        interest within the Barcode of Life Data Systems", (tags$a(href = "http://www.boldsystems.org", "(BOLD)")), 
                        "or similar database such as", (tags$a(href = "https://www.ncbi.nlm.nih.gov/genbank/", "GenBank."))),
                    p("Within the simulation algorithm, species haplotypes are treated as distinct character labels 
                        (1, 2, ...), where 1 denotes the most frequent haplotype, 2 denotes the second-most frequent 
                        haplotype, and so forth. The algorithm then randomly samples species haplotype labels in an 
                        iterative fashion, until all unique haplotypes have been observed. The idea is that levels of 
                        species haplotypic variation that are currently catalogued in BOLD can serve as proxies for 
                        total haplotype diversity that may exist for a given species."),
                    p("Molecular loci besides DNA barcode genes (5'-COI, rbcL/matK, ITS regions) can be used with HACSim 
                        (",em("e.g."), "cytb)."),
                    h3("Authors"),
                    h3("More Information"), 
                    p("Are you interested in doing even more with HACSim? Consider downloading the R package! See", 
                    (tags$a(href = "https://cran.r-project.org/web/packages/HACSim/index.html", "HACSim")), "for more details.)"),
                    h3("Citation"),
                    p(strong("Phillips, J.D."), "French, S.H., Hanner, R.H. and  Gillis, D.J. (2020). HACSim: An 
                    R package to estimate intraspecific sample sizes for genetic diversity assessment 
                    using haplotype accumulation curves. PeerJ Computer Science, 6(192): 1-37.")
            ) # end tanPanel
                     
               
            ), # end tabsetPanel
    
        
) # end fluidPage








# Define server logic
server <- function(input, output) {

    output$distPlot <- renderPlot({ })
}

# Run the application 
shinyApp(ui = ui, server = server)
