get_filename <- function(file) {
  
  file.ext <- tools::file_ext(file)
  
  file_name <- basename(file)
  
  file_name <- gsub(paste0('.',file.ext), '', file_name)
  
  old_symbols <- c('[', ']', '(', ')', '-', '--', ' - ', ' -- ','&', ' ')
  new_symbols <- c( '', '' , '' , '' , '_', '_' , '_'  ,  '_'  , '', '_')
  
  file_name <- qdap::mgsub(old_symbols, new_symbols, file_name)
  
  return(tolower(file_name))
  
}
