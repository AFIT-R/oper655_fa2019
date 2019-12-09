##########################
## Visualize Statistics ##
##########################

huf.5_stats <- function(corpus, episode_range){
  library(dplyr)
  if(!exists("stop_custom")){
    stop_custom <- tibble::tibble(word = NA)
  }
  output <- list()
  # table episodes per season
  unnested <- corpus %>%
    huf.3_unnest("words")
  output[[1]] <- table(unnested$season,unnested$subep)
  
  
  # show top 2 words from each episode
  output[[2]] <- corpus %>% huf.3_unnest("words") %>%
       group_by(ep_title)%>%
       dplyr::anti_join(tidytext::stop_words) %>%
       dplyr::anti_join(stop_custom) %>%
       dplyr::count(word) %>%
       group_by(ep_title) %>%
       dplyr::top_n(n=5)
  
  # calculate frequencies and look for deviations
  # calculate percent of word use across all seasons
  office_pct <- corpus %>%
    huf.3_unnest("words") %>%
    dplyr::anti_join(tidytext::stop_words) %>%
    dplyr::anti_join(stop_custom) %>%
    dplyr::count(word) %>%
    dplyr::transmute(word, all_words = n / sum(n))
  
  # calculate percent of word use within each season
  frequency <- corpus %>% 
    huf.3_unnest("words") %>%
    dplyr::anti_join(tidytext::stop_words) %>%
    dplyr::anti_join(stop_custom) %>%
    dplyr::count(episode, ep_title, word) %>%
    dplyr::mutate(episode_words = n / sum(n)) %>%
    dplyr::left_join(office_pct) %>%
    dplyr::arrange(dplyr::desc(episode_words)) %>%
    dplyr::ungroup()
  
  # Correlation Test
  output[[3]] <- frequency %>%
   dplyr::filter(episode %in% episode_range) %>%
   dplyr::group_by(ep_title) %>%
   dplyr::summarize(correlation = stats::cor(episode_words, all_words),
                    p_value = stats::cor.test(episode_words,
                                              all_words)$p.value) %>%
   dplyr::arrange(dplyr::desc(correlation))
  return(output)
}