# Install Harry Potter Package
install.packages("devtools")
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

devtools::install_github("bradleyboehmke/harrypotter")

# Additional libraries
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

#Tokenization - turn data into a tibble then unnest the tokens
text_tb <- tibble::tibble(chapter = base::seq_along(philosophers_stone),
                          text = philosophers_stone) %>%
          tidytext::unnest_tokens(word, text, token = 'sentences')
  #'words' could be replaced with 'ngrams',n=2 or 'sentences'


# Do the same thing but loop through each novel
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

hp_tidy <- tibble::tibble()

for(i in seq_along(titles)) {
  
  clean <- tibble::tibble(chapter = base::seq_along(books[[i]]),
                          text = books[[i]]) %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::mutate(book = titles[i]) %>%
    dplyr::select(book, dplyr::everything())
  
  hp_tidy <- base::rbind(hp_tidy, clean)
}

# set factor to keep books in order of publication
hp_tidy$book <- base::factor(hp_tidy$book, levels = base::rev(titles))

hp_tidy

# word frequency count
hp_tidy %>%
  dplyr::count(word, sort = TRUE)

# remove stop words
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)

# group by chapter or book
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(book) %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::top_n(10)

# visualize with ggplot2
# top 10 most common words in each book
hp_tidy %>%
  anti_join(stop_words) %>%
  group_by(book) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(book = base::factor(book, levels = titles),
         text_order = base::nrow(.):1) %>%
  ## Pipe output directly to ggplot
  ggplot(aes(reorder(word, text_order), n, fill = book)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ book, scales = "free_y") +
  labs(x = "NULL", y = "Frequency") +
  coord_flip() +
  theme(legend.position="none")

# calculate frequencies and look for deviations
# calculate percent of word use across all novels
potter_pct <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::transmute(word, all_words = n / sum(n))

# calculate percent of word use within each novel
frequency <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(book, word) %>%
  dplyr::mutate(book_words = n / sum(n)) %>%
  dplyr::left_join(potter_pct) %>%
  dplyr::arrange(dplyr::desc(book_words)) %>%
  dplyr::ungroup()

frequency

# Visualize word freq
ggplot(frequency, 
       aes(x = book_words, 
           y = all_words, 
           color = abs(all_words - book_words))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", 
                       high = "gray75") +
  facet_wrap(~ book, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Harry Potter Series", x = NULL)

# Correlation Test
frequency %>%
  dplyr::group_by(book) %>%
  dplyr::summarize(correlation = stats::cor(book_words, all_words),
                   p_value = stats::cor.test(book_words,
                                             all_words)$p.value)


# Document Term Matrices
hp_dtm <- tm::VectorSource(books) %>%
  tm::VCorpus() %>%
  tm::DocumentTermMatrix(control = base::list(removePunctuation = TRUE,
                                              removeNumbers = TRUE,
                                              stopwords = tidytext::stop_words[,2],
                                              tokenize = 'MC',
                                              weighting =
                                                function(x)
                                                  weightTfIdf(x, normalize =
                                                                !FALSE)))

tm::inspect(hp_dtm)

terms <- tm::Terms(hp_dtm)
utils::head(terms, 50)

# Convert to tidy df
(hp_tidy_tm <- tidytext::tidy(hp_dtm))

# List tidy functions
tt_funcs <- base::ls(base::getNamespace("tidytext"), 
                     all.names = TRUE)

base::grep(pattern = '^tidy.', tt_funcs, value = T)

# cast tidy data to a DFM object 
# for use with the quanteda package
hp_tidy_tm %>%
  cast_dfm(term, document, count)

# cast tidy data to a DocumentTermMatrix 
# object for use with the `tm` package
hp_tidy_tm %>%
  cast_dtm(term, document, count)

# cast tidy data to a TermDocumentMatrix 
# object for use with the `tm` package
hp_tidy_tm %>%
  cast_tdm(term, document, count)

# cast tidy data to a sparse matrix
# uses the Matrix package
hp_tidy_tm %>%
  cast_sparse(term, document, count) %>%
  dim

# Using the text2vec package
t2v_tokens = books   %>% 
  tolower %>% 
  tokenizers::tokenize_words()

t2v_itoken = text2vec::itoken(t2v_tokens, 
                              progressbar = FALSE)

(t2v_vocab = text2vec::create_vocabulary(t2v_itoken,
                                         stopwords = tidytext::stop_words[[1]]))

t2v_dtm = create_dtm(t2v_itoken, hash_vectorizer())
model_tfidf = TfIdf$new()
dtm_tfidf = model_tfidf$fit_transform(t2v_dtm)

# Term Frequencies
book_words <- hp_tidy %>%
  count(book, word, sort = TRUE) %>%
  dplyr::anti_join(stop_words) %>%
  ungroup()

series_words <- book_words %>%
  group_by(book) %>%
  summarise(total = sum(n))

book_words <- left_join(book_words, series_words)

book_words


