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
               LSAfun,
               openNLP)



library(reticulate)

source_python("D:/AFIT/oper655_fa2019/lectures/tensorflow/python/flights.py")
flights <- read_flights("D:/AFIT/oper655_fa2019/lectures/tensorflow/data/flights.csv")

library(ggplot2)
g = ggplot(flights, aes(carrier, arr_delay))

g + geom_point() + geom_jitter()


if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

get_summary(paste(fa,collapse=" "), 10)


#load needed packages
library(xml2)
library(rvest)
library(lexRankr)

#url to scrape
monsanto_url = "https://www.imsdb.com/scripts/Star-Wars-The-Force-Awakens.html"

#read page html
page = xml2::read_html(monsanto_url)
#extract text from page html using selector
page_text2 = rvest::html_text(rvest::html_nodes(page, ".scrtext"))


page_text <- stringr::str_replace_all(page_text, "<br */>", "")
page_text <- stringr::str_replace_all(page_text, "\r", "")
page_text <- stringr::str_replace_all(page_text, "\t", "")
page_text <- stringr::str_replace_all(page_text, "\n", "")
page_text <- stringr::str_replace_all(page_text, "\"", "")
page_text <- stringr::str_replace_all(page_text, "_", " ")


get_summary(page_text, 3)
genericSummary(page_text,3, min=10)


install.packages("spacyr")

library("spacyr")
spacy_install()

presentation_parsed <- get_ner(page_text)

presentation_extracted <- entity_extract(presentation_parsed)
head(presentation_extracted)

per <- presentation_extracted %>%
  filter(entity_type == "PERSON") %>%
  distinct(entity)


reviews_tidy <- tibble::tibble()


clean <- tibble::tibble(text = page_text)

#tidytext::unnest_tokens(word, text) 
reviews_tidy <- base::rbind(reviews_tidy, clean)


presentation_parsed <- get_ner(reviews_tidy)

presentation_extracted <- entity_extract(presentation_parsed)
head(presentation_extracted)

per <- presentation_extracted %>%
  filter(entity_type == "PERSON") %>%
  distinct(entity)

per
presentation_extracted %>%
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





text_tb <- tibble::tibble(chapter = base::seq_along(page_text),
                          text = page_text)

# top 10 most common words in each book
text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)

install.packages("openNLP")
library("openNLP")

get_ner2(page_text)





grep(pattern = "LOR SAN TEKKA\r\n", page_text, value = TRUE)

sw <- readLines("sw.txt")




which(stringr::str_detect(sw,"REY")) -> snoke_lines

sw[snoke_lines+1] 

snoke_txt <- sw[snoke_lines+1] 

snoke_tb <- tibble::tibble(text = snoke_txt)

snoke_tb %>%
  unnest_tokens(word, text) %>% 
  inner_join(get_sentiments("bing")) %>%
  count(index = word, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(desc(sentiment)) %>%
  top_n(10)








string2 = "POE: \n This is a test \n I am testing you. \n\n Tester"
stu4 <- gsub("(?<!\n)\n(?!\n)|\n{3,}", "", stu3, perl=TRUE)

stu4 <- gsub("\t", "", stu4, perl=TRUE)


stu3 <- stringr::str_replace_all(stu2, "\r", "")
stu3 <- str_remove_all(stu2, fixed("\t"))
write_lines(stu4, "sw3.txt")

sw2 <- readLines("sw3.txt")
view(sw2)

which(stringr::str_detect(sw2,"Rey")) -> poe_lines

sw2[poe_lines] 

poe_txt <- sw2[poe_lines] 

poe_tb <- tibble::tibble(text = poe_txt)

tibble::tibble(text = poe_txt) %>%
  unnest_tokens(word, text) %>% 
  inner_join(get_sentiments("bing")) %>%
  count(index = word, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(desc(sentiment)) %>%
  top_n(10)
      
get_summary(poe_txt,5)

