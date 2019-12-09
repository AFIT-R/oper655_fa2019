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

#Attempting to add the rest of the scripts of the MCU into a corpus.
for (i in 1:8) {
  nam <- paste("tb_pdftools_mcu3",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase3[i]))
}
for (i in 1:6) {
  nam <- paste("tb_pdftools_mcu2",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase2[i]))
}
for (i in 1:6) {
  nam <- paste("tb_pdftools_mcu1",i,sep = "")
  assign(nam,pdftools::pdf_text(pdf = mcu_phase1[i]))
}

#Tibbles (Readable Texts)
#Phase 1 Movies
text_CaptAmerica <- tibble::tibble(title = "Captain America: The First Avenger",
                                   chapter = base::seq_along(tb_pdftools_mcu11),
                                    text = tb_pdftools_mcu11,
                                   movie_number = 5,
                                   mcu_phase = 1,
                                   release_date = "June 22, 2011",
                                   director = "Joe Johnston",
                                   screenwriter = "Christopher Markus & Stephen McFeely",
                                   producer = "Kevin Feige")
text_IronMan2 <- tibble::tibble(title = "Iron Man 2",
                                chapter = base::seq_along(tb_pdftools_mcu12),
                                text = tb_pdftools_mcu12,
                                movie_number = 3,
                                mcu_phase = 1,
                                release_date = "May 7, 2010",
                                director = "Jon Favreau",
                                screenwriter = "Justin Theroux",
                                producer = "Kevin Feige")
text_IronMan <- tibble::tibble(title = "Iron Man",
                               chapter = base::seq_along(tb_pdftools_mcu13),
                                text = tb_pdftools_mcu13,
                               movie_number = 1,
                               mcu_phase = 1,
                               release_date = "May 2, 2008",
                               director = "Jon Favreau",
                               screenwriter = "Mark Fergus, Hawk Ostby, Art Marcum, & Matt Holloway",
                               producer = "Kevin Feige & Avi Arad")
text_Avengers <- tibble::tibble(title = "The Avengers",
                               chapter = base::seq_along(tb_pdftools_mcu14),
                               text = tb_pdftools_mcu14,
                               movie_number = 6,
                               mcu_phase = 1,
                               release_date = "May 4, 2012",
                               director = "Joss Whedon",
                               screenwriter = "Joss Whedon",
                               producer = "Kevin Feige")
text_Hulk <- tibble::tibble(title = "The Incredible Hulk",
                            chapter = base::seq_along(tb_pdftools_mcu15),
                            text = tb_pdftools_mcu15,
                            movie_number = 2,
                            mcu_phase = 1,
                            release_date = "June 13, 2008",
                            director = "Louis Leterrier",
                            screenwriter = "Zak Penn",
                            producer = "Kevin Feige, Avi Arad, & Gale Anne Hurd")
text_Thor <- tibble::tibble(title = "Thor",
                            chapter = base::seq_along(tb_pdftools_mcu16),
                             text = tb_pdftools_mcu16,
                            movie_number = 4,
                            mcu_phase = 1,
                            release_date = "May 6, 2011",
                            director = "Kenneth Branagh",
                            screenwriter = "Ashley Edward Miller, Zack Stentz, & Don Payne",
                            producer = "Kevin Feige")
#Phase 2 Movies
text_AntMan <- tibble::tibble(title = "Ant-Man",
                              chapter = base::seq_along(tb_pdftools_mcu21),
                               text = tb_pdftools_mcu21,
                              movie_number = 12,
                              mcu_phase = 2,
                              release_date = "June 17, 2015",
                              director = "Peyton Reed",
                              screenwriter = "Edgar Wright, Joe Cornish, Adam McKay, & Paul Rudd",
                              producer = "Kevin Feige")
text_AvengersAOU <- tibble::tibble(title = "Avengers: Age of Ultron",
                                   chapter = base::seq_along(tb_pdftools_mcu22),
                                  text = tb_pdftools_mcu22,
                                  movie_number = 11,
                                  mcu_phase = 2,
                                  release_date = "May 1, 2015",
                                  director = "Joss Whedon",
                                  screenwriter = "Joss Whedon",
                                  producer = "Kevin Feige")
text_CaptAmerica2 <- tibble::tibble(title = "Captain America: The Winter Soldier",
                                    chapter = base::seq_along(tb_pdftools_mcu23),
                                    text = tb_pdftools_mcu23,
                                    movie_number = 9,
                                    mcu_phase = 2,
                                    release_date = "April 4, 2014",
                                    director = "Anthony & Joe Russo",
                                    screenwriter = "Christopher Markus & Stephen McFeely",
                                    producer = "Kevin Feige")
text_GotG <- tibble::tibble(title = "Guardians of the Galaxy",
                            chapter = base::seq_along(tb_pdftools_mcu24),
                             text = tb_pdftools_mcu24,
                            movie_number = 10,
                            mcu_phase = 2,
                            release_date = "August 1, 2014",
                            director = "James Gunn",
                            screenwriter = "James Gunn & Nicole Perlman",
                            producer = "Kevin Feige")
text_IronMan3 <- tibble::tibble(title = "Iron Man 3",
                                chapter = base::seq_along(tb_pdftools_mcu25),
                                text = tb_pdftools_mcu25,
                                movie_number = 7,
                                mcu_phase = 2,
                                release_date = "May 3, 2013",
                                director = "Shane Black",
                                screenwriter = "Drew Pearce & Shane Black",
                                producer = "Kevin Feige")
text_Thor2 <- tibble::tibble(title = "Thor: The Dark World",
                             chapter = base::seq_along(tb_pdftools_mcu26),
                             text = tb_pdftools_mcu26,
                             movie_number = 8,
                             mcu_phase = 2,
                             release_date = "November 8, 2013",
                             director = "Alan Taylor",
                             screenwriter = "Christopher L. Yost, Christopher Markus, & Stephen McFeely",
                             producer = "Kevin Feige")
#Phase 3 Movies (Ends at Ant-Man & The Wasp)
text_AntMan2 <- tibble::tibble(title = "Ant-Man & The Wasp",
                               chapter = base::seq_along(tb_pdftools_mcu31),
                          text = tb_pdftools_mcu31,
                          movie_number = 20,
                          mcu_phase = 3,
                          release_date = "July 6, 2018",
                          director = "Peyton Reed",
                          screenwriter = "Chris McKenna, Erik Sommers, Paul Rudd, Andrew Barrer, & Gabriel Ferrari",
                          producer = "Kevin Feige & Stephen Broussard")
text_AvengersIW <- tibble::tibble(title = "Avengers: Infinity War",
                                  chapter = base::seq_along(tb_pdftools_mcu32),
                               text = tb_pdftools_mcu32,
                               movie_number = 19,
                               mcu_phase = 3,
                               release_date = "April 27, 2018",
                               director = "Anthony & Joe Russo",
                               screenwriter = "Christopher Markus & Stephen McFeely",
                               producer = "Kevin Feige")
text_BkPanther <- tibble::tibble(title = "Black Panther",
                                 chapter = base::seq_along(tb_pdftools_mcu33),
                               text = tb_pdftools_mcu33,
                               movie_number = 18,
                               mcu_phase = 3,
                               release_date = "February 16, 2018",
                               director = "Ryan Coogler",
                               screenwriter = "Ryan Coogler & Joe Robert Cole",
                               producer = "Kevin Feige")
text_CaptAmerica3 <- tibble::tibble(title = "Captain America: Civil War",
                                    chapter = base::seq_along(tb_pdftools_mcu34),
                               text = tb_pdftools_mcu34,
                               movie_number = 13,
                               mcu_phase = 3,
                               release_date = "May 6, 2016",
                               director = "Anthony & Joe Russo",
                               screenwriter = "Christopher Markus & Stephen McFeely",
                               producer = "Kevin Feige")
text_DrStrange <- tibble::tibble(title = "Doctor Strange",
                                 chapter = base::seq_along(tb_pdftools_mcu35),
                               text = tb_pdftools_mcu35,
                               movie_number = 14,
                               mcu_phase = 3,
                               release_date = "November 4, 2016",
                               director = "Scott Derrickson",
                               screenwriter = "Jon Spaihts, Scott Derrickson, & C. Robert Cargill",
                               producer = "Kevin Feige")
text_GotG2 <- tibble::tibble(title = "Guardians of the Galaxy Volume 2",
                             chapter = base::seq_along(tb_pdftools_mcu36),
                               text = tb_pdftools_mcu36,
                             movie_number = 15,
                             mcu_phase = 3,
                             release_date = "May 5, 2017",
                             director = "James Gunn",
                             screenwriter = "James Gunn",
                             producer = "Kevin Feige")
text_SpiderManHC <- tibble::tibble(title = "Spider-Man: Homecoming",
                                   chapter = base::seq_along(tb_pdftools_mcu37),
                               text = tb_pdftools_mcu37,
                               movie_number = 16,
                               mcu_phase = 3,
                               release_date = "July 7, 2017",
                               director = "Jon Watts",
                               screenwriter = "Jonathan Goldstein, John Francis Daley, Jon Watts, Christopher Ford, Chris McKenna, & Erik Sommers",
                               producer = "Kevin Feige & Amy Pascal")
text_Thor3 <- tibble::tibble(title = "Thor: Ragnarok",
                             chapter = base::seq_along(tb_pdftools_mcu38),
                               text = tb_pdftools_mcu38,
                             movie_number = 17,
                             mcu_phase = 3,
                             release_date = "November 3, 2017",
                             director = "Taika Waititi",
                             screenwriter = "Eric Pearson, Craig Kyle, & Christopher L. Yost",
                             producer = "Kevin Feige")

#Tests
mcu_phase3[1]
tb_pdftools_mcu3 <- pdftools::pdf_text(pdf = mcu_phase3[1])
tb_pdftools_mcu2 <- pdftools::pdf_text(pdf = mcu_phase2[1])
tb_pdftools_mcu1 <- pdftools::pdf_text(pdf = mcu_phase1[1])

#Unnesting the Tokens & Getting Top 10 Words
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
text_Avengers %>%
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
  labs(title = "Top 10 Words in Ant-Man") +
  xlab("Words") +
  ylab("Count")
pam
#Ant-Man & the Wasp
am2 = text_AntMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pam2 <- ggplot(data=am2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Ant-Man & the Wasp") +
  xlab("Words") +
  ylab("Count")
pam2
#Captain America: The First Avenger
ca = text_CaptAmerica %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca <- ggplot(data=ca, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Captain America: The First Avenger") +
  xlab("Words") +
  ylab("Count")
pca
#Captain America: The Winter Soldier
ca2 = text_CaptAmerica2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca2 <- ggplot(data=ca2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Captain America: The Winter Soldier") +
  xlab("Words") +
  ylab("Count")
pca2
#Captain America: Civil War
ca3 = text_CaptAmerica3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca3 <- ggplot(data=ca3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Captain America: Civil War") +
  xlab("Words") +
  ylab("Count")
pca3
#Iron Man
im = text_IronMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim <- ggplot(data=im, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Iron Man") +
  xlab("Words") +
  ylab("Count")
pim
#Iron Man 2
im2 = text_IronMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim2 <- ggplot(data=im2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Iron Man 2") +
  xlab("Words") +
  ylab("Count")
pim2
#Iron Man 3
im3 = text_IronMan3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim3 <- ggplot(data=im3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Iron Man 3") +
  xlab("Words") +
  ylab("Count")
pim3
#Guardians of the Galaxy
gotg = text_GotG %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg <- ggplot(data=gotg, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Guardians of the Galaxy") +
  xlab("Words") +
  ylab("Count")
pgotg
#Guardians of the Galaxy Volume 2
gotg2 = text_GotG2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg2 <- ggplot(data=gotg2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Guardians of the Galaxy Vol. 2") +
  xlab("Words") +
  ylab("Count")
pgotg2
#Thor
t = text_Thor %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt <- ggplot(data=t, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Thor") +
  xlab("Words") +
  ylab("Count")
pt
#Thor: The Dark World
t2 = text_Thor2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt2 <- ggplot(data=t2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Thor: The Dark World") +
  xlab("Words") +
  ylab("Count")
pt2
#Thor: Ragnarok
t3 = text_Thor3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt3 <- ggplot(data=t3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Thor: Ragnarok") +
  xlab("Words") +
  ylab("Count")
pt3
#Spider-Man: Homecoming
sm = text_SpiderManHC %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
psm <- ggplot(data=sm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="red") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Spider-Man: Homecoming") +
  xlab("Words") +
  ylab("Count")
psm
#The Incredible Hulk
h = text_Hulk %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
ph <- ggplot(data=h, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkgreen") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in The Incredible Hulk") +
  xlab("Words") +
  ylab("Count")
ph
#Avengers
av = text_Avengers %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav <- ggplot(data=av, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Avengers") +
  xlab("Words") +
  ylab("Count")
pav
#Avengers: Age of Ultron
av2 = text_AvengersAOU %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav2 <- ggplot(data=av2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Avengers: Age of Ultron") +
  xlab("Words") +
  ylab("Count")
pav2
#Avengers: Infinity War
av3 = text_AvengersIW %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav3 <- ggplot(data=av3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Avengers: Infinity War") +
  xlab("Words") +
  ylab("Count")
pav3
#Black Panther
bp = text_BkPanther %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pbp <- ggplot(data=bp, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="black") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Black Panther") +
  xlab("Words") +
  ylab("Count")
pbp
#Doctor Strange
ds = text_DrStrange %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pds <- ggplot(data=ds, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkorange") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in Doctor Strange") +
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
                     text_Thor,
                     text_Avengers)
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
text_AV_Tril <- rbind(text_Avengers, text_AvengersAOU, text_AvengersIW)
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
  labs(title = "Top 10 Words in Phase 1 of the MCU") +
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
  labs(title = "Top 10 Words in Phase 2 of the MCU") +
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
  labs(title = "Top 10 Words in Phase 3 of the MCU") +
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
  labs(title = "Top 10 Words in the Entire MCU") +
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
  labs(title = "Top 10 Words in the Iron Man Trilogy") +
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
  labs(title = "Top 10 Words in the Thor Trilogy") +
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
  labs(title = "Top 10 Words in the Ant-Man Movies") +
  xlab("Words") +
  ylab("Count")
pacm
#The Avengers Movies
avcm = text_AV_Tril %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pavcm<-ggplot(data=avcm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal() +
  labs(title = "Top 10 Words in the Avengers Movies") +
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
  labs(title = "Top 10 Words in the Guardians of the Galaxy Movies") +
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

mcu_data <- as.data.frame(text_mcu[1:9], stringsAsFactors = FALSE)
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

#Sentiment Analysis
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
               saotd)
nrc_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")
nrc_anger <- get_sentiments("nrc") %>%
  filter(sentiment == "anger")

mcu_unnested <- tidytext::unnest_tokens(text_mcu, word, text)

#Top 10 Positive Sentiment Words
mcu_unnested %>%
  anti_join(tibble::tibble(word = c("rocket")))%>%
  inner_join(nrc_joy) %>%
  count(word, sort = T)

#Top 10 Negative Sentiment Words
mcu_unnested %>%
  anti_join(tibble::tibble(word = c("rocket", "fury")))%>%
  inner_join(nrc_anger) %>%
  count(word, sort = T)

wordcounts <- mcu_unnested %>%
  group_by(title) %>%
  summarize(words = n())

binnegative <- get_sentiments("bing") %>%
  filter(sentiment == "negative")
binpositive <- get_sentiments("bing") %>%
  filter(sentiment == "positive")

mcu_unnested %>%
  inner_join(get_sentiments("bing")) %>%
  count(index = title, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive/negative) %>%
  top_n(10) %>%
  arrange(desc(sentiment)) %>%
  ungroup()

#Top 10 Most Positive Movies in the MCU
mcu_unnested %>%
  inner_join(get_sentiments("bing")) %>%
  count(index = title, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = (positive/(positive + negative))) %>%
  top_n(10) %>%
  arrange(desc(sentiment)) %>%
  ungroup()

#Top 10 Most Negative Movies in the MCU
mcu_unnested %>%
  inner_join(get_sentiments("bing")) %>%
  count(index = title, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = (negative/(positive + negative))) %>%
  top_n(10) %>%
  arrange(desc(sentiment)) %>%
  ungroup()

#Word Cloud - Most Used Words
mcu_unnested %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 50))

#Word Cloud w/ Sentiment
mcu_unnested %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("gray20","gray80"),
                   max.words = 50)

#Document Summarization
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
               textmineR,
               LSAfun,
               igraph,
               textrank,
               ggraph,
               lattice,
               udpipe)
#This uses tidy text to create tokens of sentences and of words from the document. 
#This is necessary to analyze the similarity between sentences, get rid of stop words and to rank the sentences.
#The Entire MCU Summarized
mcu_sentences <- tibble(text = text_mcu$text[1:1346]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

mcu_words <- mcu_sentences %>%
  unnest_tokens(word, sentence)

mcu_words <- mcu_words %>%
  anti_join(stop_words, by = "word")

mcu_summary <- textrank_sentences(data = mcu_sentences, 
                                      terminology = mcu_words)

#This shows us the top 10 sentences that summarize the document
mcu_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:10) %>%
  pull(sentence)

#The Captain America Trilogy
cat_sentences <- tibble(text = text_CA_Tril$text[1:94]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

cat_words <- cat_sentences %>%
  unnest_tokens(word, sentence)

cat_words <- cat_words %>%
  anti_join(stop_words, by = "word")

cat_summary <- textrank_sentences(data = cat_sentences, 
                                  terminology = cat_words)

#This shows us the top 5 sentences that summarize the document
cat_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#The Iron Man Trilogy
imt_sentences <- tibble(text = text_IM_Tril$text[1:284]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

imt_words <- imt_sentences %>%
  unnest_tokens(word, sentence)

imt_words <- imt_words %>%
  anti_join(stop_words, by = "word")

imt_summary <- textrank_sentences(data = imt_sentences, 
                                  terminology = imt_words)

#This shows us the top 5 sentences that summarize the document
imt_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#The Thor Trilogy
tht_sentences <- tibble(text = text_Thor_Tril$text[1:302]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

tht_words <- tht_sentences %>%
  unnest_tokens(word, sentence)

tht_words <- tht_words %>%
  anti_join(stop_words, by = "word")

tht_summary <- textrank_sentences(data = tht_sentences, 
                                  terminology = tht_words)

#This shows us the top 5 sentences that summarize the document
tht_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#The Avengers Trilogy
avt_sentences <- tibble(text = text_AV_Tril$text[1:142]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

avt_words <- avt_sentences %>%
  unnest_tokens(word, sentence)

avt_words <- avt_words %>%
  anti_join(stop_words, by = "word")

avt_summary <- textrank_sentences(data = avt_sentences, 
                                  terminology = avt_words)

#This shows us the top 5 sentences that summarize the document
avt_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#The Guardians of the Galaxy Movies
gotgm_sentences <- tibble(text = text_GotG_Comb$text[1:169]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

gotgm_words <- gotgm_sentences %>%
  unnest_tokens(word, sentence)

gotgm_words <- gotgm_words %>%
  anti_join(stop_words, by = "word")

gotgm_summary <- textrank_sentences(data = gotgm_sentences, 
                                  terminology = gotgm_words)

#This shows us the top 5 sentences that summarize the document
gotgm_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#The Ant-Man Movies
amm_sentences <- tibble(text = text_AM_Comb$text[1:82]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

amm_words <- amm_sentences %>%
  unnest_tokens(word, sentence)

amm_words <- amm_words %>%
  anti_join(stop_words, by = "word")

amm_summary <- textrank_sentences(data = amm_sentences, 
                                    terminology = amm_words)

#This shows us the top 5 sentences that summarize the document
amm_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:5) %>%
  pull(sentence)

#Phase 1 of the MCU
mcup1_sentences <- tibble(text = text_mcu_p1$text[1:570]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

mcup1_words <- mcup1_sentences %>%
  unnest_tokens(word, sentence)

mcup1_words <- mcup1_words %>%
  anti_join(stop_words, by = "word")

mcup1_summary <- textrank_sentences(data = mcup1_sentences, 
                                    terminology = mcup1_words)

#This shows us the top 10 sentences that summarize the document
mcup1_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:10) %>%
  pull(sentence)

#Phase 2 of the MCU
mcup2_sentences <- tibble(text = text_mcu_p2$text[1:248]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

mcup2_words <- mcup2_sentences %>%
  unnest_tokens(word, sentence)

mcup2_words <- mcup2_words %>%
  anti_join(stop_words, by = "word")

mcup2_summary <- textrank_sentences(data = mcup2_sentences, 
                                    terminology = mcup2_words)

#This shows us the top 10 sentences that summarize the document
mcup2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:10) %>%
  pull(sentence)

#Phase 3 of the MCU
mcup3_sentences <- tibble(text = text_mcu_p3$text[1:528]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

mcup3_words <- mcup3_sentences %>%
  unnest_tokens(word, sentence)

mcup3_words <- mcup3_words %>%
  anti_join(stop_words, by = "word")

mcup3_summary <- textrank_sentences(data = mcup3_sentences, 
                                    terminology = mcup3_words)

#This shows us the top 10 sentences that summarize the document
mcup3_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:10) %>%
  pull(sentence)

#Iron Man
im_sentences <- tibble(text = text_IronMan$text[1:180]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

im_words <- im_sentences %>%
  unnest_tokens(word, sentence)

im_words <- im_words %>%
  anti_join(stop_words, by = "word")

im_summary <- textrank_sentences(data = im_sentences, 
                                    terminology = im_words)

#This shows us the top 3 sentences that summarize the document
im_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Iron Man
im2_sentences <- tibble(text = text_IronMan2$text[1:29]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

im2_words <- im2_sentences %>%
  unnest_tokens(word, sentence)

im2_words <- im2_words %>%
  anti_join(stop_words, by = "word")

im2_summary <- textrank_sentences(data = im2_sentences, 
                                 terminology = im2_words)

#This shows us the top 3 sentences that summarize the document
im2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Iron Man 3
im3_sentences <- tibble(text = text_IronMan3$text[1:75]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

im3_words <- im3_sentences %>%
  unnest_tokens(word, sentence)

im3_words <- im3_words %>%
  anti_join(stop_words, by = "word")

im3_summary <- textrank_sentences(data = im3_sentences, 
                                 terminology = im3_words)

#This shows us the top 3 sentences that summarize the document
im3_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Captain America: The First Avenger
ca_sentences <- tibble(text = text_CaptAmerica$text[1:24]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

ca_words <- ca_sentences %>%
  unnest_tokens(word, sentence)

ca_words <- ca_words %>%
  anti_join(stop_words, by = "word")

ca_summary <- textrank_sentences(data = ca_sentences, 
                                 terminology = ca_words)

#This shows us the top 3 sentences that summarize the document
ca_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Captain America: The Winter Soldier
ca2_sentences <- tibble(text = text_CaptAmerica2$text[1:31]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

ca2_words <- ca2_sentences %>%
  unnest_tokens(word, sentence)

ca2_words <- ca2_words %>%
  anti_join(stop_words, by = "word")

ca2_summary <- textrank_sentences(data = ca2_sentences, 
                                 terminology = ca2_words)

#This shows us the top 3 sentences that summarize the document
ca2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Captain America: Civil War
ca3_sentences <- tibble(text = text_CaptAmerica3$text[1:39]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

ca3_words <- ca3_sentences %>%
  unnest_tokens(word, sentence)

ca3_words <- ca3_words %>%
  anti_join(stop_words, by = "word")

ca3_summary <- textrank_sentences(data = ca3_sentences, 
                                 terminology = ca3_words)

#This shows us the top 3 sentences that summarize the document
ca3_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Thor
th_sentences <- tibble(text = text_Thor$text[1:147]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

th_words <- th_sentences %>%
  unnest_tokens(word, sentence)

th_words <- th_words %>%
  anti_join(stop_words, by = "word")

th_summary <- textrank_sentences(data = th_sentences, 
                                 terminology = th_words)

#This shows us the top 3 sentences that summarize the document
th_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Thor: The Dark World
th2_sentences <- tibble(text = text_Thor2$text[1:43]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

th2_words <- th2_sentences %>%
  unnest_tokens(word, sentence)

th2_words <- th2_words %>%
  anti_join(stop_words, by = "word")

th2_summary <- textrank_sentences(data = th2_sentences, 
                                 terminology = th2_words)

#This shows us the top 3 sentences that summarize the document
th2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Thor: Ragnarok
th3_sentences <- tibble(text = text_Thor3$text[1:112]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

th3_words <- th3_sentences %>%
  unnest_tokens(word, sentence)

th3_words <- th3_words %>%
  anti_join(stop_words, by = "word")

th3_summary <- textrank_sentences(data = th3_sentences, 
                                 terminology = th3_words)

#This shows us the top 3 sentences that summarize the document
th3_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Ant-Man
am_sentences <- tibble(text = text_AntMan$text[1:29]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

am_words <- am_sentences %>%
  unnest_tokens(word, sentence)

am_words <- am_words %>%
  anti_join(stop_words, by = "word")

am_summary <- textrank_sentences(data = am_sentences, 
                                 terminology = am_words)

#This shows us the top 3 sentences that summarize the document
am_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Ant-Man & The Wasp
am2_sentences <- tibble(text = text_AntMan2$text[1:53]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

am2_words <- am2_sentences %>%
  unnest_tokens(word, sentence)

am2_words <- am2_words %>%
  anti_join(stop_words, by = "word")

am2_summary <- textrank_sentences(data = am2_sentences, 
                                 terminology = am2_words)

#This shows us the top 3 sentences that summarize the document
am2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Avengers
av_sentences <- tibble(text = text_Avengers$text[1:73]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

av_words <- av_sentences %>%
  unnest_tokens(word, sentence)

av_words <- av_words %>%
  anti_join(stop_words, by = "word")

av_summary <- textrank_sentences(data = av_sentences, 
                                 terminology = av_words)

#This shows us the top 3 sentences that summarize the document
av_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Avengers: Age of Ultron
av2_sentences <- tibble(text = text_AvengersAOU$text[1:29]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

av2_words <- av2_sentences %>%
  unnest_tokens(word, sentence)

av2_words <- av2_words %>%
  anti_join(stop_words, by = "word")

av2_summary <- textrank_sentences(data = av2_sentences, 
                                 terminology = av2_words)

#This shows us the top 3 sentences that summarize the document
av2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Avengers: Infinity War
av3_sentences <- tibble(text = text_AvengersIW$text[1:40]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

av3_words <- av3_sentences %>%
  unnest_tokens(word, sentence)

av3_words <- av3_words %>%
  anti_join(stop_words, by = "word")

av3_summary <- textrank_sentences(data = av3_sentences, 
                                 terminology = av3_words)

#This shows us the top 3 sentences that summarize the document
av3_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Doctor Strange
ds_sentences <- tibble(text = text_DrStrange$text[1:35]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

ds_words <- ds_sentences %>%
  unnest_tokens(word, sentence)

ds_words <- ds_words %>%
  anti_join(stop_words, by = "word")

ds_summary <- textrank_sentences(data = ds_sentences, 
                                 terminology = ds_words)

#This shows us the top 3 sentences that summarize the document
ds_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Guardians of the Galaxy
gotg_sentences <- tibble(text_GotG$text[1:41]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

gotg_words <- gotg_sentences %>%
  unnest_tokens(word, sentence)

gotg_words <- gotg_words %>%
  anti_join(stop_words, by = "word")

gotg_summary <- textrank_sentences(data = gotg_sentences, 
                                 terminology = gotg_words)

#This shows us the top 3 sentences that summarize the document
gotg_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Guardians of the Galaxy Volume 2
gotg2_sentences <- tibble(text_GotG2$text[1:128]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

gotg2_words <- gotg2_sentences %>%
  unnest_tokens(word, sentence)

gotg2_words <- gotg2_words %>%
  anti_join(stop_words, by = "word")

gotg2_summary <- textrank_sentences(data = gotg2_sentences, 
                                   terminology = gotg2_words)

#This shows us the top 3 sentences that summarize the document
gotg2_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#The Incredible Hulk
ih_sentences <- tibble(text_Hulk$text[1:117]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

ih_words <- ih_sentences %>%
  unnest_tokens(word, sentence)

ih_words <- ih_words %>%
  anti_join(stop_words, by = "word")

ih_summary <- textrank_sentences(data = ih_sentences, 
                                   terminology = ih_words)

#This shows us the top 3 sentences that summarize the document
ih_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)

#Spider-Man: Homecoming
sm_sentences <- tibble(text_SpiderManHC$text[1:59]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

sm_words <- sm_sentences %>%
  unnest_tokens(word, sentence)

sm_words <- sm_words %>%
  anti_join(stop_words, by = "word")

sm_summary <- textrank_sentences(data = sm_sentences, 
                                   terminology = sm_words)

#This shows us the top 3 sentences that summarize the document
sm_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)
