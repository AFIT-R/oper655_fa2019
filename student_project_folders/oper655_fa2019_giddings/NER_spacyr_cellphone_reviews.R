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
library(spacyr)
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

root <- rprojroot::find_root(rprojroot::is_rstudio_project)
file_loc <- file.path(root,"data","phone_user_reviews")

file_list <- list.files(path = file_loc,
                        pattern = "",
                        full.names = TRUE)
reviews_tidy <- tibble::tibble()
manu_pattern <- "/cellphones/[a-z0-9]+"
prod_pattern <- paste(manu_pattern, "-|/", sep = "")
for (i in file_list){
  input <- load(i,ex <- new.env())
  text_raw <- get(ls(ex),ex)
  text_en <- text_raw[text_raw$lang=="en",]
  rm(ex, text_raw, input, i)
  clean <- tibble::tibble()
  clean <- tibble::tibble(score = text_en$score,
                          maxscore = text_en$score_max,
                          text = text_en$extract,
                          product = gsub(prod_pattern, "", text_en$phone_url),
                          author = text_en$author,
                          manufacturer = gsub("/cellphones/","",str_extract(text_en$phone_url,manu_pattern)))# %>%
    #   tidytext::unnest_tokens(word, text)
    reviews_tidy <- base::rbind(reviews_tidy, clean)
  rm(text_en)
}
pur_data <- read.csv(file="D:/AFIT/Quarter 5/OPER 655 - Text Mining/phone_user_review_file.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)
parsed_pd <- spacy_parse(reviews_tidy$text, tag = TRUE, entity = TRUE, lemma = FALSE)
entity_extract(parsed_pd, type = "all")
