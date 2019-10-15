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

root <- rprojroot::find_root(rprojroot::is_rstudio_project)

#Create List of Files in Folder
dest <- file.path(root, "student_project_folders", "oper655_fa2019_spangler", "Files")

#Create list of csv files
csv_files <- list.files(path = dest,
              pattern = "csv",
              full.names = TRUE)

#Load CSV Files (https://stackoverflow.com/questions/11433432/how-to-import-multiple-csv-files-at-once)
for (i in 1:length(csv_files)){
  assign(csv_files[i], vroom::vroom(csv_files[i]))
}

#Create List of Word Files
ms_files <- list.files(path = dest, 
                       pattern = "docx",
                       full.names = TRUE)

for (i in 1:length(ms_files)){
  assign(ms_files[i], qdapTools::read_docx(ms_files[i]))
}

#Create List of PDF Files
pdf_files <- list.files(path = dest, 
                        pattern = "pdf",
                        full.names = TRUE)
#Convert PDFs to Text and Create List of Text Files
lapply(pdf_files,
       FUN = function(x) system(glue::glue("pdftotext {x}"), wait = FALSE))
text_files <- list.files(path = dest,
                         pattern = "txt",
                         full.names = TRUE)
#Import Text Files
for (i in 1:length(text_files)){
  assign(text_files[i], readLines(text_files[i]))
}



