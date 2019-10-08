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

#Read Txt file
oper655_readme_url <- "https://raw.githubusercontent.com/AFIT-R/oper655_fa2019/master/README.md"
oper_readme_text <- readLines(oper655_readme_url, encoding = "UTF-8")
str(oper_readme_text)
head(oper_readme_text)
oper_readme_text[136] #Quotes error
oper_readme_text[251] #Ellpsis error
oper_readme_text[264] #Apostrophe Error

#Read CSV
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
(amazon_review_file <- file.path(root, "data","csv", "1429_1.csv"))
time1 <- system.time({ amazon_review_data_1 <- read.csv(amazon_review_file) })
str(amazon_review_data_1$reviews.text)
time2 <- system.time({ amazon_review_data_2 <- readr::read_csv(amazon_review_file) })
time3 <- system.time({ amazon_review_data_3 <- data.table::fread(amazon_review_file) })
time4 <- system.time({ amazon_review_data_4 <- vroom::vroom(amazon_review_file) })
