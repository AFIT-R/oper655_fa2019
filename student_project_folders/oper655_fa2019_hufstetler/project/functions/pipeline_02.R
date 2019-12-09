###########################################
## Create tidy corpus from all txt files ##
###########################################
huf.2_create_corpus <- function(txt_directory){
  corpus_tidy <- tibble::tibble()
  
  # Create List of All Files in Folder
  master_list <- base::list.files(path = txt_directory,
                                  pattern = "s",
                                  full.names = TRUE)
  ep = 0
  for(i in master_list){
    ep = ep + 1
    clean <- tibble::tibble(episode = ep,
                            season = base::substr(i,nchar(i)-8,nchar(i)-7),
                            subep = base::substr(i,nchar(i)-5,nchar(i)-4), 
                            ep_title = base::paste("S",
                                                   base::substr(i,nchar(i)-8,nchar(i)-7),
                                                   "E",
                                                   base::substr(i,nchar(i)-5,nchar(i)-4), 
                                                   sep = ""),
                            word = readr::read_file(i))
    corpus_tidy <- base::rbind(corpus_tidy, clean)
  }
  # Set factor to keep episodes in order
  corpus_tidy$season <- base::factor(corpus_tidy$season)
  corpus_tidy$subep <- base::factor(corpus_tidy$subep)
  return(corpus_tidy)
}