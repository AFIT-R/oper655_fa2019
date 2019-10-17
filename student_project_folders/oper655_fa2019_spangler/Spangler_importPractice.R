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
root <- rprojroot::find_root(rprojroot::is_rstudio_project) #Sets root of file diectory
(amazon_review_file <- file.path(root, "data","csv", "1429_1.csv"))
time1 <- system.time({ amazon_review_data_1 <- read.csv(amazon_review_file) })
str(amazon_review_data_1$reviews.text)
time2 <- system.time({ amazon_review_data_2 <- readr::read_csv(amazon_review_file) })
time3 <- system.time({ amazon_review_data_3 <- data.table::fread(amazon_review_file) })
time4 <- system.time({ amazon_review_data_4 <- vroom::vroom(amazon_review_file) })

#Read Word
dest <- file.path(root, "data", "msword")
ms_files <- list.files(path = dest,
                       pattern = "docx",
                       full.names = TRUE)
docx1 <- qdapTools::read_docx(file = ms_files[1])

for (i in 1:length(ms_files)){
  docx <- qdapTools::read_docx(file= ms_files[i])
}

#Read PDF
dest_PDF <- file.path(root, "data", "pdf_raw", "supreme_court_opinions_2017_sample")
pdf_files <- list.files(path = dest_PDF,
                        pattern = "pdf",
                        full.names = TRUE)
cmd1 <- "pdftotext" 
cmd2 <- ""
cmd3 <- pdf_files[1]
cmd4 <- ""
CMD1 <- glue::glue("{cmd1} {cmd2} {cmd3} {cmd4}")
# lapply(pdf_files,
#        FUN = function(x) system(glue::glue("pdftotext {x}"), wait = FALSE))

x <- paste(state.name[1:10], collapse = " ")
strsplit(x, " ")

dest <- file.path(root, "student_project_folders", "oper655_fa2019_spangler", "Files", "Non-text-searchable.pdf")
pdf_png <- pdftools::pdf_convert(dest, dpi = 600)
tesseract_text <- tesseract::ocr(pdf_png)
