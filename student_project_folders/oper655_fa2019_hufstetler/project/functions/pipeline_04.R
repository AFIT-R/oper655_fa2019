#################################
## Cast corpus to other format ##
#################################

huf.4_corpus2other <- function(corpus, output_type){
  library(dplyr)
  # create a dtm from the corpus
  corpus_dtm <- tm::VectorSource(corpus$word) %>%
    tm::VCorpus() %>%
    tm::DocumentTermMatrix(control = base::list(removePunctuation = T,
                                                removeNumbers = T,
                                                stopwords = tidytext::stop_words[,2],
                                                tokenize = 'MC',
                                                weighting =
                                                  function(x)
                                                    tm::weightTfIdf(x, normalize = !F)))
  # convert to tidy df
  corpus_tidy_tm <- tidytext::tidy(corpus_dtm)
  
  switch(output_type,
         "dfm" =
           # cast tidy data to DFM for quanteda package
           output_object <- corpus_tidy_tm %>%
           tidytext::cast_dfm(document, term, count),
         "dtm" =
           # cast tidy data to DTM for tm package
           output_object <- corpus_tidy_tm %>%
           tidytext::cast_dtm(document, term, count),
         "tdm" = 
           # cast tidy data to TDM for tm package
           output_object <- corpus_tidy_tm %>%
           tidytext::cast_tdm(term, document, count),
         "sparse" =
           #cast tidy data to sparce matrix
           output_object <- corpus_tidy_tm %>%
           tidytext::cast_sparse(document, term, count)
  )
  return(output_object)
}
