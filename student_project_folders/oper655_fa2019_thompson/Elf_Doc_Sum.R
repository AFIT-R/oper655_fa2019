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

rm(raw_tb,sentences_1,sort_text,sort_text_no_sw,text2,word_vect,text1)

article_sentences <- tibble(text = text[1:1000]) %>%
  unnest_tokens(sentence, text, token = "sentences") %>%
  mutate(sentence_id = row_number()) %>%
  select(sentence_id, sentence)

article_words <- article_sentences %>%
  unnest_tokens(word, sentence)

article_words <- article_words %>%
  anti_join(stop_words, by = "word")

article_summary <- textrank_sentences(data = article_sentences, 
                                      terminology = article_words)
                  #this part takes awhile


#This shows us the top three sentences that summarize the document
article_summary[["sentences"]] %>%
  arrange(desc(textrank)) %>% 
  slice(1:3) %>%
  pull(sentence)



#g_sum = genericSummary(text[1:500],1)




#This shows where, within the document, you see the most important text.
article_summary[["sentences"]] %>%
  ggplot(aes(textrank_id, textrank, fill = textrank_id)) +
  geom_col() +
  theme_minimal() +
  scale_fill_viridis_c() +
  guides(fill = "none") +
  labs(x = "Sentence",
       y = "TextRank score",
       title = "Location within the data where most informative text occurs",
       subtitle = 'Galaxy S5',
       caption = "Source: Oper 655 - Text Mining")



library(udpipe)
library(textrank)
## First step: Take the English udpipe model and annotate the text.
#ud_model <- udpipe_download_model(language = "english")
#ud_model <- udpipe_load_model(ud_model$file_model)
x <- udpipe_annotate(ud_model, x = text)
x <- as.data.frame(x)
#head(x)

#Lemma is just the column of all of the words in the document
#Here we simply show the frequency of the words.
stats <- subset(x, upos %in% "NOUN")
stats <- txt_freq(x = stats$lemma)
library(lattice)
stats$key <- factor(stats$key, levels = rev(stats$key))
barchart(key ~ freq, data = head(stats, 30), col = "orange", main = "Most occurring nouns", xlab = "Freq")

stats <- keywords_collocation(x = x, 
                              term = "token", group = c("doc_id", "paragraph_id", "sentence_id"),
                              ngram_max = 4)
## Co-occurrences: How frequent do words occur in the same sentence, in this case only nouns or adjectives
stats <- cooccurrence(x = subset(x, upos %in% c("NOUN", "ADJ")), 
                      term = "lemma", group = c("doc_id", "paragraph_id", "sentence_id"))
## Co-occurrences: How frequent do words follow one another
stats <- cooccurrence(x = x$lemma, 
                      relevant = x$upos %in% c("NOUN", "ADJ"))
## Co-occurrences: How frequent do words follow one another even if we would skip 2 words in between
stats <- cooccurrence(x = x$lemma, 
                      relevant = x$upos %in% c("NOUN", "ADJ"), skipgram = 2)
head(stats)

#From here we build out a word network showing how closely related and used together multi word phrases are in the document. 
wordnetwork <- head(stats, 30)
wordnetwork <- graph_from_data_frame(wordnetwork)
ggraph(wordnetwork, layout = "fr") +
  geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "pink") +
  geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
  theme_graph(base_family = "Arial Narrow") +
  theme(legend.position = "none") +
  labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")

stats <- textrank_keywords(x$lemma, 
                           relevant = x$upos %in% c("NOUN", "ADJ"), 
                           ngram_max = 8, sep = " ")
stats <- subset(stats$keywords, ngram > 1 & freq >= 3)
library(wordcloud)
wordcloud(words = stats$keyword, freq = stats$freq, max.words = 300)

stats <- keywords_rake(x = x, 
                       term = "token", group = c("doc_id", "paragraph_id", "sentence_id"),
                       relevant = x$upos %in% c("NOUN", "ADJ"),
                       ngram_max = 4)
head(subset(stats, freq > 3))

## Simple noun phrases (a adjective+noun, pre/postposition, optional determiner and another adjective+noun)
x$phrase_tag <- as_phrasemachine(x$upos, type = "upos")
stats <- keywords_phrases(x = x$phrase_tag, term = x$token, 
                          pattern = "(A|N)+N(P+D*(A|N)*N)*", 
                          is_regex = TRUE, ngram_max = 4, detailed = FALSE)
head(subset(stats, ngram > 2))

#Lastly, we identify the most common phrases in the dataset to get a feel for the overall docuement.
stats <- merge(x, x, 
               by.x = c("doc_id", "paragraph_id", "sentence_id", "head_token_id"),
               by.y = c("doc_id", "paragraph_id", "sentence_id", "token_id"),
               all.x = TRUE, all.y = FALSE, 
               suffixes = c("", "_parent"), sort = FALSE)
stats <- subset(stats, dep_rel %in% "nsubj" & upos %in% c("NOUN") & upos_parent %in% c("ADJ"))
stats$term <- paste(stats$lemma_parent, stats$lemma, sep = " ")
stats <- txt_freq(stats$term)
library(wordcloud)
wordcloud(words = stats$key, freq = stats$freq, min.freq = 3, max.words = 100,
          random.order = FALSE, colors = brewer.pal(6, "Dark2"), scale = c(1.1,5))

