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
               tesseract,
               readr)

root <- rprojroot::find_root(rprojroot::is_rstudio_project)

#Update file path to the files folder
dest <- file.path(root, "student_project_folders", "oper655_fa2019_spangler", "Files")

#Create List of All Files in Folder
master_list <- list.files(path = dest,
                          pattern = "",
                          full.names = TRUE)

#Create list of csv files
csv_files <- list.files(path = dest,
              pattern = "csv",
              full.names = TRUE)

#Load CSV Files (https://stackoverflow.com/questions/11433432/how-to-import-multiple-csv-files-at-once)
for (i in 1:length(csv_files)){
  assign(paste("csv_files",i,sep = "_"), vroom::vroom(csv_files[i]))
}


#Create List of Word Files
ms_files <- list.files(path = dest, 
                       pattern = "docx",
                       full.names = TRUE)
#Read in word files
for (i in 1:length(ms_files)){
  assign(paste("ms_files", i, sep = "_"), qdapTools::read_docx(ms_files[i]))
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
  assign(paste("text_files", i, sep = "_"), read_file(text_files[i]))
  
}

#List of Image Files
image_files <- list.files(path = dest,
                          pattern = "jpg|tif",
                          full.names = TRUE)

#Import Image Files
for (i in 1:length(image_files)){
 assign(paste("image_files",i,sep = "_"), image_read(image_files[i]) %>%
           image_resize("2000") %>%
           image_convert(colorspace = 'gray') %>%
           image_trim() %>%
           image_ocr())

}

