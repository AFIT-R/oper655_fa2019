cat("\014") #Clear console
rm(list = ls()) #clear variables
dev.off()
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

##################################################
##########Loading and CLeaning Data
##################################################

url  <- 'https://www.springfieldspringfield.co.uk/movie_script.php?movie=elf'
rcurl.doc <- RCurl::getURL(url,.opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

#Create Text1
  text1 =  XML::xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
  rm(url,rcurl.doc,url_parsed)
  
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
  text1 = gsub("Claus meter","Clause Meter", text1)
  text1 = gsub("elf","Elf", text1)
  text1 = gsub("Never","never", text1)
  text1 = gsub("a, san","a, Santa", text1)
  text1 = gsub("Lincoln tunnel","Lincoln Tunnel", text1)
  text1 = gsub("Aspires","aspires", text1)
  text1 = gsub("Wandering","wandering", text1)
  text1 = gsub("Spread","spread", text1)
  text1 = gsub("Behind","behind", text1)
  text1 = gsub("Carolyn Reynolds","Carolyn", text1)
  text1 = gsub("Decisin","decision", text1)
  
  text1 <- gsub("Santa clausis","Santa Claus",text1)
  text1 <- gsub("Santa Clausis","Santa Claus",text1)
  text1 <- gsub("Santa claus","Santa",text1)
  text1 <- gsub("Santa Claus","Santa",text1)
  text1 <- gsub("ray's pizzas","Rays Pizzas",text1)
  text1 <- gsub("Nice list","Nice_List",text1)
  text1 <- gsub("ho!","ho",text1)
  text1 <- gsub("Run","run",text1)
  
  
    
##################################################
##########Named Entity Rec
##################################################

text2=data.frame(text1,stringsAsFactors = FALSE)
names(text2)<-"col1"
str(text2)

#spacy_install() #only used once
spacy_initialize(model="en_core_web_sm")

presentation_parsed <- spacy_parse(text2$col1, entity = TRUE)
head(presentation_parsed)

full_extracted <- entity_extract(presentation_parsed)
head(full_extracted)


for (i in 1:nrow(full_extracted)) {
  if (full_extracted$entity[i]== "Santa" || 
      full_extracted$entity[i]== "Leon"  ||
      full_extracted$entity[i]== "Baby"  ||
      full_extracted$entity[i]== "Charlotte"  ||
      full_extracted$entity[i]== "arctic_puffin"  ||
      full_extracted$entity[i]=="Francisco" ||
      full_extracted$entity[i]=="Elf") {
    full_extracted$entity_type[i]="PERSON"
  }
  if (full_extracted$entity[i]== "Mm" ||
      full_extracted$entity[i]== "Ho_ho_ho" ||
      full_extracted$entity[i]== "Yaah" ||
      full_extracted$entity[i]== "syrup" ||
      full_extracted$entity[i]== "yoursElf" ||
      full_extracted$entity[i]== "Merry_Christmas" ){ 
    full_extracted$entity_type[i]="Other"
  }
  if (full_extracted$entity[i]== "the_candy_cane_forest" ||
      full_extracted$entity[i]== "the_Lincoln_Tunnel"){
    full_extracted$entity_type[i]="LOC"
  }  
  if (full_extracted$entity[i]== "Paparazzi"){
    full_extracted$entity_type[i]="ORG"
  } 
}


#Entity Types
full_extracted %>%
  count(entity_type) %>%
  top_n(100) %>%
  ggplot(aes(x = entity_type, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Entity Types") +
  xlab("Entity Type") +
  ylab("Count")


#Organization
full_extracted %>%
  filter(entity_type == "ORG") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(300) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Organization Entities") +
  xlab("Organizatons") +
  ylab("Mentions")

#Persons
full_extracted %>%
  filter(entity_type == "PERSON" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(15) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Persons") +
  xlab("Persons") +
  ylab("Mentions")

#Location
full_extracted %>%
  filter(entity_type == "LOC" | entity_type == "GPE") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(100) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Location/GPE Entities") +
  xlab("Locations") +
  ylab("Mentions")



#All Other Type of Entities
full_extracted %>%
  filter(entity_type != "PERSON" & entity_type != "LOC" & entity_type != "GPE" & entity_type != "ORG" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(100) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  labs(title = "All Other Type of Entities") +
  xlab("Entities") +
  ylab("Mentions")

#Parts of Speech
presentation_parsed %>%
  group_by(pos) %>%
  count(entity) %>%
  ggplot(aes(x = pos, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  labs(title = "Parts of Speech") +
  xlab("Parts of Speech") +
  ylab("Count")

rm(i)

##################################################
##########Sentiment An
##################################################
raw_tb <- tibble::tibble(text = text1)
word_vect = raw_tb %>% tidytext::unnest_tokens(word, text, token = 'words')
text=as_tibble(word_vect)
rm(raw_tb,word_vect)
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
                   max.words = 40)

dev.off()
text %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

text = text %>%
  dplyr::anti_join(stop_words)


dev.off()
text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red","blue"),
                   max.words = 50)



##################################################
##########Doc Sum
##################################################

# text3=data.frame(text1,stringsAsFactors = FALSE)
# names(text3)<-"col1"
# str(text3)

text3=text2
sentences_1 <- unnest_tokens(tbl=text3,input=col1,output=sentences_1,token = "sentences")
text=sentences_1[,1]

rm(sentences_1,text3)

#stopped


article_sentences <- tibble(text = text) %>%
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


#g_sum = genericSummary(sentences_1$text3[1:100],1)
g_sum = genericSummary(text,5)




#This shows where, within the document, you see the most important text.
dev.off()
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



## First step: Take the English udpipe model and annotate the text.
ud_model <- udpipe_download_model(language = "english")
ud_model <- udpipe_load_model(ud_model$file_model)
x <- udpipe_annotate(ud_model, x = text)
x <- as.data.frame(x)
#head(x)

#Lemma is just the column of all of the words in the document
#Here we simply show the frequency of the words.
stats <- subset(x, upos %in% "NOUN")
stats <- txt_freq(x = stats$lemma)
stats$key <- factor(stats$key, levels = rev(stats$key))
dev.off()
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
dev.off()
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
dev.off()
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
dev.off()
wordcloud(words = stats$key, freq = stats$freq, min.freq = 3, max.words = 100,
          random.order = FALSE, colors = brewer.pal(6, "Dark2"), scale = c(1.1,5))


