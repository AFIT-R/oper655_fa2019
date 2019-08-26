get_ngrams <- function(x, n,...) {
  
  df <- data.frame(count = unclass(tau::textcnt(x, method = "string", n = n,...)))
  
  df$text <- rownames(df)
  
  rownames(df) <- NULL
  
  return(df[order(df[,1], decreasing = T),])
  
}

