pacman::p_load(tidytext,
               tidyverse,
               quanteda,
               stm,
               topicmodels,
               lsa,
               here,
               DT,
               data.table,
               stringr,
               twitteR,
               httr,
               lubridate,
               ggmap)

# Locate the root of our project
root <- here::here()

# From the root, find the directory of files
# and select those with the .RData extension
pur <- list.files(path = file.path(root,"data","phone_user_reviews"),
                  pattern = ".RData",
                  full.names = T)

# We don't know the name of the object inside of each .RData file
# So, we create a new environment and load the object there
# We know there's only one object in this environment
# So, we don't need to know the object's name
# We just use ls() to list the objects and then get() the first one
# Using get() reads in the object into the global environment
env <- new.env()
load(pur[1], envir = env)
PUR <- data.table::data.table(get(ls(envir = env)[1], envir = env))

# After we're done we destroy the new environment that we created 
rm(env)

# Then repeat the process for the other files
# We make sure to rbind() the rows of each object together 
for(i in 2:length(pur)){
  
  env <- new.env()
  load(pur[i], envir = env)
  PUR_i <- data.table::data.table(get(ls(envir = env)[1], envir = env))
  
  PUR = rbind(PUR,PUR_i)
  rm(env)
  
}

PUR_en <- PUR[lang == "en" & country == "us"]

is_samsung <- stringr::str_detect(tolower(PUR_en$product), "samsung")

is_edge <- stringr::str_detect(tolower(PUR_en$product), "edge")

PUR_en_edge <- PUR_en[is_samsung & is_edge,]

PUR_en_edge[,date := as.Date(date, format = "%d/%m/%Y")]

PUR_en_edge_2015 <- PUR_en_edge[date > as.Date("1/1/2015",format = "%d/%m/%Y")]
PUR_en_edge_2015$extract <- qdap::mgsub(c("samsung", "phone", "edge", "galaxy"), "", PUR_en_edge_2015$extract)
DT::datatable(head(PUR_en_edge_2015, 100))

PUR_corpus <- quanteda::corpus(PUR_en_edge_2015$extract)

quanteda::docvars(PUR_corpus, "date")    <- PUR_en_edge_2015$date
quanteda::docvars(PUR_corpus, "score")   <- PUR_en_edge_2015$score
quanteda::docvars(PUR_corpus, "source")  <- PUR_en_edge_2015$source
quanteda::docvars(PUR_corpus, "domain")  <- PUR_en_edge_2015$domain
quanteda::docvars(PUR_corpus, "product") <- PUR_en_edge_2015$product
quanteda::docvars(PUR_corpus, "country") <- PUR_en_edge_2015$country

DT::datatable(summary(PUR_corpus))
sub_corpus <- quanteda::corpus_subset(PUR_corpus, score <= 6)

PUR_dfm <- quanteda::dfm(sub_corpus,
                         remove = quanteda::stopwords("english"),
                         stem = !TRUE, 
                         remove_punct = TRUE)

sub_PUR_lda <- topicmodels::LDA(convert(PUR_dfm, to = "topicmodels"), k = 7)

topicmodels::get_terms(sub_PUR_lda, 5)
