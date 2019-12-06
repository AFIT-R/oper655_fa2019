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

# pacman::p_load_gh("dgrtwo/drlib",
#                   "trinker/termco", 
#                   "trinker/coreNLPsetup",        
#                   "trinker/tagger")
#spacy_initialize()

url  <- 'https://www.springfieldspringfield.co.uk/movie_script.php?movie=elf'
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

text1 =  XML::xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
text1 = gsub('\\\n', "", text1)
text1 = gsub('\\  ', "", text1)

raw_tb <- tibble::tibble(text = text1)
word_vect = raw_tb %>% tidytext::unnest_tokens(word, text, token = 'words')

rm(url,rcurl.doc,url_parsed)

sort_text = word_vect %>% dplyr::count(word, sort = TRUE)

sort_text_no_sw = word_vect %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)

#head(text1)
head(word_vect)
#head(sort_text)
head(sort_text_no_sw)

text2=data.frame(text1,stringsAsFactors = FALSE)
names(text2)<-"col1"
str(text2)

sentences_1 <- unnest_tokens(tbl=text2,input=col1,output=text3,token = "sentences")
head(sentences_1)
#g_sum = genericSummary(sentences_1$text3[1:100],1)


#spacy_parse(text1)

text=sentences_1[,1]

#rm(raw_tb,sentences_1,text2,word_vect,text1)

names(word_vect)=c("word","count")
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

text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red","blue"),
                   max.words = 50,
                   scale=c(5,.1))

text %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

text = word_vect %>%
  dplyr::anti_join(stop_words)



text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red","blue"),
                   max.words = 50,
                   scale=c(4.5,.1))


