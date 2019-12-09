huf.6_plot_tfidf <- function(corpus, episode_range, width, stop_custom){
  library(dplyr)
  if(!exists("stop_custom")){
    stop_custom <- tibble::tibble(word = NA)
  }
  # calculate frequencies and look for deviations
  # calculate percent of word use across all seasons
  series_pct <- corpus %>%
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
    dplyr::left_join(series_pct) %>%
    dplyr::arrange(dplyr::desc(episode_words)) %>%
    dplyr::ungroup()
  
  # Visualize word freq
  print(  
    frequency %>%
      filter(episode %in% episode_range) %>%
      ggplot2::ggplot(ggplot2::aes(x = episode_words, 
                                   y = all_words, 
                                   color = base::abs(all_words - episode_words))) +
      ggplot2::geom_abline(color = "gray40", lty = 2) +
      ggplot2::geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
      ggplot2::geom_text(ggplot2::aes(label = word), check_overlap = TRUE, vjust = 1.5) +
      ggplot2::scale_x_log10(labels = scales::percent_format()) +
      ggplot2::scale_y_log10(labels = scales::percent_format()) +
      ggplot2::scale_color_gradient(limits = c(0, 0.001), 
                                    low = "darkslategray4", 
                                    high = "gray75") +
      ggplot2::facet_wrap(~ ep_title, ncol = 2) +
      ggplot2::theme(legend.position="none") +
      ggplot2::labs(y = "Series", x = NULL)
  )
}