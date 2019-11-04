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

DT::datatable(head(PUR_en_edge_2015, 100))

PUR_corpus <- quanteda::corpus(PUR_en_edge_2015$extract)

quanteda::docvars(PUR_corpus, "date")    <- PUR_en_edge_2015$date
quanteda::docvars(PUR_corpus, "score")   <- PUR_en_edge_2015$score
quanteda::docvars(PUR_corpus, "source")  <- PUR_en_edge_2015$source
quanteda::docvars(PUR_corpus, "domain")  <- PUR_en_edge_2015$domain
quanteda::docvars(PUR_corpus, "product") <- PUR_en_edge_2015$product
quanteda::docvars(PUR_corpus, "country") <- PUR_en_edge_2015$country

DT::datatable(summary(PUR_corpus))

new     <- log(3/2)
york    <- log(3/2)
times   <- log(3/2)
post    <- log(3/1)
los     <- log(3/1)
angeles <- log(3/1)

(doc1 <- c(new*1, york*1, times*1, post*0, los*0, angeles*0))
(doc2 <- c(new*1, york*1, times*0, post*1, los*0, angeles*0))
(doc3 <- c(new*0, york*0, times*1, post*0, los*1, angeles*1))

(doc1 %*% doc2) / (sqrt(sum(doc1 ^ 2)) * sqrt(sum(doc2 ^ 2)))
(doc1 %*% doc3) / (sqrt(sum(doc3 ^ 2)) * sqrt(sum(doc1 ^ 2)))
(doc2 %*% doc3) / (sqrt(sum(doc2 ^ 2)) * sqrt(sum(doc3 ^ 2)))
(query = c(new * (2/2), york * 0, times * (1 / 2), post * 0, los * 0, angeles * 0))
(doc1 %*% query) / (sqrt(sum(doc1 ^ 2)) * sqrt(sum(query ^ 2)))
(doc2 %*% query) / (sqrt(sum(doc2 ^ 2)) * sqrt(sum(query ^ 2)))
(doc3 %*% query) / (sqrt(sum(doc3 ^ 2)) * sqrt(sum(query ^ 2)))




# You'll need to get your own keys by 
# creating a Twitter developer account
twitter_consumer_key    <- jkf::key_chain('twitter.api')
twitter_consumer_secret <- jkf::key_chain('twitter.api.secret')
twitter_access_token    <- jkf::key_chain('twitter.token')
twitter_access_secret   <- jkf::key_chain('twitter.token.secret')

twitteR::setup_twitter_oauth(consumer_key    = twitter_consumer_key,
                             consumer_secret = twitter_consumer_secret,
                             access_token    = twitter_access_token,
                             access_secret   = twitter_access_secret)
