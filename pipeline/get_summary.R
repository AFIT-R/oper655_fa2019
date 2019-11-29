get_summary <- function(text, 
                        n_sentences,...) {
  
  top_n = lexRankr::lexRank(text,
                            #only 1 article; repeat same docid for all of input vector
                            docId = rep(1, length(text)),
                            #return 3 sentences to mimick /u/autotldr's output
                            n = n_sentences,
                            continuous = TRUE,...)

#reorder the top n sentences to be in order of appearance in article
order_of_appearance = order(as.integer(gsub("_","",top_n$sentenceId)))

#extract sentences in order of appearance
ordered_top_n = top_n[order_of_appearance, "sentence"]
ordered_top_n

return(ordered_top_n)

}