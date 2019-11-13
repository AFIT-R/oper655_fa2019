#####Import Text from chosen Document######

#Function purpose: import and read text of any document type (.doc, .pdf, .img, .jpg, etc)
library(tools)
library(pacman)
library(readr)
library(vroom)
library(qdapTools)
pacman::p_load(XML,
               rvest,
               RCurl,
               rprojroot,
               qdapTools,
               pdftools,
               antiword,
               glue,
               data.table,
               tidyverse,
               vroom,
               antiword,
               magick,
               tesseract)
p_load(here)


url  <- 'http://scrapsfromtheloft.com/2017/09/25/john-mulaney-new-in-town-2012-full-transcript/'
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)
newintown=XML::xpathSApply(url_parsed, "//div[@class='post-content']", XML::xmlValue)

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

#Splits string into one word per row
text_tb <- tibble::tibble(chapter = base::seq_along(newintown),
                          text = newintown)
text_split=text_tb %>% tidytext::unnest_tokens(word, text, token = 'words')

#Outputs most common words by count (no filter)
text_split %>% dplyr::count(word, sort = TRUE)

#Outputs most used words by count (filter out common words like "the")
text_split %>%
  dplyr::anti_join(stop_words[stop_words$lexicon=="SMART",]) %>%
  dplyr::count(word, sort = TRUE)
  #Uses filter SMART. Info still not helpful

##### top 10 most common words in each book
# hp_tidy %>%
#   anti_join(stop_words) %>%
#   group_by(book) %>%
#   count(word, sort = TRUE) %>%
#   top_n(10) %>%
#   ungroup() %>%
#   mutate(book = base::factor(book, levels = titles),
#          text_order = base::nrow(.):1) %>%
#   ## Pipe output directly to ggplot
#   ggplot(aes(reorder(word, text_order), n, fill = book)) +
#   geom_bar(stat = "identity") +
#   facet_wrap(~ book, scales = "free_y") +
#   labs(x = "NULL", y = "Frequency") +
#   coord_flip() +
#   theme(legend.position="none")

