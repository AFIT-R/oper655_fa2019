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
               tools,
               readxl,
               here)


root <- here('data', 'pdf_raw','supreme_court_opinions_2017')

YourFile <- list.files(root, 
            pattern = '17-965\\S+pdf$',
            full.names = T)



#This gets the file type, and outputs whatever type of file you wish to read in, setting it as FileType.

ExtractingText<-function(YourFile){
  FileType<-file_ext(YourFile)
  

#Now I am checking which type of file we are reading in and using the correct method to do so. 
  if (FileType == "csv") {MyData<-data.table::fread(YourFile)
                            print(FileType)} 
  if (FileType == "doc") { MyData<-qdapTools::read_docx(antiword(file = YourFile,format = FALSE))
                          print(FileType)}
  if (FileType == "pdf") { MyData<-pdftools::pdf_text(YourFile)
                          pdftools::pdf_info(YourFile)$pages
                          print(FileType)}
  if (FileType == "docx") { MyData<-qdapTools::read_docx(YourFile)
                            print(FileType)}
  if (FileType == "txt") { MyData<-readLines(YourFile, encoding = "UTF-8")
                          print(FileType)}
  if (FileType == "xls") { MyData <- read_excel(YourFile)
                                    print(FileType)}
  if (FileType == "xlsx") { MyData <- read_excel(YourFile)
                            print(FileType)}

}

ExtractingText(YourFile)


View(MyData)

MyData[1]



String<-"Lt Aaron C. Giddings (aaron.giddings@afit.edu), Capt Brandon J. Hufstetler (brandon.hufstetler@afit.edu), 2 Lt Trey S. Pujats (trey.pujats@afit.edu), 2 Lt Maria N. Schroeder (maria.schroeder@afit.edu), Capt Tyler M. Spangler (tyler.spangler@afit.edu), 2 Lt Maxwell C. Thompson (maxwell.thompson@afit.edu), 1 Lt Clarence O. Williams, III (clarence.williams@afit.edu)"
str_extract_all(String,  "(?<=\\().+?(?=\\))")

#   '?<=\\(' Looks behind for open parenthesis saying it will only be matched once at most
