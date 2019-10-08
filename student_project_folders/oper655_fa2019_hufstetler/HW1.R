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
oper_readme_text <- readLines(oper655_readme_url, encoding = "UTF-8")

str(oper_readme_text)
head(oper_readme_text)
oper_readme_text[136] #check quotes
oper_readme_text[251] #check elipsis
oper_readme_text[264] #check apostrophe

root <- rprojroot::find_root(rprojroot::is_rstudio_project)
(amazon_review_file <- file.path(root, "data","csv", "1429_1.csv"))

time1 <- system.time({ amazon_review_data_1 <- read.csv(amazon_review_file) })
str(amazon_review_data_1$reviews.text)

time2 <- system.time({ amazon_review_data_2 <- readr::read_csv(amazon_review_file) })





