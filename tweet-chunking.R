# assume that we already have tweets in a data.frame
# named tweet_df

# load packages
pacman::p_load(NLP,openNLP,tidytext,stringr,qdap,qdapRegex)

if(!installed.packages("openNLPmodels.en")) {
  
  install.packages("openNLPmodels.en", repos = "http://datacube.wu.ac.at/", type = "source")
  
}

# combine text from all tweets into one string
tweet_text = tweet_df$text

Encoding(tweet_text) <- "UTF-8"

# remove hyperlinks
tweet_text1 = stringr::str_remove_all(tweet_text, 
                                      pattern = 'http\\S*://\\S+\\.\\S+/\\S+')

# remove emojis
tweet_text2 = stringr::str_remove_all(tweet_text1, 
                                      pattern = '[\U{1f000}-\U{1f700}]')

# remove other non-ascii symbols
tweet_text3 = qdapRegex::rm_non_ascii(tweet_text2)

# remove new line escapes
tweet_text4 = qdap::mgsub(c('\n'),c(' '),tweet_text3)

# remove stopwords
#tweet_text4 = qdap::mgsub(tidytext::stop_words[[1]],'',tweet_text3)

# remove retweet text that precedes the actual text in the tweet
tweet_text5 = stringr::str_remove_all(tweet_text4, 
                                      pattern = 'RT @\\S+:')

# convert text into a string object for NLP
s = NLP::as.String(tweet_text5)

# create the annotation functions
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
pos_tag_annotator <- Maxent_POS_Tag_Annotator()
chunker = system.file("models","en-chunker.bin",package = "openNLPmodels.en")
chunk_annotator <- Maxent_Chunk_Annotator(model = chunker)

# use the annotation function on the string of text 
a3 <- NLP::annotate(s,
                    list(sent_token_annotator,
                         word_token_annotator,
                         pos_tag_annotator))

# use chunk_annotator to get phrases
s2 = NLP::annotate(s, chunk_annotator, a3)

sentences = subset(s2,type == "sentence")

sentences2 = character(max(sentences$id))
sentences2 = sapply(sentences$id, function(x) substr(s, sentences$start[x], sentences$end[x]))
phrases = subset(s2,type == "word")
 
tags <- sapply(s2$features,'[[',"chunk_tag")
tags

paste(sprintf("%s/%s",s[s2],tags), collapse = ' ')
