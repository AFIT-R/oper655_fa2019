##########################
## Visualize Statistics ##
##########################

huf.5_stats <- function(corpus, episode_range){
  library(dplyr)
  if(!exists("stop_custom")){
    stop_custom <- tibble::tibble(word = NA)
  }
  # table episodes per season
  base::print(knitr::kable(
      base::table(corpus$season, corpus$subep)
      ,caption = "Episodes in Each Season")
    )
  
  # table episodes per season
  unnested <- 
  table(office_tidy$season,office_tidy$subep)
  
  # show top 2 words from each episode
  base::print(knitr::kable(
    (corpus %>% huf.3_unnest("words") %>%
       group_by(ep_title)%>%
       dplyr::anti_join(tidytext::stop_words) %>%
       dplyr::anti_join(stop_custom) %>%
       dplyr::count(word) %>%
       group_by(ep_title) %>%
       dplyr::top_n(n=1))[1:10,]
    ))
  
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
  
  # Visualize word freq
  base::print(
    frequency %>%
      filter(episode %in% episode_range) %>%
      ggplot2::ggplot(ggplot2::aes(x = episode_words, 
                                   y = all_words, 
                                   color = abs(all_words - episode_words))) +
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
        ggplot2::labs(y = "The Office", x = NULL)
  )
  # Correlation Test
  base::print(
    knitr::kable(frequency %>%
                   dplyr::group_by(season) %>%
                   dplyr::summarize(correlation = stats::cor(season_words, all_words),
                                    p_value = stats::cor.test(season_words,
                                                              all_words)$p.value))
  )
}