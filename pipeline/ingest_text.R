#' Module to ingest data from a file
#'
#' @description Takes in a file path and returns the text from the document
#'
#' @importFrom tesseract ocr
#' @importFrom pdftools pdf_convert pdf_text
#' @importFrom tools file_ext
#' @importFrom qdapTools read_docx
#' @importFrom antiword antiword
#' @importFrom magick image_read image_resize image_convert image_trim image_ocr
#' @importFrom data.table fread
#' @importFrom readr read_lines
#' @importFrom quanteda corpus
#'
#' @param file_path Character string containing the path to the file 
#'                  from which the text data is to be extracted
#' @param pdf_image Boolean denoting if the file is an image, 
#'                  for use when \code{file_path == 'pdf'}
#' @param file_type Character string to specify the file type
#'
#' @example 
#' \dontrun{
#' 
#' oper655_readme <- "https://raw.githubusercontent.com/AFIT-R/oper655_fa2019/master/README.md"
#' 
#' Text = ingest_text(oper655_readme,
#'                    file_type = "txt")
#' 
#' }
#'
#' @return text data
ingest_text <-  function(file_path = NULL,
                         pdf_image = F,
                         file_type = NULL){
  
  if(is.null(file_type)) file_type <- tools::file_ext(file_path)
  
  text_data <- switch(tolower(file_type),
                      'pdf' = `if`(pdf_image,
                                   tesseract::ocr(pdftools::pdf_convert(file_path, dpi = 600)),
                                   pdftools::pdf_text(file_path)),
                      'docx' = qdapTools::read_docx(file_path),
                      'doc' = antiword::antiword(file_path),
                      'txt' = readr::read_lines(file_path),
                      'csv' = data.table::fread(file_path),
                      'tif' =, "png" = { magick::image_read(image_file) %>% 
                                magick::image_resize("2000")   %>%
                                magick::image_convert(colorspace = 'gray') %>%
                                magick::image_trim() %>%
                                magick::image_ocr() })
  
  return(text_data)
  
}