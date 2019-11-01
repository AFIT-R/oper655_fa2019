pacman::p_load(XML,
               RCurl,
               rprojroot,
               gsubfn)

# Assign the URL to a text string
url_root <- 'https://www.springfieldspringfield.co.uk/'
url  <- 'https://www.springfieldspringfield.co.uk/episode_scripts.php?tv-show=the-office-us'

# Assign the root of the project this
# helps locate where to save the files
# Before going forward you should change
# these values to a location on your machine\
proj_root   <- find_root(is_rstudio_project)
save_folder <- file.path(proj_root,'student_project_folders','oper655_fa2019_hufstetler','Files')

# Extract html/xml content from URL
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))

# Parse html content
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

# We need to get the href attributes from
# the anchor tags <a> stored on the page
attrs <- XML::xpathApply(url_parsed, "//a", XML::xmlAttrs)

# Next, we'll split out the hrefs
# from the other attributes
hrefs <- sapply(seq_along(attrs), FUN = function(x) attrs[[x]][['href']])

# Then, we only want the hrefs for the files
# that have a .docx file extension
episodes  <- hrefs[grep('view',hrefs)]

# Construct a list of URL's for each file
# by pasting two character strings together
files <- paste0(url_root, episodes)

# loop through each element in the files
# vector and download the file to destfile
for(i in files) {
  # Extract html/xml content from URL
  rcurl.doc <- RCurl::getURL(i,
                             .opts = RCurl::curlOptions(followlocation = TRUE))
  text <- gsub('^.*script-container\">\\s*|\\s*\n.*$', '', rcurl.doc)
  text <- gsub('<br>','',text)  
  
  setwd("~/oper655_fa2019/student_project_folders/oper655_fa2019_hufstetler/Files")
  fileConn<-file(paste(substr(i, nchar(i)-5, nchar(i)),".txt", sep=""))
  writeLines(text, fileConn)
  close(fileConn)
}

library(rvest)

scraping_scripts <- read_html(files[1])

text <- gsub("   ","",gsub(" - |\\r|\\n|\\t"," ",scraping_scripts %>%
  html_nodes("div.scrolling-script-container") %>%
  html_text()))


