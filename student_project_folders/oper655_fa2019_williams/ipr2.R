#Project

#install pcaman anf necessry packages
install.packages("pacman")
install.packages("quanteda")
library("quanteda")
install.packages("ggplot")

pacman::p_load(XML,
               rvest,
               RCurl,
               rprojroot,
               qdapTools,
               pdftools,
               antiword,
               glue,
               data.table,
               tidyverse,
               vroom,
               antiword,
               magick,
               tesseract)



root <- rprojroot::find_root(rprojroot::is_rstudio_project)

dest <- file.path(root, 'student_project_folders', 'oper655_fa2019_williams')

xpdf_tools <- 'C:/Program Files/xpdf-tools-win-4.02/bin64'

# make a vector of PDF file names
(pdf_files <- list.files(path = dest,
                         pattern = "pdf",
                         full.names = TRUE))




text_files <- list.files(path = dest,
                         pattern = "txt",
                         full.names = TRUE)

text1 <- readLines(con = text_files)

text2 <- pdftools::pdf_text(pdf = pdf_files[1])
text2[1]

text3 <- pdftools::pdf_text(pdf = pdf_files[2])
text3[1]

#write pdfs as txt files
writeLines(text = text2, con = gsub('pdf','txt', file.path(dest,basename(pdf_files[1]))))
writeLines(text = text3, con = gsub('pdf','txt', file.path(dest,basename(pdf_files[2]))))

#make single charcter vector for  each document

fa <- paste(text2,
             collapse = "\n\n")
attr(fa, "names") <- "The Force Awakens"

nh <- paste(text3,
            collapse = "\n\n")
attr(nh, "names") <- " A New Hope"

#make corpus

sw_movies <- c(fa, nh)
sw_corpus <- quanteda::corpus(sw_movies)

docvars(sw_corpus, "movies") <- names(sw_movies)


summary(sw_corpus, showmeta = TRUE)

kwic(sw_corpus, pattern = "force")



#load packages for analysis
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

text_tb <- tibble::tibble(chapter = base::seq_along(text2),
                          text = text2)

text_tb


 text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)


 
 text_tb %>%
   dplyr::anti_join(stop_words) %>%
   dplyr::group_by(book) %>%
   dplyr::count(word, sort = TRUE) %>%
   dplyr::top_n(10)
 
 
# top 10 in the document
a = text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)


p<-ggplot(data=a, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="steelblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
p



#Combine movie text for amalysis

titles <- c("The Force Awakens", 
            "A New Hope")

movies <- list(fa, 
              nh)

hp_tidy <- tibble::tibble()

for(i in seq_along(titles)) {
  
  clean <- tibble::tibble(chapter = base::seq_along(movies[[i]]),
                          text = movies[[i]]) %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::mutate(movie = titles[i]) %>%
    dplyr::select(movie, dplyr::everything())
  
  hp_tidy <- base::rbind(hp_tidy, clean)
}

#Get top 10 words in each movie
hp_tidy
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(movie) %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::top_n(10)

# plot top 10 most common words in each movie
hp_tidy %>%
  anti_join(stop_words) %>%
  group_by(movie) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(movie = base::factor(movie, levels = titles),
         text_order = base::nrow(.):1) %>%
  ## Pipe output directly to ggplot
  ggplot(aes(reorder(word, text_order), n, fill = movie)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ movie, scales = "free_y") +
  labs(x = "NULL", y = "Frequency") +
  coord_flip() +
  theme(legend.position="none")


movie_words <- hp_tidy %>%
  count(movie, word, sort = TRUE) %>%
  dplyr::anti_join(stop_words) %>%
  ungroup()

series_words <- movie_words %>%
  group_by(movie) %>%
  summarise(total = sum(n))

movie_words <- left_join(movie_words, series_words)

movie_words

#TF-idf
movie_words <- movie_words %>%
  bind_tf_idf(word, movie, n)

movie_words

#plot tf-idf
movie_words %>%
  dplyr::arrange(dplyr::desc(tf_idf)) %>%
  dplyr::mutate(word = base::factor(word, levels = base::rev(base::unique(word))),
                book = base::factor(movie, levels = titles)) %>% 
  dplyr::group_by(book) %>%
  dplyr::top_n(15, wt = tf_idf) %>%
  dplyr::ungroup() %>%
  ggplot(aes(word, tf_idf, fill = movie)) +
  geom_bar(stat = "identity", alpha = .8, show.legend = FALSE) +
  labs(title = "Highest tf-idf words in the Star Wars Episode IV and VII",
       x = NULL, y = "tf-idf") +
  facet_wrap(~movie, ncol = 2, scales = "free") +
  coord_flip()

