# Create data.frame of n-grams words from a document
# pacman::p_load(stringi, tm, tau, tidytext, RColorBrewer)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(tm, 
               pdftools, 
               rprojroot,
               stringi, 
               tau, 
               tidytext, 
               RColorBrewer,
               qdap)

pacman::p_load_gh(c("trinker/termco", 
                    "trinker/coreNLPsetup",
                    "trinker/tagger",
                    "trinker/textshape"))

root     <- find_root(is_rstudio_project)
rev_root <- file.path(root, "75_anniversary_reviews_consolidated")
rpt_root <- file.path(root, "sab_reports_for_75_anniversary_commemorative_book")

## Comment out the directory you don'd want

this_dir <- list.dirs(rpt_root, recursive = F) # 1 - 25
#this_dir <- list.dirs(rev_root, recursive = F) # 1 - 15


for(j in this_dir[16]) {
  
files <- dir(j, recursive = T, full.names = T)

for(i in files[2:3]) {
  
  text <- get_text(i) 
  
  speech <- get_speech(text)
  
  xterms <- sapply(X = 10:1, 
                   FUN = function(x) paste0(rep('xx', x), collapse = ''))
  
  text2 <- qdap::mgsub(xterms, '', text)
  
  ngrams <- lapply(X = 1:10, 
                   FUN = function(x) get_ngrams(text2, n = x))
  
  topics <- get_speech_text(speech, nouns = T)
  action <- get_speech_text(speech, nouns = F)
  
  filename <- get_filename(i)
  
  assign(filename, list(text = text2,
                        speech = speech,
                        ngrams = ngrams,
                        filename = filename,
                        topics = topics,
                        actions = action))
  
  save_dir <- file.path(root, 'corpora','sab_reports',basename(dirname(i)))
  save_file <- paste0(filename,'.RData')
  
  if(!dir.exists(save_dir)) dir.create(save_dir)
  
  save(list = get(filename)$filename, 
       file = file.path(save_dir,save_file))
}
}
