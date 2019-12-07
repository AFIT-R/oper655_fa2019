huf.8_document_summary <- function(corpus, episode, stop_custom){
  library(dplyr)
  if(!exists("stop_custom")){
    stop_custom <- tibble::tibble(word = NA)
  }
  
  episode_sentences <- corpus[corpus$episode == episode,] %>%
    huf.3_unnest("sentences") %>%
    dplyr::mutate(sentence_id = dplyr::row_number()) %>%
    dplyr::select(sentence_id, word)
  episode_words <- episode_sentences %>%
    huf.3_unnest("words") %>%
    dplyr::anti_join(tidytext::stop_words) %>%
    dplyr::anti_join(stop_custom)
  episode_summary <- episode_sentences %>%
    textrank::textrank_sentences(terminology = episode_words)
  
  corpus_words <- corpus %>%
    huf.3_unnest("words") %>%
    dplyr::count(episode, ep_title, word, sort = T)
  total_words <- corpus_words %>%
    dplyr::group_by(episode) %>%
    dplyr::summarize(total = sum(n))
  corpus_words <- dplyr::left_join(corpus_words, total_words) %>%
    tidytext::bind_tf_idf(word, episode, n) %>%
    dplyr::select(-total) %>%
    dplyr::arrange(dplyr::desc(tf_idf))
  output <- base::list()
  output[[1]] <- episode_summary
  output[[2]] <- corpus_words[corpus_words$episode == episode,]
  return(output)
}