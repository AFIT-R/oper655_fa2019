#install.packages("pacman")
pacman::p_load(XML,
               rvest,
               RCurl,
               rprojroot,
               qdapTools,
               pdftools,
               antiword,
               glue,
               data.table,
               tidyverse,
               vroom,
               antiword,
               magick,
               tesseract)

oper655_readme_url <- "https://raw.githubusercontent.com/AFIT-R/oper655_fa2019/master/README.md"
oper_readme_text <- readLines(oper655_readme_url, encoding = "UTF-8")

str(oper_readme_text)
head(oper_readme_text)
oper_readme_text[136] #check quotes
oper_readme_text[251] #check elipsis
oper_readme_text[264] #check apostrophe

root <- rprojroot::find_root(rprojroot::is_rstudio_project)
(amazon_review_file <- file.path(root, "data","csv", "1429_1.csv"))

time1 <- system.time({ amazon_review_data_1 <- read.csv(amazon_review_file, stringsAsFactors = FALSE) })
str(amazon_review_data_1$reviews.text)

time2 <- system.time({ amazon_review_data_2 <- readr::read_csv(amazon_review_file) })

time3 <- system.time({ amazon_review_data_3 <- data.table::fread(amazon_review_file) })

time4 <- system.time({ amazon_review_data_4 <- vroom::vroom(amazon_review_file) })


# Assign the URL to a text string
url_root  <- 'http://hhoppe.com/'
url  <- 'http://hhoppe.com/microsoft_word_examples.html'

# Assign the root of the project this
# helps locate where to save the files
# Before going forward you should change
# these values to a location on your machine
proj_root   <- find_root(is_rstudio_project)
save_folder <- file.path(proj_root,'student_project_folders','oper655_fa2019_hufstetler','raw_data_files','msword_document_examples')

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
docx  <- hrefs[tools::file_ext(hrefs) == 'docx']

# Construct a list of URL's for each file
# by pasting two character strings together
files <- paste0(url_root, docx)

# loop through each element in the files
# vector and download the file to destfile
for(i in files) {
  
  filename <- basename(i)
  download.file(i,
                destfile = file.path(save_folder,filename),
                method = 'curl')
  
}



dest <- file.path(root, 'data', 'msword')

# make a vector of MS Word file names
(ms_files <- list.files(path = dest,
                        pattern = "docx",
                        full.names = TRUE))

docx1 <- qdapTools::read_docx(file = ms_files[1])
docx1[90:91]

# Assign the URL to a text string
url_root  <- 'https://www.supremecourt.gov'
url  <- 'https://www.supremecourt.gov/opinions/slipopinion/17'

# Assign the root of the project this
# helps locate where to save the files
# Before going forward you should change
# these values to a location on your machine
proj_root   <- rprojroot::find_root(is_rstudio_project)
save_folder <- base::file.path(proj_root,'raw_data_files','supreme_court_opinions_2017')

# Extract html/xml content from URL
rcurl.doc <- RCurl::getURL(url,
                           .opts = RCurl::curlOptions(followlocation = TRUE))

# Parse html content
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

# We need to get the href attributes from
# the anchor tags <a> stored in the table
# as table data tags <td>
# First, let's get all of the attributes
attrs <- XML::xpathApply(url_parsed, "//td//a", XML::xmlAttrs)

# Next, we'll split out the hrefs
# from the other attributes
hrefs <- sapply(seq_along(attrs), FUN = function(x) attrs[[x]][['href']])

# Then, we only want the hrefs for the files
# that have a .pdf file extension
pdfs  <- hrefs[tools::file_ext(hrefs) == 'pdf']

# Construct a list of URL's for each file
# by pasting two character strings together
files <- paste0(url_root,pdfs)

# loop through each element in the files
# vector and download the file to destfile
for(i in files) {
  
  filename <- basename(i)
  download.file(i,
                destfile = file.path(save_folder,filename),
                method = 'curl')
  
}

xpdf_tools <- '/Users/Brandon/xpdf-tools-mac-4.02/bin64'

dest <- file.path(root, 'data', 'pdf_raw','supreme_court_opinions_2017_sample')

# make a vector of PDF file names
(pdf_files <- list.files(path = dest,
                         pattern = "pdf",
                         full.names = TRUE))


if(nchar(Sys.which('pdftotext') > 0)) {
  
  system('pdftotext')
  
}

cmd1 <- 'pdftotext' # which utility are we calling?
cmd2 <- ''          # which options? - here we use none
cmd3 <- pdf_files[1] # which file to convert
cmd4 <- ''          # which file to write to

# Two options to connect the strings
CMD1 <- glue::glue("{cmd1} {cmd2} {cmd3} {cmd4}")
CMD2 <- paste(cmd1, cmd2, cmd3, cmd4, sep = ' ')

system(CMD1)

lapply(pdf_files,
       FUN = function(x) system(glue::glue("pdftotext {x}"), wait = FALSE))


text_files <- list.files(path = dest,
                         pattern = "txt",
                         full.names = TRUE)

text1 <- readLines(con = text_files[1])

text1[1:50]

data.frame(function_names = getNamespaceExports('pdftools'))

text2 <- pdftools::pdf_text(pdf = pdf_files[1])
text2[1]

writeLines(text = text2,
           con = gsub('pdf','txt', file.path(dest,basename(pdf_files[1]))))

pdf_image <- file.path(root,"data","pdf_image","Non-text-searchable.pdf")

pdf_png <- pdftools::pdf_convert(pdf_image, dpi = 600)

tesseract_text <- tesseract::ocr(pdf_png)

tesseract_text

browseURL(pdf_image)

image_file <- file.path(root, 'data','pdf_image', 't1.tif')

magick_text <- image_read(image_file) %>%
  image_resize("2000") %>%
  image_convert(colorspace = 'gray') %>%
  image_trim() %>%
  image_ocr()

browseURL(image_file)

magick_text



















