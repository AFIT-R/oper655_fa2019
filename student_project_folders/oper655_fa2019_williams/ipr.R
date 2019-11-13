#Project

#install pcaman anf necessry packages
install.packages("pacman")
install.packages("quanteda")
library("quanteda")
install.packages("ggplot")

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



root <- rprojroot::find_root(rprojroot::is_rstudio_project)

dest <- file.path(root, 'student_project_folders', 'oper655_fa2019_williams')

xpdf_tools <- 'C:/Program Files/xpdf-tools-win-4.02/bin64'

# make a vector of PDF file names
(pdf_files <- list.files(path = dest,
                         pattern = "pdf",
                         full.names = TRUE))


#lapply(pdf_files,
 #      FUN = function(x) system(glue::glue("pdftotext {x}"), wait = FALSE))

text_files <- list.files(path = dest,
                         pattern = "txt",
                         full.names = TRUE)

text1 <- readLines(con = text_files)

text2 <- pdftools::pdf_text(pdf = pdf_files[1])
text2[1]

writeLines(text = text2, con = gsub('pdf','txt', file.path(dest,basename(pdf_files[1]))))

#make single charcter vector for document

fa <- paste(text2,
             collapse = "\n\n")
attr(fa, "names") <- "Force Awakens"

#make corpus
#Replace next line with other star wars scripts

sw_movies <- c(fa)
sw_corpus <- quanteda::corpus(fa)

docvars(sw_corpus, "movies") <- names(sw_movies)
#metadoc(hp_corpus, "order") <- c(2,4,7,3,5,6,1)

summary(sw_corpus, showmeta = TRUE)

kwic(sw_corpus, pattern = "force")


#load packages for analysis
pacman::p_load(tm, 
               pdftools, 
               here,
               tau,
               tidyverse,
               stringr,
               tidytext, 
               RColorBrewer,
               qdap,
               qdapRegex,
               qdapDictionaries,
               qdapTools,
               data.table,
               coreNLP,
               scales,
               harrypotter,
               text2vec,
               SnowballC,
               DT,
               quanteda,
               RWeka,
               broom,
               tokenizers,
               grid,
               knitr,
               widyr)

text_tb <- tibble::tibble(chapter = base::seq_along(text2),
                          text = text2)

text_tb


 text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)


# top 10 most common words in each book
a = text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(10)


p<-ggplot(data=a, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="steelblue") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
p




