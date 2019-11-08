pacman::p_load(tidyr,
               tidytext,
               tidyverse,
               textdata,
               dplyr,
               stringr,
               ggplot2,
               magrittr,
               wordcloud,
               reshape2)

root <- rprojroot::find_root(rprojroot::is_rstudio_project)\
file_loc <- file.path(root,"data","phone_user_reviews")

file_list <- list.files(path = file_loc,
                        pattern = "",
                        full.names = TRUE)
reviews_tidy <- tibble::tibble()
manu_pattern <- "/cellphones/[a-z0-9]+"
prod_pattern <- paste(manu_pattern, "-|/", sep = "")
for (i in file_list){
  input <- load(i,ex <- new.env())
  text_raw <- get(ls(ex),ex)
  text_en <- text_raw[text_raw$lang=="en",]
  rm(ex, text_raw, input, i)
  
  clean <- tibble::tibble(score = text_en$score,
                          maxscore = text_en$score_max,
                          text = text_en$extract,
                          product = gsub(prod_pattern, "", text_en$phone_url),
                          author = text_en$author,
                          manufacturer = gsub("/cellphones/","",str_extract(text_en$phone_url,manu_pattern))) 
  
  reviews_tidy <- base::rbind(reviews_tidy, clean)
  rm(text_en, clean)
}
rm(file_list, root, manu_pattern, prod_pattern, file_loc)








library(textmineR)



# First create a TCM using skip grams, we'll use a 5-word window
# most options available on CreateDtm are also available for CreateTcm
tcm <- CreateTcm(doc_vec = reviews_tidy[,3],
                 skipgram_window = 10,
                 verbose = FALSE,
                 cpus = 2)

# use LDA to get embeddings into probability space
# This will take considerably longer as the TCM matrix has many more rows 
# than a DTM
embeddings <- FitLdaModel(dtm = tcm,
                          k = 50,
                          iterations = 200,
                          burnin = 180,
                          alpha = 0.1,
                          beta = 0.05,
                          optimize_alpha = TRUE,
                          calc_likelihood = FALSE,
                          calc_coherence = FALSE,
                          calc_r2 = FALSE,
                          cpus = 2)


# parse it into sentences
sent <- stringi::stri_split_boundaries(reviews_tidy, type = "sentence")[[ 4 ]]

names(sent) <- seq_along(sent) # so we know index and order

# embed the sentences in the model
e <- CreateDtm(sent, ngram_window = c(1,1), verbose = FALSE, cpus = 2)

# remove any documents with 2 or fewer words
e <- e[ rowSums(e) > 2 , ]

vocab <- intersect(colnames(e), colnames(gamma))

e <- e / rowSums(e)

e <- e[ , vocab ] %*% t(gamma[ , vocab ])

e <- as.matrix(e)





# get the pairwise distances between each embedded sentence
e_dist <- CalcHellingerDist(e)

# turn into a similarity matrix
g <- (1 - e_dist) * 100

# we don't need sentences connected to themselves
diag(g) <- 0

# turn into a nearest-neighbor graph
g <- apply(g, 1, function(x){
  x[ x < sort(x, decreasing = TRUE)[ 3 ] ] <- 0
  x
})

# by taking pointwise max, we'll make the matrix symmetric again
g <- pmax(g, t(g))



library(igraph)
g <- graph.adjacency(g, mode = "undirected", weighted = TRUE)

# calculate eigenvector centrality
ev <- evcent(g)

# format the result
result <- sent[ names(ev$vector)[ order(ev$vector, decreasing = TRUE)[ 1:3 ] ] ]

result <- result[ order(as.numeric(names(result))) ]

paste(result, collapse = " ")