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
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
dest <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 3')


mcu_phase3 <- list.files(dest, 
                           pattern = 'pdf',
                           full.names = TRUE)

mcu_phase3[1]
tb_pdftools <- pdftools::pdf_text(pdf = mcu_phase3[1])






text_tb <- tibble::tibble(text = antman_and_the_wasp_pdf)


