```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, 
                      comment = NA, 
                      message = FALSE,
                      warning = FALSE)
```
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
  
  clean <- tibble::tibble(score = text_en$score,
                          maxscore = text_en$score_max,
                          text = text_en$extract,
                          product = gsub(prod_pattern, "", text_en$phone_url),
                          author = text_en$author,
                          manufacturer = gsub("/cellphones/","",str_extract(text_en$phone_url,manu_pattern)))
 #   tidytext::unnest_tokens(word, text)
  reviews_tidy <- base::rbind(reviews_tidy, clean)
  rm(text_en, clean)
}

table(reviews_tidy$maxscore)
reviews_tidy <- select(reviews_tidy, -maxscore)
rm(file_list, root, manu_pattern, prod_pattern, file_loc)

pacman::p_load_gh("trinker/entity")
library(monkeylearn)
library(magrittr)
ner_test <- monkeylearn::monkey_extract(reviews_tidy$text, extractor_id = "ex_isnnZRbS")