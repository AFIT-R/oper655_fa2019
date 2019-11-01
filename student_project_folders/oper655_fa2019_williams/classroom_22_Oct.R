if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

devtools::install_github("bradleyboehmke/harrypotter")

install.packages("pacman")
install.packages("devtools")

pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr,      # Tools for qualitative data
               DT)
