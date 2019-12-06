# Text Mining Project: MCU Quantum Analysis
# By: Aaron Giddings

#Installing necessary packages
pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr,      # Tools for qualitative data
               DT)
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
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
#Adding the filepaths
library(here)
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
dest3 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 3')
dest2 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 2')
dest1 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 1')

mcu_phase3 <- list.files(dest3, 
                           pattern = 'pdf',
                           full.names = TRUE)
mcu_phase2 <- list.files(dest2, 
                         pattern = 'pdf',
                         full.names = TRUE)
mcu_phase1 <- list.files(dest1, 
                         pattern = 'pdf',
                         full.names = TRUE)

<<<<<<< HEAD
#Attempting to add the rest of the scripts of the MCU into a corpus.
for (i in 1:8) {
  nam <- paste("tb_pdftools_mcu3",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase3[i]))
}
for (i in 1:6) {
  nam <- paste("tb_pdftools_mcu2",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase2[i]))
}
for (i in 1:5) {
  nam <- paste("tb_pdftools_mcu1",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase1[i]))
}

=======
>>>>>>> c1be969ade6a9957ad9607b20d9eda70b65021b0
#Tibbles (Readable Texts)
#Phase 1 Movies (No Avengers Script)
text_CaptAmerica <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu11),
                                    text = tb_pdftools_mcu11,
                                   movie_number = 5,
                                   release_date = "June 22, 2011",
                                   director = "Joe Johnston",
                                   screenwriter = "Christopher Markus & Stephen McFeely",
                                   producer = "Kevin Feige")
text_IronMan2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu12),
                                text = tb_pdftools_mcu12,
                                movie_number = 3,
                                release_date = "May 7, 2010",
                                director = "Jon Favreau",
                                screenwriter = "Justin Theroux",
                                producer = "Kevin Feige")
text_IronMan <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu13),
                                text = tb_pdftools_mcu13,
                               movie_number = 1,
                               release_date = "May 2, 2008",
                               director = "Jon Favreau",
                               screenwriter = "Mark Fergus, Hawk Ostby, Art Marcum, & Matt Holloway",
                               producer = "Kevin Feige & Avi Arad")
text_Hulk <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu14),
                                text = tb_pdftools_mcu14,
                            movie_number = 2,
                            release_date = "June 13, 2008",
                            director = "Louis Leterrier",
                            screenwriter = "Zak Penn",
                            producer = "Kevin Feige, Avi Arad, & Gale Anne Hurd")
text_Thor <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu15),
                             text = tb_pdftools_mcu15,
                            movie_number = 4,
                            release_date = "May 6, 2011",
                            director = "Kenneth Branagh",
                            screenwriter = "Ashley Edward Miller, Zack Stentz, & Don Payne",
                            producer = "Kevin Feige")
#Phase 2 Movies
text_AntMan <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu21),
                               text = tb_pdftools_mcu21,
                              movie_number = 12,
                              release_date = "June 17, 2015",
                              director = "Peyton Reed",
                              screenwriter = "Edgar Wright, Joe Cornish, Adam McKay, & Paul Rudd",
                              producer = "Kevin Feige")
text_AvengersAOU <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu22),
                                  text = tb_pdftools_mcu22,
                                  movie_number = 11,
                                  release_date = "May 1, 2015",
                                  director = "Joss Whedon",
                                  screenwriter = "Joss Whedon",
                                  producer = "Kevin Feige")
text_CaptAmerica2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu23),
                                    text = tb_pdftools_mcu23,
                                    movie_number = 9,
                                    release_date = "April 4, 2014",
                                    director = "Anthony & Joe Russo",
                                    screenwriter = "Christopher Markus & Stephen McFeely",
                                    producer = "Kevin Feige")
text_GotG <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu24),
                             text = tb_pdftools_mcu24,
                            movie_number = 10,
                            release_date = "August 1, 2014",
                            director = "James Gunn",
                            screenwriter = "James Gunn & Nicole Perlman",
                            producer = "Kevin Feige")
text_IronMan3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu25),
                                   text = tb_pdftools_mcu25,
                                movie_number = 7,
                                release_date = "May 3, 2013",
                                director = "Shane Black",
                                screenwriter = "Drew Pearce & Shane Black",
                                producer = "Kevin Feige")
text_Thor2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu26),
                             text = tb_pdftools_mcu26,
                             movie_number = 8,
                             release_date = "November 8, 2013",
                             director = "Alan Taylor",
                             screenwriter = "Christopher L. Yost, Christopher Markus, & Stephen McFeely",
                             producer = "Kevin Feige")
#Phase 3 Movies (Ends at Avengers: Infinity War)
text_AntMan2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu31),
                          text = tb_pdftools_mcu31,
                          movie_number = 20,
                          release_date = "July 6, 2018",
                          director = "Peyton Reed",
                          screenwriter = "Chris McKenna, Erik Sommers, Paul Rudd, Andrew Barrer, & Gabriel Ferrari",
                          producer = "Kevin Feige & Stephen Broussard")
text_AvengersIW <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu32),
                               text = tb_pdftools_mcu32,
                               movie_number = 19,
                               release_date = "April 27, 2018",
                               director = "Anthony & Joe Russo",
                               screenwriter = "Christopher Markus & Stephen McFeely",
                               producer = "Kevin Feige")
text_BkPanther <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu33),
                               text = tb_pdftools_mcu33,
                               movie_number = 18,
                               release_date = "February 16, 2018",
                               director = "Ryan Coogler",
                               screenwriter = "Ryan Coogler & Joe Robert Cole",
                               producer = "Kevin Feige")
text_CaptAmerica3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu34),
                               text = tb_pdftools_mcu34,
                               movie_number = 13,
                               release_date = "May 6, 2016",
                               director = "Anthony & Joe Russo",
                               screenwriter = "Christopher Markus & Stephen McFeely",
                               producer = "Kevin Feige")
text_DrStrange <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu35),
                               text = tb_pdftools_mcu35,
                               movie_number = 14,
                               release_date = "November 4, 2016",
                               director = "Scott Derrickson",
                               screenwriter = "Jon Spaihts, Scott Derrickson, & C. Robert Cargill",
                               producer = "Kevin Feige")
text_GotG2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu36),
                               text = tb_pdftools_mcu36,
                             movie_number = 15,
                             release_date = "May 5, 2017",
                             director = "James Gunn",
                             screenwriter = "James Gunn",
                             producer = "Kevin Feige")
text_SpiderManHC <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu37),
                               text = tb_pdftools_mcu37,
                               movie_number = 16,
                               release_date = "July 7, 2017",
                               director = "Jon Watts",
                               screenwriter = "Jonathan Goldstein, John Francis Daley, Jon Watts, Christopher Ford, Chris McKenna, & Erik Sommers",
                               producer = "Kevin Feige & Amy Pascal")
text_Thor3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu38),
                               text = tb_pdftools_mcu38,
                             movie_number = 17,
                             release_date = "November 3, 2017",
                             director = "Taika Waititi",
                             screenwriter = "Eric Pearson, Craig Kyle, & Christopher L. Yost",
                             producer = "Kevin Feige")

#Tests
mcu_phase3[1]
tb_pdftools_mcu3 <- pdftools::pdf_text(pdf = mcu_phase3[1])
tb_pdftools_mcu2 <- pdftools::pdf_text(pdf = mcu_phase2[1])
tb_pdftools_mcu1 <- pdftools::pdf_text(pdf = mcu_phase1[1])

#Cursory Analysis (Top 10 Words in a List)
text_CaptAmerica %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_CaptAmerica2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_CaptAmerica3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_IronMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_IronMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_IronMan3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_Hulk %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_AntMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_AntMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_GotG %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_GotG2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_Thor %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_Thor2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_Thor3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_BkPanther %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_DrStrange %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_AvengersAOU %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_AvengersIW %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
text_SpiderManHC %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
# top 10 most common words in each book
#Top 10 words in a Bar Graph
#Ant-Man
am = text_AntMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pam<-ggplot(data=am, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pam
#Ant-Man & the Wasp
am2 = text_AntMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pam2<-ggplot(data=am2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pam2
#Captain America: The First Avenger
ca = text_CaptAmerica %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca<-ggplot(data=ca, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pca
#Captain America: The Winter Soldier
ca2 = text_CaptAmerica2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca2<-ggplot(data=ca2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pca2
#Captain America: Civil War
ca3 = text_CaptAmerica3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca3<-ggplot(data=ca3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pca3
#Iron Man
im = text_IronMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim<-ggplot(data=im, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pim
#Iron Man 2
im2 = text_IronMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim2<-ggplot(data=im2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pim2
#Iron Man 3
im3 = text_IronMan3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim3<-ggplot(data=im3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pim3
#Guardians of the Galaxy
gotg = text_GotG %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg<-ggplot(data=gotg, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pgotg
#Guardians of the Galaxy Volume 2
gotg2 = text_GotG2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg2<-ggplot(data=gotg2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pgotg2
#Thor
t = text_Thor %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt<-ggplot(data=t, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pt
#Thor: The Dark World
t2 = text_Thor2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt2<-ggplot(data=t2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pt2
#Thor: Ragnarok
t3 = text_Thor3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt3<-ggplot(data=t3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pt3
#Spider-Man: Homecoming
sm = text_SpiderManHC %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
psm<-ggplot(data=sm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="red") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
psm
#The Incredible Hulk
h = text_Hulk %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
ph<-ggplot(data=h, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkgreen") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
ph
#Avengers: Age of Ultron
av2 = text_AvengersAOU %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav2<-ggplot(data=av2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pav2
#Avengers: Infinity War
av3 = text_AvengersIW %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav3<-ggplot(data=av3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pav3
#Black Panther
bp = text_BkPanther %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pbp<-ggplot(data=bp, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="black") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pbp
#Doctor Strange
ds = text_DrStrange %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pds<-ggplot(data=ds, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkorange") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pds

#The following code might work better once I figure out how to make each movie a chapter.
# calculate percent of word use across all novels
antman_pct <- am %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::transmute(word, all_words = n / sum(n))

# calculate percent of word use within each novel
frequency_am <- antman_pct %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::mutate(book_words = n / sum(n)) %>%
  dplyr::left_join(antman_pct) %>%
  dplyr::arrange(dplyr::desc(book_words)) %>%
  dplyr::ungroup()

frequency_am

#Adding words to the stop words.
stop_words <- rbind(stop_words, c("53", "SMART"))
stop_words <- rbind(stop_words, c("48", "SMART"))
stop_words <- rbind(stop_words, c("51", "SMART"))
stop_words <- rbind(stop_words, c("47", "SMART"))
stop_words <- rbind(stop_words, c("62", "SMART"))
stop_words <- rbind(stop_words, c("36", "SMART"))
stop_words <- rbind(stop_words, c("48", "SMART"))
stop_words <- rbind(stop_words, c("52", "SMART"))
stop_words <- rbind(stop_words, c("35", "SMART"))
stop_words <- rbind(stop_words, c("41", "SMART"))
stop_words <- rbind(stop_words, c("128", "SMART"))
stop_words <- rbind(stop_words, c("22", "SMART"))
stop_words <- rbind(stop_words, c("180", "SMART"))
stop_words <- rbind(stop_words, c("75", "SMART"))
stop_words <- rbind(stop_words, c("61", "SMART"))
stop_words <- rbind(stop_words, c("147", "SMART"))
stop_words <- rbind(stop_words, c("43", "SMART"))
stop_words <- rbind(stop_words, c("112", "SMART"))
stop_words <- rbind(stop_words, c("page", "SMART"))
stop_words <- rbind(stop_words, c("hey", "SMART"))
stop_words <- rbind(stop_words, c("yeah", "SMART"))
stop_words <- rbind(stop_words, c("cont'd", "SMART"))
stop_words <- rbind(stop_words, c("cont' d", "SMART"))
stop_words <- rbind(stop_words, c("int", "SMART"))
stop_words <- rbind(stop_words, c("gonna", "SMART"))
stop_words <- rbind(stop_words, c("gotta", "SMART"))
stop_words <- rbind(stop_words, c("wanna", "SMART"))
stop_words <- rbind(stop_words, c("revisions", "SMART"))
stop_words <- rbind(stop_words, c("10", "SMART"))
stop_words <- rbind(stop_words, c("26", "SMART"))
stop_words <- rbind(stop_words, c("03", "SMART"))
stop_words <- rbind(stop_words, c("16", "SMART"))
stop_words <- rbind(stop_words, c("20", "SMART"))
stop_words <- rbind(stop_words, c("05", "SMART"))
stop_words <- rbind(stop_words, c("4th", "SMART"))
stop_words <- rbind(stop_words, c("ext", "SMART"))
stop_words <- rbind(stop_words, c("uh", "SMART"))
stop_words <- rbind(stop_words, c("draft", "SMART"))
stop_words <- rbind(stop_words, c("xx", "SMART"))
stop_words <- rbind(stop_words, c("2", "SMART"))
stop_words <- rbind(stop_words, c("continued", "SMART"))
stop_words <- rbind(stop_words, c("marvel", "SMART"))
stop_words <- rbind(stop_words, c("studios", "SMART"))
stop_words <- rbind(stop_words, c("written", "SMART"))
stop_words <- rbind(stop_words, c("07", "SMART"))
stop_words <- rbind(stop_words, c("salmon", "SMART"))
stop_words <- rbind(stop_words, c("2007", "SMART"))
stop_words <- rbind(stop_words, c("consent", "SMART"))
stop_words <- rbind(stop_words, c("duplication", "SMART"))
stop_words <- rbind(stop_words, c("marvel's", "SMART"))
stop_words <- rbind(stop_words, c("omitted", "SMART"))
stop_words <- rbind(stop_words, c("it's", "SMART"))
stop_words <- rbind(stop_words, c("it' s", "SMART"))
stop_words <- rbind(stop_words, c("marvel' s", "SMART"))

#Phase Tibbles
text_mcu_p1 <- rbind(text_IronMan,
                     text_CaptAmerica,
                     text_Hulk,
                     text_IronMan2,
                     text_Thor)
text_mcu_p2 <- rbind(text_IronMan3,
                     text_CaptAmerica2,
                     text_GotG,
                     text_AntMan,
                     text_Thor2,
                     text_AvengersAOU)
text_mcu_p3 <- rbind(text_SpiderManHC,
                     text_CaptAmerica3,
                     text_GotG2,
                     text_AntMan2,
                     text_Thor3,
                     text_AvengersIW,
                     text_BkPanther,
                     text_DrStrange)
#The entire MCU
text_mcu <- rbind(text_mcu_p1, text_mcu_p2, text_mcu_p3)
#Series Tibbles
text_AM_Comb <- rbind(text_AntMan, text_AntMan2)
text_GotG_Comb <- rbind(text_GotG, text_GotG2)
text_AV_Comb <- rbind(text_AvengersAOU, text_AvengersIW)
text_CA_Tril <- rbind(text_CaptAmerica, text_CaptAmerica2, text_CaptAmerica3)
text_IM_Tril <- rbind(text_IronMan, text_IronMan2, text_IronMan3)
text_Thor_Tril <- rbind(text_Thor, text_Thor2, text_Thor3)
#Cursory Analysis by Phase
#Phase 1
mcup1 = text_mcu_p1 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pmcup1<-ggplot(data=mcup1, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pmcup1
#Phase 2
mcup2 = text_mcu_p2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pmcup2<-ggplot(data=mcup2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pmcup2
#Phase 3
mcup3 = text_mcu_p3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pmcup3<-ggplot(data=mcup3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pmcup3
#The Entire MCU
mcu = text_mcu %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pmcu<-ggplot(data=mcu, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="black") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pmcu
#The Captain America Movies
catm = text_CA_Tril %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pcatm<-ggplot(data=catm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pcatm
#The Iron Man Movies
imtm = text_IM_Tril %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pimtm<-ggplot(data=imtm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pimtm
#The Thor Movies
ttm = text_Thor_Tril %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pttm<-ggplot(data=ttm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pttm
#The Ant-Man Movies
acm = text_AM_Comb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pacm<-ggplot(data=acm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pacm
#The Avengers Movies
avcm = text_AV_Comb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pavcm<-ggplot(data=avcm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pavcm
#The Guardians of the Galaxy Movies
gotgcm = text_GotG_Comb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotgcm<-ggplot(data=gotgcm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words") +
  xlab("Words") +
  ylab("Count")
pgotgcm
#Named Entity Recognition
pacman::p_load(tidyr,
               tidytext,
               tidyverse,
               textdata,
               dplyr,
               stringr,
               ggplot2,
               magrittr,
               wordcloud,
               reshape2,
               entity,
               monkeylearn,
               quanteda,
               spacyr,
               rJava,
               NLP,
               openNLP)
spacy_initialize()

#Unnesting tokens
tidytext::unnest_tokens(text_mcu, word, text)

mcu_data <- as.data.frame(text_mcu[1:7], stringsAsFactors = FALSE)
mcu_parsed <- spacy_parse(mcu_data$text, entity = TRUE)
mcu_extracted <- entity_extract(mcu_parsed)

#Entity Type Graph
mcu_extracted %>%
  filter(entity_type != "CARDINAL" & entity_type != "ORDINAL") %>%
  count(entity_type) %>%
  top_n(10) %>%
  ggplot(aes(x = entity_type, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Entity Types") +
  xlab("Entity Type") +
  ylab("Count")

#Products in the MCU
mcu_extracted %>%
  filter(entity_type == "PRODUCT") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(10) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Product Entities") +
  xlab("Products") +
  ylab("Mentions")

#Organizations in the MCU
mcu_extracted %>%
  filter(entity_type == "ORG") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(20) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Organization Entities") +
  xlab("Organizatons") +
  ylab("Mentions")

#People in the MCU
mcu_extracted %>%
  filter(entity_type == "PERSON" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(10) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "What it Labeled as Persons") +
  xlab("Persons") +
  ylab("Mentions")

#Locations in the MCU
mcu_extracted %>%
  filter(entity_type == "LOC" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(10) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  labs(title = "Location Entities") +
  xlab("Locations") +
  ylab("Mentions")

#Geopolitical Entities in the MCU
mcu_extracted %>%
  filter(entity_type == "GPE" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(10) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  labs(title = "Geopolitical Entities") +
  xlab("Geopolitcal Entities") +
  ylab("Mentions")
