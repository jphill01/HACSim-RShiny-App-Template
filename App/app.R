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

# devtools::install_github("rstudio/shiny-incubator", force = TRUE)
# library(shinyIncubator)

# library(HACSim)

##########

# Define UI for application
ui <- fluidPage(
    
    # Application title
    titlePanel("HACSim: Haplotype Accumulation Curve Simulator"),
    tabsetPanel(
        tabPanel("Main interface",
            br(),
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

                tabPanel("Hypothetical species",
                    br(),
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
                                      label = "Haplotype frequency distribution (probs)",
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
                
                    
                tabPanel("Real species",
                         br(),
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
        
            tabPanel("About",
                     h3("What is HACSim and how does it work?"),
                     p("HACSim is a novel nonparametric stochastic (Monte Carlo) local search optimization algorithm written in R 
                        for the simulation of haplotype accumulation curves. It can be employed to determine likely required 
                        sample sizes for DNA barcoding, specifically pertaining to recovery of total haplotype variation that may 
                        exist for a given species."),
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
                        (",em("e.g.,", .noWS = c('before')),"cytb)."),
                    h3("Authors"),
                    tags$ul(
                        tags$li("Jarrett D. Phillips (phillipsjarrett1@gmail.com)"),
                        tags$li("Navdeep Singh")
                    ),
                    h3("More Information"), 
                    p("Are you interested in doing even more with HACSim? Consider downloading the R package! See the HACSim", 
                      tags$a(href = "https://cran.r-project.org/web/packages/HACSim/index.html", "CRAN"),
                      "page for more details. You can also check out the HACSim R package repository on", 
                      tags$a(href = "https://github.com/jphill01/HACSim.R", "GitHub.")),
                    h3("Citations"),
                    p("In utilizing HACSim, the following publications may be of interest and worth citing"),
                    p(strong("Phillips, J.D.", .noWS = c('outside')),",", "French, S.H., Hanner, R.H. and  Gillis, D.J. (2020). HACSim: An 
                    R package to estimate intraspecific sample sizes for genetic diversity assessment 
                    using haplotype accumulation curves.",em("PeerJ Computer Science,"), strong("6", noWS = c('outside')),"(192): 1-37. 
                    DOI: 10.7717/peerj-cs.243."),
                    p(strong("Phillips, J.D.", .noWS = c('outside')),",", "Gillis, D.J. and Hanner, R.H. (2019). Incomplete estimates of 
                      genetic diversity within species: Implications for DNA barcoding.", em("Ecology and Evolution,"), 
                      strong("9", noWS = c('outside')),"(5): 2996-3010. DOI: 10.1002/ece3.4757."),
                    p(strong("Phillips, J.D.", .noWS = c('outside')),",", "Gwiazdowski, R.A., Ashlock, D. and Hanner, R. (2015). An exploration of sufficient sampling effort 
                      to describe intraspecific DNA barcode haplotype diversity: examples from the ray-finned fishes (Chordata: 
                      Actinopterygii).", em("DNA Barcodes,"), strong("3", noWS = c('outside')),": 66-73. DOI: 10.1515/dna-2015-0008.")
                   
            ) # end tabPanel
                     
               
            ), # end tabsetPanel
    
        
) # end fluidPage








# Define server logic
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
