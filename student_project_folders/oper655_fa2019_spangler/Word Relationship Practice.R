#Word Relationship Practice
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

devtools::install_github("bradleyboehmke/harrypotter")

harrypotter::philosophers_stone[1] #organized by book/chapter

if (!require("pacman")) install.packages("pacman")

pacman::p_load(tm, 
               pdftools, 
               here,
               tau,
               tidyverse,
               stringr,
               tidytext, 
               RColorBrewer,
               qdap,
               qdapRegex,
               qdapDictionaries,
               qdapTools,
               data.table,
               coreNLP,
               scales,
               harrypotter,
               text2vec,
               SnowballC,
               DT,
               quanteda,
               RWeka,
               broom,
               tokenizers,
               grid,
               knitr,
               widyr)

pacman::p_load_gh("dgrtwo/drlib",
                  "trinker/termco", 
                  "trinker/coreNLPsetup",        
                  "trinker/tagger")

#Using TidyText

text_tb <- tibble::tibble(chapter = base::seq_along(philosophers_stone),
                          text = philosophers_stone)
text_tb %>%
  tidytext::unnest_tokens(word, text, token = "words") #split by word

text_tb %>% 
  tidytext::unnest_tokens(bigram, text, token = "ngrams", n = 2) #split by two words

text_tb %>%
  tidytext::unnest_tokens(sentence, text, token = "sentences") #split by sentence

titles <- c("Philospher's Stone",
            "Chamber of Secretes",
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
hp_tidy <- tibble::tibble()

for (i in seq_along(titles)) {
  clean <- tibble::tibble(chapter = base::seq_along(books[[i]]),
                          text = books[[i]]) %>%
    tidytext::unnest_tokens(word, text) %>%
      dplyr::mutate(book = titles[i]) %>%
      dplyr::select(book, dplyr::everything())
  
  hp_tidy <- base::rbind(hp_tidy, clean)
}

#set factor to keep books in order of publication
hp_tidy$book <- base::factor(hp_tidy$book, levels = base::rev(titles))
hp_tidy

#Word Frequency
hp_tidy %>%
  dplyr::count(word, sort = TRUE)

hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
    dplyr::count(word, sort = TRUE)

#Top 10 most common words in each book
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(book) %>%
  dplyr::count(word, sort=TRUE) %>%
  dplyr::top_n(10)

#Visualize with ggplot2
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(book) %>%
  dplyr::count(word, sort=TRUE) %>%
  dplyr::top_n(10) %>%
  ungroup() %>%
    mutate(book = base::factor(book, levels = titles),
           text_order = base::nrow(.),1) %>%
    #pipe output directly to ggplot2
    ggplot(aes(x = reorder(word, -text_order), y = n, fill = book)) +
      geom_bar(stat = "identity") +
      facet_wrap(~ book, scales = "free_y") +
      labs(x = "NULL", y = "Frequency") +
      coord_flip() +
      theme(legend.position = 'none') 
#Calculate percent of word use across all words
potter_pct <- hp_tidy %>%
  anti_join(stop_words) %>%
  count(word) %>%
  transmute(word, all_words = n/sum(n))

#Calculate percent of word use within each novel
frequency_potter <- hp_tidy %>%
  anti_join(stop_words) %>%
  count(book, word) %>%
  mutate(book_words = n/sum(n)) %>%
  left_join(potter_pct) %>%
  arrange(desc(book_words)) %>%
  ungroup()

#Visualize with ggplot2
ggplot(frequency_potter,
       aes(x = book_words,
           y = all_words,
           color = abs(all_words - book_words))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = .01, size = 2.5, width = .3, height = .3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) +
  scale_color_gradient(limits = c(0,.001),
                       low = "darkslategray4",
                       high = "gray75") +
  facet_wrap(~ book, ncol = 2) +
  theme(legend.position = 'none') +
  labs(y="Harry Potter Series", x = NULL)

#Correlation Test
frequency_potter %>%
  dplyr::group_by(book) %>%
  dplyr::summarize(correlation = stats::cor(book_words, all_words),
                   p_value = stats::cor.test(book_words,
                                             all_words)$p.value)

#Using TM
hp_dtm <- tm::VectorSource(books) %>%
  tm::VCorpus() %>%
  tm::DocumentTermMatrix(control = base::list(removePunctuation = TRUE,
                                              removeNumbers = TRUE,
                                              stopwords = tidytext::stop_words[,2],
                                              tokenize = 'MC',
                                              weighting = 
                                                function(x)
                                                  weightTfIdf(x, normalize = !FALSE)))
                        
View(tm::inspect(hp_dtm))
terms <- tm::Terms(hp_dtm)
utils::head(terms,50)

(hp_tidy_tm <- tidytext::tidy(hp_dtm))

tt_funcs <- base::ls(base::getNamespace("tidytext"),
                     all.names = TRUE)

base::grep(pattern = "^tidy", tt_funcs, value = TRUE)
