###########################################
## Unnest corpus elements ##
###########################################
huf.3_unnest <- function(corpus 
                         ,token = c("ngrams", "words", "sentences")
                         ,ngram_length){
  library(dplyr) # for pipe operator
  switch(token,
         "ngrams" =
           corpus_unnested <- corpus %>%
           tidytext::unnest_tokens(word, word, token = "ngrams", n = ngram_length),
         "words" = 
           corpus_unnested <- corpus %>%
           tidytext::unnest_tokens(word, word, token = "words"),
         "sentences" = 
           corpus_unnested <- corpus %>%
           tidytext::unnest_tokens(word, word, token = "sentences")
  )
  return(corpus_unnested)
}
