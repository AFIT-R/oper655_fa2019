library(pacman)
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
               widyr,
               XML)

pacman::p_load_gh("dgrtwo/drlib",
                  "trinker/termco", 
                  "trinker/coreNLPsetup",        
                  "trinker/tagger")

cat("\014") #Clear console
rm(list = ls()) #clear variables

url  <- 'https://www.springfieldspringfield.co.uk/movie_script.php?movie=elf'
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

text1 =  XML::xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
text1 = gsub('\\\n', "", text1)
text1 = gsub('\\  ', "", text1)

text_tb <- tibble::tibble(text = text1)
doc_text_3 = text_tb %>% tidytext::unnest_tokens(word, text, token = 'words')

rm(url,rcurl.doc,url_parsed,text_tb)

sort_text = doc_text_3 %>% dplyr::count(word, sort = TRUE)

sort_text = doc_text_3 %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)

sort_text
