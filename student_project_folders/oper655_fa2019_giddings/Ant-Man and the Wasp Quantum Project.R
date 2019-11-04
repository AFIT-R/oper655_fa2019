# Text Mining Project: MCU Quantum Analysis
# By: Aaron Giddings

pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr,      # Tools for qualitative data
               DT)
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
install.packages(qdap)
library(qdap)
devtools::install_github("bradleyboehmke/harrypotter")
harrypotter::philosophers_stone[1]
pacman::p_load(tm, 
               pdftools, 
               here,
               tau,
               tidyverse,
               stringr,
               tidytext, 
               RColorBrewer,
               qdap,
               qdapRegex,
               qdapDictionaries,
               qdapTools,
               data.table,
               coreNLP,
               scales,
               harrypotter,
               text2vec,
               SnowballC,
               DT,
               quanteda,
               RWeka,
               broom,
               tokenizers,
               grid,
               knitr,
               widyr)
pacman::p_load_gh("dgrtwo/drlib",
                  "trinker/termco", 
                  "trinker/coreNLPsetup",        
                  "trinker/tagger")
pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr)      # Tools for qualitative data

library(here)
root <- here('MCU Scripts', 'Phase 3','Ant-Man and the Wasp Script')

antman_and_the_wasp_pdf <- list.files(root, 
                           pattern = '17-965\\S+pdf$',
                           full.names = T)

antman_and_the_wasp_pdf 
tb_pdftools <- pdftools::pdf_text(antman_and_the_wasp_pdf)






text_tb <- tibble::tibble(text = antman_and_the_wasp_pdf)
