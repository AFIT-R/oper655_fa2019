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
               here)


EpisodeScripts<-vector()
Season1<-rep("Season_1",10)
Season2<-rep("Season_2",10)
Season3<-rep("Season_3",10)
Season4<-rep("Season_4",10)
Season5<-rep("Season_5",10)
Season6<-rep("Season_6",10)
Season7<-rep("Season_7",6)
Season8<-rep("Season_8",6)
Season<-c(Season1, Season2, Season3, Season4, Season5, Season6, Season7, Season8)

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


########################################



episodes <- list(MyData[,1])
  
hp_tidy <- tibble::tibble()

for(i in seq_along(EpisodeNames)) {
  
  clean <- tibble::tibble(Episode = base::seq_along(episodes[[1]][i]),
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



#Plotting the top 10 in each episode. Its a lot... Yikes
hp_tidy %>%
  anti_join(stop_words) %>%
  group_by(Season) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(book = base::factor(Season, levels = Season),
         text_order = base::nrow(.):1) %>%
  ## Pipe output directly to ggplot
  ggplot(aes(reorder(word, text_order), n, fill = Season)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Episode, scales = "free_y") +
  labs(x = "NULL", y = "Frequency") +
  coord_flip() +
  theme(legend.position="none")

head(hp_tidy)


