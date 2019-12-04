###################################
## Create txt files from scripts ##
###################################

huf.1_txt_from_site <- function(url_root, url, save_directory){
  base::dir.create(save_folder)
  # Extract html/xml content from URL
  rcurl.txt <- RCurl::getURL(url,
                             .opts = RCurl::curlOptions(followlocation = TRUE))
  # Parse html content
  url_parsed <- XML::htmlParse(rcurl.txt, asText = TRUE)
  
  # We need to get the href attributes from
  # the anchor tags <a> stored on the page
  attrs <- XML::xpathApply(url_parsed, "//a", XML::xmlAttrs)
  # Next, we'll split out the hrefs
  # from the other attributes
  hrefs <- base::sapply(base::seq_along(attrs), FUN = function(x) attrs[[x]][['href']])
  # Then, we only want the hrefs for the files
  # that have a .docx file extension
  episodes  <- hrefs[base::grep('view',hrefs)]
  # Construct a list of URL's for each file
  # by pasting two character strings together
  files <- base::paste0(url_root, episodes)
  # Read in the htmls for each file and get rid of additional markings
  for(i in files) {
    scraping_scripts <- xml2::read_html(i)
    
    text <- scraping_scripts %>%
      rvest::html_nodes("div.scrolling-script-container") %>%
      rvest::html_text() %>%
      stringr::str_replace_all(pattern = "\\s-\\s|\n|\r|\t|\"", replacement = " ") %>%
      stringr::str_trim(side = "both")
    
    fileConn <- base::file(base::paste(save_folder,"/", base::substr(i, nchar(i)-5, nchar(i)),".txt", sep=""))
    base::writeLines(text, fileConn)
    base::close(fileConn)
  }
  # Some common corruptions were identified for removal
  master_list <- base::list.files(path = save_folder,
                                  pattern = "s",
                                  full.names = TRUE)
  pattern_ep = "Episode\\s[0-9]{1}x[0-9]{2}\\s+[A-Z-]+\\s+([A-Z]+\\s)?"
  pattern_tr = base::paste0("Tr\\s+([a-zA-Z\\s]+:)+[a-zA-Z\\s]+", pattern_ep)
  
  for(i in master_list){
    txt <- base::readLines(i)
    txt <- stringr::str_replace_all(txt, pattern = pattern_tr, replacement = " ")
    txt <- stringr::str_replace_all(txt, pattern = pattern_ep, replacement = " ")
    base::writeLines(txt, con=i)
  }
}

######################################
## Create corpus from all txt files ##
######################################
huf.2_create_corpus <- function(txt_directory, ngram){
  corpus_tidy <- tibble::tibble()
  
  # Create List of All Files in Folder
  master_list <- base::list.files(path = txt_directory,
                                  pattern = "s",
                                  full.names = TRUE)
  ep = 0
  for(i in master_list){
    ep = ep + 1
    clean <- tibble::tibble(season = base::substr(i,nchar(i)-8,nchar(i)-7),
                            subep = base::substr(i,nchar(i)-5,nchar(i)-4),
                            episode = ep,
                            text = readr::read_file(i)) %>%
      tidytext::unnest_tokens(word, text, token = "ngrams", n = ngram)
    corpus_tidy <- base::rbind(corpus_tidy, clean)
  }
  # Set factor to keep episodes in order
  corpus_tidy$season <- base::factor(corpus_tidy$season)
  corpus_tidy$subep <- base::factor(corpus_tidy$subep)
  return(corpus_tidy)
}

