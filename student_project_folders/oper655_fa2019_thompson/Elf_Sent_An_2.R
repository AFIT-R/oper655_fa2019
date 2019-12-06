cat("\014") #Clear console
rm(list = ls()) #clear variables
library(pacman)
pacman::p_load( broom,
                coreNLP,
                dplyr,
                DT,
                ggplot2,
                ggraph,
                grid,
                here,
                igraph,
                knitr,
                lattice,
                LSAfun,
                magrittr,
                monkeylearn,
                NLP,
                openNLP,
                pdftools, 
                qdap,
                qdapDictionaries,
                qdapRegex,
                qdapTools,
                quanteda,
                RColorBrewer,
                reshape2,
                rJava,
                RWeka,
                scales,
                SnowballC,
                spacyr,
                stringr,
                tau,
                text2vec,
                textdata,
                textmineR,
                textrank,
                tidyr,
                tidytext,
                tidytext, 
                tidyverse,
                tm, 
                tokenizers,
                udpipe,
                widyr,
                wordcloud,
                XML
)

url  <- 'https://www.springfieldspringfield.co.uk/movie_script.php?movie=elf'
rcurl.doc <- RCurl::getURL(url,.opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

#Create Text1
  text1 =  XML::xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
  text1 = gsub('\\\n', "", text1)
  text1 = gsub('\\  ', "", text1)
  text1 = gsub("Mmm","Mm", text1)
  text1 = gsub("Susan wells","Susan", text1)
  text1 = gsub("Walter Hobbs","Walter", text1)
  text1 = gsub("papa","Papa", text1)
  text1 = gsub("Papa Elf","Papa", text1)
  text1 = gsub("new York City","New York", text1)
  text1 = gsub("mike","Michael", text1)
  text1 = gsub("Ho ho ho ho ho","Ho ho ho", text1)
  text1 = gsub("ho ho ho","Ho ho ho", text1)
  text1 = gsub("greenway","Greenway", text1)
  text1 = gsub("charlotte","Charlotte", text1)
  text1 = gsub("chuck","Chuck", text1)
  text1 = gsub("elf","Elf", text1)
  text1 = gsub("a, san","a, Santa", text1)
  text1 = gsub("Lincoln tunnel","Lincoln Tunnel", text1)
  text1 = gsub("Aspires","aspires", text1)
  text1 = gsub("Wandering","wandering", text1)
  text1 = gsub("Spread","spread", text1)
  text1 = gsub("Aah","ah", text1)
  text1 <- gsub("Santa clausis","Santa Claus",text1)
  text1 <- gsub("Santa Clausis","Santa Claus",text1)
  text1 <- gsub("Santa claus","Santa",text1)
  text1 <- gsub("Santa Claus","Santa",text1)

raw_tb <- tibble::tibble(text = text1)
word_vect = raw_tb %>% tidytext::unnest_tokens(word, text, token = 'words')

rm(url,rcurl.doc,url_parsed)

text=as_tibble(word_vect)
head(text)




nrc_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")
nrc_anger <- get_sentiments("nrc") %>%
  filter(sentiment == "anger")

text %>%
  inner_join(nrc_joy) %>%
  count(word, sort = T)

text %>%
  inner_join(nrc_anger) %>%
  count(word, sort = T)

dev.off()
text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red","blue"),
                   max.words = 30)

dev.off()
text %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

text = word_vect %>%
  dplyr::anti_join(stop_words)


dev.off()
text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red","blue"),
                   max.words = 50)


