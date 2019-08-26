pacman::p_load(harrypotter,
               stringr,
               qdapDictionaries,
               tidyverse,
               tidytext)

titles <- c("Philosopher's Stone", 
            "Chamber of Secrets", 
            "Prisoner of Azkaban",
            "Goblet of Fire", 
            "Order of the Phoenix", 
            "Half-Blood Prince",
            "Deathly Hallows")

books <- list(philosophers_stone, 
              chamber_of_secrets, 
              prisoner_of_azkaban,
              goblet_of_fire, 
              order_of_the_phoenix, 
              half_blood_prince,
              deathly_hallows)

books2 <- list()

for(i in 1:7) {
  
    books2[[i]] <- qdap::mgsub(text.var = books[[i]], 
                               pattern = c(abbreviations[[1]],' ¨C','¨C ','¨C'),
                               replacement = c(abbreviations[[2]],'','',''))
    
    books2[[i]] <- stringr::str_replace_all(books2[[i]],
                                            "[?.!](?=([\"']\\s*[:lower:]))",
                                            replacement = '')

}  
hp_tidy <- tibble::tibble()

for(i in seq_along(titles)) {
        
        clean <- tibble::tibble(chapter = base::seq_along(books2[[i]]),
                                text = books2[[i]]) %>%
             tidytext::unnest_tokens(sentences, text, token = 'sentences',
                                     to_lower = F) %>%
             dplyr::mutate(book = titles[i]) %>%
             dplyr::select(book, dplyr::everything())

        hp_tidy <- base::rbind(hp_tidy, clean)
}

# set factor to keep books in order of publication
hp_tidy$book <- base::factor(hp_tidy$book, levels = base::rev(titles))

hp_tidy


hp_tidy2 <- tidytext::unnest_tokens(hp_tidy, 
                        words, 
                        sentences,
                        to_lower = F, 
                        drop = F)

book_words <- hp_tidy2 %>%
        count(book, words, sort = TRUE) %>%
        ungroup()

series_words <- book_words %>%
        group_by(book) %>%
        summarise(total = sum(n))

book_words <- left_join(book_words, series_words)

book_words <- book_words %>%
        bind_tf_idf(words, book, n)

book_words

final_object <- left_join(hp_tidy2, book_words)

final_object <- final_object %>% 
  group_by(sentences) %>% 
  mutate(words_per_sen = length(words)) %>%
  ungroup() %>%
  subset(words_per_sen > 6)

sum_vals <- final_object %>% 
                group_by(sentences) %>% 
                summarise(avg_sen_tfidf = sum(tf_idf)/length(words))

final_object <- left_join(final_object, sum_vals)

result <- final_object %>%
        dplyr::group_by(book, chapter) %>%
        dplyr::arrange(desc(avg_sen_tfidf)) %>%
        dplyr::filter(dplyr::row_number(avg_sen_tfidf) == n())

result