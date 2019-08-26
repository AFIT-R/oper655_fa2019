#' @title Extract text from a file (.doc or .pdf)
#' 
#' @param input_file \code{character} Path to an input file  
#' @param output_dir \code{character} Path to a directory into 
#'                   which the text corpus will be saved as a list
#'
#' @export
get_text <- function(input_file) {
  
  file.ext <- tools::file_ext(input_file)
  
  if(!any(!is.na(pmatch(c('doc','pdf'),tolower(file.ext))))) { 
    
    stop('File type must be either "doc" or "pdf"')
    
  }
  
  if(tolower(file.ext)=='doc') {
    
    text_raw <- antiword::antiword(file = input_file)
  
  } else {
    
    text_raw <- pdftools::pdf_text(pdf  = input_file)
    
  }
  
  # old_class <- oldClass(text_out)
  # 
  # class(text_out) <- c('sab_text', old_class)
  # 
  # zout <- list()
  # 
  # zout$Text <- text_out
  # 
  # if(!dir.exists(output_dir)) dir.create(output_dir)
  # 
  # file_out <- get_filename(input_file)
  # 
  # dput(zout, 
  #      file = file.path(output_dir, paste0(basename(file_out),'.R')))
  
  old_spaces <- sapply(X = 10:1, 
                       FUN = function(x) paste0(rep('\r\n', x), collapse = ''))
  
  new_spaces <- sapply(X = 10:1, 
                       FUN = function(x) paste0(rep('xx', x), collapse = ''))
  
  text_raw2 <- qdap::mgsub(old_spaces, 
                           paste(' ',new_spaces,'zzz', sep = ''), 
                           text_raw)
  
  text_out <- unlist(strsplit(text_raw2, split = 'zzz'))
  
  return(text_out)
  
}

