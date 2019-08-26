load(file = file.path(root,'rstudio_data','Corpus_Data.RData'))

corpus_list <- function(corpus) {
  
file_names <- names(corpus)

old_symbols <- c('[', ']', '(', ')', '-', '--', ' - ', ' -- ','&', ' ')
new_symbols <- c( '', '' , '' , '' , '_', '_' , '_'  ,  '_'  , '', '_')

file_names <- qdap::mgsub(old_symbols, new_symbols, file_names)

get_ngrams <- function(x, n) {
  
  df <- data.frame(count = unclass(tau::textcnt(x, method = "string", n = n)))
  
  df$text <- rownames(df)
  
  rownames(df) <- NULL
  
  return(df[order(df[,1], decreasing = T),])

ngram_list <- lapply(X = 1:5, FUN = function(x) get_ngrams(rpt1, n = x))
  
}

         
}