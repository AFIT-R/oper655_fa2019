pacman::p_load(tidyr,
               tidytext,
               tidyverse,
               textdata,
               dplyr,
               stringr,
               ggplot2,
               magrittr,
               wordcloud,
               reshape2)

pur_data2 <- read.csv(file="D:/AFIT/Quarter 5/OPER 655 - Text Mining/phone_user_review_file_2.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
pur_data4 <- read.csv(file="D:/AFIT/Quarter 5/OPER 655 - Text Mining/phone_user_review_file_4.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
pur_data6 <- read.csv(file="D:/AFIT/Quarter 5/OPER 655 - Text Mining/phone_user_review_file_6.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
parsed_pd2 <- spacy_parse(pur_data2$extract, tag = TRUE, entity = FALSE, lemma = FALSE)
parsed_pd4 <- spacy_parse(pur_data4$extract, tag = TRUE, entity = FALSE, lemma = FALSE)
parsed_pd6 <- spacy_parse(pur_data6$extract, tag = TRUE, entity = FALSE, lemma = FALSE)
