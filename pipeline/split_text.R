split_text <- function(text_data, split_by = "paragraph"){
  
  if(!is.data.frame(text_data)) td_df <- data.frame(text = text_data)
  
  td_split <- switch(tolower(split_by),
                     "paragraph" = tokenizers::tokenize_paragraphs(text_data),
                     "sentence"  = tokenizers::tokenize_sentences(text_data),
                     "word"      = tokenizers::tokenize_words(text_data))
  
  return(td_split)
  
}