cat("\014") #Clear console
rm(list = ls()) #clear variables



fun_read_file <- function(myFile){
  
  library("pacman")
  p_load("tools")
  file_ext=file_ext(myFile)
  
  if (file_ext == "txt") {
    myText = readLines(myFile, encoding = "UTF-8")
    
  }else if (file_ext == "csv") {
    p_load(readr)
    myText = readr::read_csv(myFile)
    
  }else if (file_ext == "xls" || file_ext == "xlsx") {
    p_load(readxl)
    myText = readxl::read_excel(myFile)
    
  }else if (file_ext == "docx") {
    p_load(qdapTools)  
    myText = qdapTools::read_docx(myFile)
    
  }else if (file_ext == "doc") {
    p_load(antiword)
    myText = antiword::antiword(myFile)

  }else if (file_ext == "pdf") {
    p_load(pdftools)
    myText = pdftools::pdf_text(pdf = myFile)
    
    if (length(myText) == 1) {
      pdf_png <- pdftools::pdf_convert(myFile, dpi = 600)
      p_load(tesseract)
      myText <- tesseract::ocr(pdf_png)
    }
    
  }else {
    print("Not a known file type")
    myText = "Not a known file type"
  }
  
  return(myText)
}



file=0
file[1]="C:/Users/Max's USAFA PC/Desktop/Files/Pick the date.doc"
file[2]="C:/Users/Max's USAFA PC/Desktop/Files/NDS 18.pdf"
file[3]="C:/Users/Max's USAFA PC/Desktop/Files/hybrid_data_v1.xlsx"
file[4]="C:/Users/Max's USAFA PC/Desktop/Files/hybrid_data_v2.xls"
file[5]="C:/Users/Max's USAFA PC/Desktop/Files/hybrid_data_v3.csv"
file[6]="C:/Users/Max's USAFA PC/Desktop/Files/Bush_1989.txt"
file[7]="C:/Users/Max's USAFA PC/Desktop/Files/Non-text-searchable.pdf"

output<-lapply(X=file,FUN = fun_read_file)

print(summary(output))



