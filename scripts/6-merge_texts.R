#' @description This function takes code from one 
#'              of two directories and merges them
#'              by their sub directories. In this case
#'              the subdirectories are each year.
#'              
#' @param reports A \code{logical} value. If \code{TRUE},
#'                pulls files from the sab_reports 
#'                directory.  Otherwise, the files
#'                are pulled from the sab_reviews
#'                directory.

merge_text <- function(reports = T, nouns = NULL) {
  
  if (!require("pacman")) install.packages("pacman")
  
  pacman::p_load(tm, 
                 pdftools, 
                 rprojroot,
                 stringi, 
                 tau, 
                 tidytext, 
                 qdap,
                 data.table)
  
   root <- find_root(is_rstudio_project)
  
  `if`(reports,
       Dir <- file.path(root, 'corpora','sab_reports'),
       Dir <- file.path(root, 'corpora','sab_reviews'))
  
  Dirs <- list.dirs(Dir, 
                    full.names = T, 
                    recursive = T)
  
  for(i in seq_along(Dirs[-1])) {
    
    files <- dir(Dirs[i+1],
                 full.names = T, 
                 recursive = T,
                 pattern = '.RData')
    
    my_env <- new.env()
    
    lapply(X = seq_along(files), 
           FUN = function(x) load(files[x], envir = my_env))
  
    res <- data.table::data.table()
    
  for(j in seq_along(files)) {
    
     this1 <- get(gsub('.RData','', basename(files[j])), envir = my_env)
    
    if(is.null(nouns)) {
      
     res <- rbind(res,this1$text)
     
     obj.name <- paste0('full_text_',
                       gsub(' ','_',basename(Dirs[i+1])))
     
     save.name <- paste0('full_text_',
                        gsub(' ','_',basename(Dirs[i+1])),
                        '.RData')
     
     out_dir <- 'full_texts'
    
  } else {
    
    if(nouns) {
    
     res <- rbind(res,this1$topics)
     
     obj.name <- paste0('full_topics_',
                       gsub(' ','_',basename(Dirs[i+1])))
     
     save.name <- paste0('full_topics_',
                        gsub(' ','_',basename(Dirs[i+1])),
                        '.RData')
     out_dir <- 'full_topics'
     
      } else {
        
        res <- rbind(res,this1$action)
     
     obj.name <- paste0('full_action_',
                       gsub(' ','_',basename(Dirs[i+1])))
     
     save.name <- paste0('full_action_',
                        gsub(' ','_',basename(Dirs[i+1])),
                        '.RData')
     
     out_dir <- 'full_action'
      
        
        
    }
    
  }
    
    assign(get('obj.name'), res)
    
   save(list = get('obj.name'), 
        file = file.path(dirname(Dirs[i+1]),out_dir, save.name))
     
  }

  }
}