install.packages("pacman")
pacman::p_load(XML,
               rvest,
               RCurl,
               rprojroot,
               qdapTools,
               pdftools,
               antiword,
               glue,
               data.table,
               tidyverse,
               vroom,
               antiword,
               magick,
               tesseract)

oper655_readme_url <- "https://raw.githubusercontent.com/AFIT-R/oper655_fa2019/master/README.md"
oper655_readme_text <- readLines(oper655_readme_url)
str(oper655_readme_text)
head(oper655_readme_text)

oper655_readme_text[136] #check quotes
oper655_readme_text[251] #check elipses
oper655_readme_text[264] #check apostrophes

root <- rprojroot::find_root(rprojroot::is_rstudio_project)
(amazon_review_file <- file.path(root, "data", "csv", "1429_1.csv"))

time1 <- system.time({ amazon_review_file_1 <- read.csv(amazon_review_file) })
str(amazon_review_file_1$reviews.text)

# system.time returns the time required to evaluate the expression in {}
time2 <- system.time({ amazon_review_data_2 <- readr::read_csv(amazon_review_file) })
