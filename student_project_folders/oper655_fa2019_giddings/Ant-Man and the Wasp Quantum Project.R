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
<<<<<<< HEAD
=======
install.packages(qdap)
library(qdap)
devtools::install_github("bradleyboehmke/harrypotter")
harrypotter::philosophers_stone[1]
>>>>>>> c1be969ade6a9957ad9607b20d9eda70b65021b0
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
                                    text = tb_pdftools_mcu11)
text_IronMan2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu12),
                                text = tb_pdftools_mcu12)
text_IronMan <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu13),
                                text = tb_pdftools_mcu13)
text_Hulk <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu14),
                                text = tb_pdftools_mcu14)
text_Thor <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu15),
                             text = tb_pdftools_mcu15)
#Phase 2 Movies
text_AntMan <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu21),
                               text = tb_pdftools_mcu21)
text_AvengersAOU <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu22),
                                  text = tb_pdftools_mcu22)
text_CaptAmerica2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu23),
                                    text = tb_pdftools_mcu23)
text_GotG <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu24),
                             text = tb_pdftools_mcu24)
text_IronMan3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu25),
                                   text = tb_pdftools_mcu25)
text_Thor2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu26),
                             text = tb_pdftools_mcu26)
#Phase 3 Movies (Ends at Avengers: Infinity War)
text_AntMan2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu31),
                          text = tb_pdftools_mcu31)
text_AvengersIW <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu32),
                               text = tb_pdftools_mcu32)
text_BkPanther <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu33),
                               text = tb_pdftools_mcu33)
text_CaptAmerica3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu34),
                               text = tb_pdftools_mcu34)
text_DrStrange <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu35),
                               text = tb_pdftools_mcu35)
text_GotG2 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu36),
                               text = tb_pdftools_mcu36)
text_SpiderManHC <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu37),
                               text = tb_pdftools_mcu37)
text_Thor3 <- tibble::tibble(chapter = base::seq_along(tb_pdftools_mcu38),
                               text = tb_pdftools_mcu38)

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
  theme(legend.position="none") + theme_minimal()
pam
#Ant-Man & the Wasp
am2 = text_AntMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pam2<-ggplot(data=am2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pam2
#Captain America: The First Avenger
ca = text_CaptAmerica %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca<-ggplot(data=ca, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pca
#Captain America: The Winter Soldier
ca2 = text_CaptAmerica2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca2<-ggplot(data=ca2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pca2
#Captain America: Civil War
ca3 = text_CaptAmerica3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pca3<-ggplot(data=ca3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pca3
#Iron Man
im = text_IronMan %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim<-ggplot(data=im, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pim
#Iron Man 2
im2 = text_IronMan2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim2<-ggplot(data=im2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pim2
#Iron Man 3
im3 = text_IronMan3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pim3<-ggplot(data=im3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="gold") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pim3
#Guardians of the Galaxy
gotg = text_GotG %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg<-ggplot(data=gotg, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pgotg
#Guardians of the Galaxy Volume 2
gotg2 = text_GotG2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pgotg2<-ggplot(data=gotg2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="purple") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pgotg2
#Thor
t = text_Thor %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt<-ggplot(data=t, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pt
#Thor: The Dark World
t2 = text_Thor2 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt2<-ggplot(data=t2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pt2
#Thor: Ragnarok
t3 = text_Thor3 %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pt3<-ggplot(data=t3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="grey") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pt3
#Spider-Man: Homecoming
sm = text_SpiderManHC %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
psm<-ggplot(data=sm, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="red") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
psm
#The Incredible Hulk
h = text_Hulk %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
ph<-ggplot(data=h, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkgreen") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
ph
#Avengers: Age of Ultron
av2 = text_AvengersAOU %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav2<-ggplot(data=av2, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pav2
#Avengers: Infinity War
av3 = text_AvengersIW %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pav3<-ggplot(data=av3, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="blue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pav3
#Black Panther
bp = text_BkPanther %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pbp<-ggplot(data=bp, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="black") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pbp
#Doctor Strange
ds = text_DrStrange %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)
pds<-ggplot(data=ds, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkorange") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
pds
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

