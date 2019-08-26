get_speech_text <- function(obj, nouns = TRUE) {
  
  if(!is.data.frame(obj)) obj <- obj[['speech']]
  
  if(nouns){
    
    text <- obj[tolower(substr(obj[['pos']],1,1)) == 'n','token'][[1]]
    
  } else {
    
    text <- obj[tolower(substr(obj[['pos']],1,1)) == 'v','token'][[1]]
    
  }
  
  lines <- paste(c(text[nchar(text) > 0]), collapse = ' ')
  
  
  return(lines)
  
}