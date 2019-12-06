########################
## Sentiment Analysis ##
########################

huf.7_sentiment <- function(corpus, episode_range, width){
  library(dplyr) # for pipe operator
  print(
    corpus[corpus$episode %in% episode_range,] %>%
      huf.3_unnest("sentences") %>%
      dplyr::group_by(ep_title) %>%
      dplyr::mutate(sentence_number = dplyr::row_number()) %>%
      dplyr::ungroup() %>%
      huf.3_unnest("words") %>%
      dplyr::inner_join(tidytext::get_sentiments("bing")) %>%
      dplyr::count(episode, ep_title, index = sentence_number %/% 4, sentiment) %>%
      tidyr::spread(sentiment, n, fill = 0) %>%
      dplyr::mutate(sentiment = positive - negative) %>%
      ggplot2::ggplot(ggplot2::aes(index, 
                                   sentiment, 
                                   fill = ep_title)) +
      ggplot2::geom_col(show.legend = F) +
      ggplot2::facet_wrap(~ep_title, ncol = width, scales = "free_x")
  )
}

