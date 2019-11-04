pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr)      # Tools for qualitative data

library(here)
root <- here('data', 'pdf_raw','supreme_court_opinions_2017')

trav_ban_pdf <- list.files(root, 
                           pattern = '17-965\\S+pdf$',
                           full.names = T)


trav_ban_pdf 
tb_pdftools <- pdftools::pdf_text(trav_ban_pdf)

# Length of trav_ban vector represents the
# number of pages in the pdf document
length(tb_pdftools)
# This should result in the same number of pages
pdftools::pdf_info(trav_ban_pdf)$pages
# take a look at raw text from the first page
tb_pdftools[1]
# The cat() function will execute the \r\n
# and make the result more visually appealing
# however, it's important to remember that we're 
# working with the raw data that includes all of 
# the \r\n terms  
cat(tb_pdftools[1])
cmd1 <- 'pdftotext' 
cmd2 <- '-layout'   
cmd3 <- trav_ban_pdf
cmd4 <- ''          

CMD1 <- glue::glue("{cmd1} {cmd2} {cmd3} {cmd4}")

system(CMD1)
trav_ban_txt <- list.files(root, 
                           pattern = '17-965\\S+txt$',
                           full.names = T)

tb_pdftotext <- readLines(trav_ban_txt,
                          warn = F)

# Number of lines in character vector returned
str(tb_pdftotext)
tb_pdftotext[1]
# look for countries
all_countries <- countrycode::codelist$country.name.en

countries <- tibble::tibble(name = all_countries)

countries$pages <- 
  sapply(seq_along(all_countries),
         FUN = function(x) grep(all_countries[x], tb_pdftools))

countries$total_pages <- 
  sapply(seq_along(countries$pages),
         FUN = function(x) length(countries$pages[x][[1]]))

countries <- subset(countries, 
                    subset = total_pages > 0)
