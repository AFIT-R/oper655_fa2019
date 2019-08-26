get_speech <- function(text) {
  
  # corpus <- dget(file = corpus_file)
  # 
  # word_df <- corpus$Words
  
  # tagged <- tagger::tag_pos(word_df[['unigrams']])
  
  tagged <- tagger::tag_pos(text, engine = 'coreNLP')
  
  tag_df <- tagger::tidy_pos(tagged)
  
  tag_df$pre = '<p>'
  
  tag_df$post = '</p>'
  
  tag_df$is_stop = sapply(X = 1:nrow(tag_df), 
                          FUN = function(x) { 
                         
                          as.logical(grepl(tag_df$token[x],
                                           tidytext::stop_words[,1],
                                           fixed = T))
                         }) 
  
  tag_df$is_numeric <- !is.na(suppressWarnings(as.numeric(tag_df$token)))
  
  tag_df$is_punct = sapply(X = 1:nrow(tag_df), 
                           FUN = function(x) { 
                            
                           as.logical(grepl('[[:punct:]]',
                                            tag_df$token[x]))
                          }) 
  
  tag_df$html_pre <- sapply(X = 1:nrow(tag_df),
                            FUN = function(x) {
                            gsub('p',
                                 tag_df$pos[x], 
                                 tag_df$pre[x],
                                 fixed = T) 
                              })
  
  tag_df$html_post <- sapply(X = 1:nrow(tag_df),
                             FUN = function(x) {
                             gsub('p',
                                  tag_df$pos[x], 
                                  tag_df$post[x],
                                  fixed = T) 
                               })
  
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxxxxxxxxxxxx' ] <-  "<br/><p class='vspace20'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxxxxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxxxxxxxxxx' ] <-  "<br/><p class='vspace18'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxxxxxxxx' ] <-  "<br/><p class='vspace16'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxxxxxx' ] <-  "<br/><p class='vspace14'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxxxx' ] <-  "<br/><p class='vspace12'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxxxx' ] <-  "<br/><p class='vspace10'>"
  tag_df$html_post[tag_df$token =='xxxxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxxxx' ] <-  "<br/><p class='vspace8'>"
  tag_df$html_post[tag_df$token =='xxxxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxxxx' ] <-  "<br/><p class='vspace6'>"
  tag_df$html_post[tag_df$token =='xxxxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xxxx' ] <-  "<br/><p class='vspace4'>"
  tag_df$html_post[tag_df$token =='xxxx' ] <- '</p>'
  tag_df$html_pre[tag_df$token  =='xx' ] <-  "<br/>"
  
  tag_df$token[tag_df$token=='xxxxxxxxxxxxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxxxxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxxxx' ] <- ''
  tag_df$token[tag_df$token=='xxxx' ] <- ''
  tag_df$token[tag_df$token=='xx' ] <- ''
  
   tag_df$html_pre[is.na(tag_df$html_pre) ] <-  "<p class='vspace'>"
  tag_df$html_post[is.na(tag_df$html_post)] <- '</p>' 
  
  tag_df$token[is.na(tag_df$token) ]        <-  ''
  tag_df$token[tag_df$pos%in%c('JJ','SYM')] <-  ''
  tag_df$token[tag_df$pos%in%c('JJ','SYM')] <-  ''
  tag_df$token[tag_df$pos%in%c('-LRB-')] <-  '('
  tag_df$token[tag_df$pos%in%c('-RRB-')] <-  ')'
  
  skip_token <- tag_df$is_punct | tag_df$is_stop | tag_df$is_numeric
  
  tag_df$html_pre[skip_token] <-  '<other>'
  tag_df$html_post[skip_token] <- '</other>' 
  
  # tag_df$combined <- sapply(X = 1:nrow(tag_df),
  #                            FUN = function(x) {
  #                              paste0('p',
  #                                   tag_df$pos[x], 
  #                                   tag_df$post[x],
  #                                   fixed = T) 
  #                            })
  # 
  return(tag_df)
}
