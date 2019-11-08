install.packages("pacman")

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
               tesseract,
               tools,
               readxl,
               here,
               tm,
               text2vec,
               igraph,
               textmineR,
               tidytext)


EpisodeScripts<-vector()
Season1<-rep("Season_1",10)
Season2<-rep("Season_2",10)
Season3<-rep("Season_3",10)
Season4<-rep("Season_4",10)
Season5<-rep("Season_5",10)
Season6<-rep("Season_6",10)
Season7<-rep("Season_7",6)
Season8<-rep("Season_8",6)
SeasonNames<-c(Season1, Season2, Season3, Season4, Season5, Season6, Season7, Season8)

EpisodeNames<-c("Winter is Coming","The Kingsroad", "Lord Snow", "Cripples, Bastards and Broken Things","The Wolf and the Lion","A Golden Crown","You Win or You Die","The Pointy End","Baelor","Fire and Blood","The North Remembers","The Night Lands","What Is Dead May Never Die",	"Garden of Bones","The Ghost of Harrenhal","The Old Gods and the New",	"A Man Without Honor",	"The Prince of Winterfell","Blackwater","Valar Morghulis","Valar Dohaeris",	"Dark Wings, Dark Words",	"Walk of Punishment",	"And Now His Watch Is Ended",	"Kissed by Fire","The Climb","The Bear and the Maiden Fair",	"Second Sons","The Rains of Castamere",	"Mhysa","Two Swords",	"The Lion and the Rose",	"Breaker of Chains",	"Oathkeeper","First of His Name","The Laws of Gods and Men","Mockingbird",	"The Mountain and the Viper",	"The Watchers on the Wall","The Children","The Wars to Come","The House of Black and White",	"High Sparrow","Sons of the Harpy",	"Kill the Boy","Unbowed, Unbent, Unbroken","The Gift","Hardhome","The Dance of Dragons","Mother's Mercy","The Red Woman",	"Home","Oathbreaker",	"Book of the Stranger",	"The Door",	"Blood of My Blood",	"The Broken Man",	"No One",	"Battle of the Bastards","The Winds of Winter","Stormborn","The Queen's Justice","The Spoils of War",	"Eastwatch",	"Beyond the Wall","The Dragon and the Wolf","Winterfell",	"A Knight of the Seven Kingdoms","The Long Night","The Last of the Starks",	"The Bells",	"The Iron Throne")



######################################### READ IN DATA (MORE TO BE DONE TO MAKE IT AUTOMATED)

url  <- 'https://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=game-of-thrones&episode=s01e08'
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)
xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)

EpisodeScripts[8]<-xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
view(EpisodeScripts)
colnames(EpisodeScripts)[1]<-"Text"
MyData<-EpisodeScripts
MyData<-cbind(MyData, EpisodeNames)
view(MyData)

########################################## CLEAN UP DATA AS BEST I CAN

MyData <- stringr::str_replace_all(MyData, "<br */>", "")
MyData <- stringr::str_replace_all(MyData, "\r", "")
MyData <- stringr::str_replace_all(MyData, "\t", "")
MyData <- stringr::str_replace_all(MyData, "\n", "")
MyData <- stringr::str_replace_all(MyData, "\"", "")
MyData[23]
MyData<-cbind(MyData, Season)
View(MyData)
colnames(MyData)[1]<-"Text"




######################################### DOCUMENT SUMMARIZATION

library(textmineR)


# First create a TCM using skip grams, we'll use a 5-word window
# most options available on CreateDtm are also available for CreateTcm
tcm <- CreateTcm(doc_vec = MyData[,1],
                 skipgram_window = 10,
                 verbose = FALSE,
                 cpus = 2)

# use LDA to get embeddings into probability space
# This will take considerably longer as the TCM matrix has many more rows 
# than a DTM
embeddings <- FitLdaModel(dtm = tcm,
                          k = 50,
                          iterations = 200,
                          burnin = 180,
                          alpha = 0.1,
                          beta = 0.05,
                          optimize_alpha = TRUE,
                          calc_likelihood = FALSE,
                          calc_coherence = FALSE,
                          calc_r2 = FALSE,
                          cpus = 2)


# parse it into sentences
sent <- stringi::stri_split_boundaries(MyData, type = "sentence")[[ 4 ]]

names(sent) <- seq_along(sent) # so we know index and order

# embed the sentences in the model
e <- CreateDtm(sent, ngram_window = c(1,1), verbose = FALSE, cpus = 2)

# remove any documents with 2 or fewer words
e <- e[ rowSums(e) > 2 , ]

vocab <- intersect(colnames(e), colnames(gamma))

e <- e / rowSums(e)

e <- e[ , vocab ] %*% t(gamma[ , vocab ])

e <- as.matrix(e)





# get the pairwise distances between each embedded sentence
e_dist <- CalcHellingerDist(e)

# turn into a similarity matrix
g <- (1 - e_dist) * 100

# we don't need sentences connected to themselves
diag(g) <- 0

# turn into a nearest-neighbor graph
g <- apply(g, 1, function(x){
  x[ x < sort(x, decreasing = TRUE)[ 3 ] ] <- 0
  x
})

# by taking pointwise max, we'll make the matrix symmetric again
g <- pmax(g, t(g))



library(igraph)
g <- graph.adjacency(g, mode = "undirected", weighted = TRUE)

# calculate eigenvector centrality
ev <- evcent(g)

# format the result
result <- sent[ names(ev$vector)[ order(ev$vector, decreasing = TRUE)[ 1:3 ] ] ]

result <- result[ order(as.numeric(names(result))) ]

paste(result, collapse = " ")


######################################## TFIDF STUFF



episodes <- MyData[,1]
  
hp_tidy <- tibble::tibble()

for(i in seq_along(EpisodeNames)) {
  
  clean <- tibble::tibble(Episode = base::seq_along(episodes[[i]]),
                          text = episodes[[i]]) %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::mutate(Episode = EpisodeNames[i]) %>%
    dplyr::select(Episode, dplyr::everything())
  
  hp_tidy <- base::rbind(hp_tidy, clean)
}

# set factor to keep books in order of publication
hp_tidy$Episode <- base::factor(hp_tidy$Episode, levels = base::rev(EpisodeNames))

#Count overall words in series
hp_tidy %>%
  dplyr::count(word, sort = TRUE)%>%
  anti_join(stop_words)



# top 10 most common words by epsiode
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(Episode) %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::top_n(10)




#Plotting the top 10 in each episode. Its a lot... Yikes
hp_tidy %>%
  anti_join(stop_words) %>%
  group_by(Episode) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(book = base::factor(Episode, levels = EpisodeNames),
         text_order = base::nrow(.):1) %>%
  ## Pipe output directly to ggplot
  ggplot(aes(reorder(word, text_order), n, fill = Episode)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Episode, scales = "free_y") +
  labs(x = "NULL", y = "Frequency") +
  coord_flip() +
  theme(legend.position="none")




# calculate percent of word use across all episodes
GOT_pct <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::transmute(word, all_words = n / sum(n))

# calculate percent of word use within each novel
frequency <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(Episode, word) %>%
  dplyr::mutate(Episode_words = n / sum(n)) %>%
  dplyr::left_join(GOT_pct) %>%
  dplyr::arrange(dplyr::desc(Episode_words)) %>%
  dplyr::ungroup()

frequency


ggplot(frequency, 
       aes(x = Episode_words, 
           y = all_words, 
           color = abs(all_words - Episode_words))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", 
                       high = "gray75") +
  facet_wrap(~ Episode, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "GOT Series", x = NULL)


frequency %>%
  dplyr::group_by(Episode) %>%
  dplyr::summarize(correlation = stats::cor(Episode_words, all_words),
                   p_value = stats::cor.test(Episode_words,
                                             all_words)$p.value)


hp_dtm <- tm::VectorSource(EpisodeNames) %>%
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

(hp_tidy_tm <- tidytext::tidy(hp_dtm))

tt_funcs <- base::ls(base::getNamespace("tidytext"), 
                     all.names = TRUE)

base::grep(pattern = '^tidy.', tt_funcs, value = T)

# cast tidy data to a DFM object 
# for use with the quanteda package
hp_tidy_tm %>%
  cast_dfm(term, document, count)

hp_tidy_tm %>%
  cast_dtm(term, document, count)



t2v_tokens = EpisodeNames   %>% 
  tolower %>% 
  tokenizers::tokenize_words()

t2v_itoken = text2vec::itoken(t2v_tokens, 
                              progressbar = FALSE)

(t2v_vocab = text2vec::create_vocabulary(t2v_itoken,
                                         stopwords = tidytext::stop_words[[1]]))
t2v_dtm = create_dtm(t2v_itoken, hash_vectorizer())
model_tfidf = TfIdf$new()
dtm_tfidf = model_tfidf$fit_transform(t2v_dtm)


episode_words <- hp_tidy %>%
  count(Episode, word, sort = TRUE) %>%
  dplyr::anti_join(stop_words) %>%
  ungroup()

series_words <- episode_words %>%
  group_by(Episode) %>%
  summarise(total = sum(n))

episode_words <- left_join(episode_words, series_words)

episode_words




episode_words %>%
  mutate(ratio = n / total) %>%
  ggplot(aes(ratio, fill = Episode)) +
  geom_histogram(show.legend = FALSE) +
  scale_x_log10() +
  facet_wrap(~ Episode, ncol = 2)


episode_words <- episode_words %>%
  bind_tf_idf(word, Episode, n)

episode_words

episode_words %>%
  dplyr::arrange(dplyr::desc(tf_idf))



episode_words %>%
  dplyr::arrange(dplyr::desc(tf_idf)) %>%
  dplyr::mutate(word = base::factor(word, levels = base::rev(base::unique(word))),
                Episode = base::factor(Episode, levels = EpisodeNames)) %>% 
  dplyr::group_by(Episode) %>%
  dplyr::top_n(15, wt = tf_idf) %>%
  dplyr::ungroup() %>%
  dplyr::select(season = Season) %>%
  ggplot(aes(word, tf_idf, fill = Episode)) +
  geom_bar(stat = "identity", alpha = .8, show.legend = FALSE) +
  labs(title = "Highest tf-idf words in GOT",
       x = NULL, y = "tf-idf") +
  #facet_wrap(~Episode, ncol = 2, scales = "free") +
  coord_flip()

######################################################




Season1Text<-paste(MyData[1,1],MyData[2,1],MyData[3,1],MyData[4,1],MyData[5,1],MyData[6,1], MyData[7,1], MyData[8,1], MyData[9,1], MyData[10,1])
Season2Text<-paste(MyData[11,1],MyData[12,1],MyData[13,1],MyData[14,1],MyData[15,1],MyData[16,1], MyData[17,1], MyData[18,1], MyData[19,1], MyData[20,1])
Season3Text<-paste(MyData[21,1],MyData[22,1],MyData[23,1],MyData[24,1],MyData[25,1],MyData[26,1], MyData[27,1], MyData[28,1], MyData[29,1], MyData[30,1])
Season4Text<-paste(MyData[31,1],MyData[32,1],MyData[33,1],MyData[34,1],MyData[35,1],MyData[36,1], MyData[37,1], MyData[38,1], MyData[39,1], MyData[40,1])
Season5Text<-paste(MyData[41,1],MyData[42,1],MyData[43,1],MyData[44,1],MyData[45,1],MyData[46,1], MyData[47,1], MyData[48,1], MyData[49,1], MyData[50,1])
Season6Text<-paste(MyData[51,1],MyData[52,1],MyData[53,1],MyData[54,1],MyData[55,1],MyData[56,1], MyData[57,1], MyData[58,1], MyData[59,1], MyData[60,1])
Season7Text<-paste(MyData[61,1],MyData[62,1],MyData[63,1],MyData[64,1],MyData[65,1],MyData[66,1])
Season8Text<-paste(MyData[67,1],MyData[68,1],MyData[69,1],MyData[70,1],MyData[71,1],MyData[72,1])
SeasonNames<-c("Season 1", "Season 2", "Season 3", "Season 4", "Season 5", "Season 6", "Season 7", "Season 8")
MyDataBySeason<-c(Season1Text, Season2Text, Season3Text, Season4Text, Season5Text, Season6Text, Season7Text, Season8Text)
MyDataBySeason<-data.frame(MyDataBySeason,SeasonNames)

seasons <- MyDataBySeason[,1]

hp_tidy2 <- tibble::tibble()

for(i in seq_along(SeasonNames)) {
  
  clean2 <- tibble::tibble(Season = base::seq_along(seasons[[i]]),
                          text = seasons[[i]]) %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::mutate(Season = SeasonNames[i]) %>%
    dplyr::select(Season, dplyr::everything())
  
  hp_tidy2 <- base::rbind(hp_tidy2, clean2)
}

# set factor to keep books in order of publication
hp_tidy$Season <- base::factor(hp_tidy$Season, levels = base::rev(SeasonNames))

#Count overall words in series
hp_tidy %>%
  dplyr::count(word, sort = TRUE)%>%
  anti_join(stop_words)



# top 10 most common words by epsiode
hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::group_by(Episode) %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::top_n(10)




#Plotting the top 10 in each episode. Its a lot... Yikes
hp_tidy %>%
  anti_join(stop_words) %>%
  group_by(Episode) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(book = base::factor(Episode, levels = EpisodeNames),
         text_order = base::nrow(.):1) %>%
  ## Pipe output directly to ggplot
  ggplot(aes(reorder(word, text_order), n, fill = Episode)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Episode, scales = "free_y") +
  labs(x = "NULL", y = "Frequency") +
  coord_flip() +
  theme(legend.position="none")




# calculate percent of word use across all episodes
GOT_pct <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::transmute(word, all_words = n / sum(n))

# calculate percent of word use within each novel
frequency <- hp_tidy %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(Episode, word) %>%
  dplyr::mutate(Episode_words = n / sum(n)) %>%
  dplyr::left_join(GOT_pct) %>%
  dplyr::arrange(dplyr::desc(Episode_words)) %>%
  dplyr::ungroup()

frequency


ggplot(frequency, 
       aes(x = Episode_words, 
           y = all_words, 
           color = abs(all_words - Episode_words))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", 
                       high = "gray75") +
  facet_wrap(~ Episode, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "GOT Series", x = NULL)


frequency %>%
  dplyr::group_by(Episode) %>%
  dplyr::summarize(correlation = stats::cor(Episode_words, all_words),
                   p_value = stats::cor.test(Episode_words,
                                             all_words)$p.value)


hp_dtm <- tm::VectorSource(EpisodeNames) %>%
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

(hp_tidy_tm <- tidytext::tidy(hp_dtm))

tt_funcs <- base::ls(base::getNamespace("tidytext"), 
                     all.names = TRUE)

base::grep(pattern = '^tidy.', tt_funcs, value = T)

# cast tidy data to a DFM object 
# for use with the quanteda package
hp_tidy_tm %>%
  cast_dfm(term, document, count)

hp_tidy_tm %>%
  cast_dtm(term, document, count)



library(text2vec)
t2v_tokens = EpisodeNames   %>% 
  tolower %>% 
  tokenizers::tokenize_words()

t2v_itoken = text2vec::itoken(t2v_tokens, 
                              progressbar = FALSE)

(t2v_vocab = text2vec::create_vocabulary(t2v_itoken,
                                         stopwords = tidytext::stop_words[[1]]))
t2v_dtm = create_dtm(t2v_itoken, hash_vectorizer())
model_tfidf = TfIdf$new()
dtm_tfidf = model_tfidf$fit_transform(t2v_dtm)


episode_words <- hp_tidy %>%
  count(Episode, word, sort = TRUE) %>%
  dplyr::anti_join(stop_words) %>%
  ungroup()

series_words <- episode_words %>%
  group_by(Episode) %>%
  summarise(total = sum(n))

episode_words <- left_join(episode_words, series_words)

episode_words




episode_words %>%
  mutate(ratio = n / total) %>%
  ggplot(aes(ratio, fill = Episode)) +
  geom_histogram(show.legend = FALSE) +
  scale_x_log10() +
  facet_wrap(~ Episode, ncol = 2)


episode_words <- episode_words %>%
  bind_tf_idf(word, Episode, n)

episode_words

episode_words %>%
  dplyr::arrange(dplyr::desc(tf_idf))



episode_words %>%
  dplyr::arrange(dplyr::desc(tf_idf)) %>%
  dplyr::mutate(word = base::factor(word, levels = base::rev(base::unique(word))),
                Episode = base::factor(Episode, levels = EpisodeNames)) %>% 
  dplyr::group_by(Episode) %>%
  dplyr::top_n(15, wt = tf_idf) %>%
  dplyr::ungroup() %>%
  ggplot(aes(word, tf_idf, fill = Episode)) +
  geom_bar(stat = "identity", alpha = .8, show.legend = FALSE) +
  labs(title = "Highest tf-idf words in GOT",
       x = NULL, y = "tf-idf") +
  facet_wrap(~Episode, ncol = 2, scales = "free") +
  coord_flip()
