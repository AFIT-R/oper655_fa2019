# Text Mining Project: MCU Quantum Analysis
# By: Aaron Giddings

pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr,      # Tools for qualitative data
               DT)
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
install.packages(qdap)
library(qdap)
devtools::install_github("bradleyboehmke/harrypotter")
harrypotter::philosophers_stone[1]
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
pacman::p_load_gh("dgrtwo/drlib",
                  "trinker/termco", 
                  "trinker/coreNLPsetup",        
                  "trinker/tagger")
pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr)      # Tools for qualitative data

library(here)
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
dest3 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 3')
dest2 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 2')
dest1 <- file.path(root,'student_project_folders','oper655_fa2019_giddings','MCU Scripts', 'Phase 1')

mcu_phase3 <- list.files(dest3, 
                           pattern = 'pdf',
                           full.names = TRUE)
mcu_phase2 <- list.files(dest2, 
                         pattern = 'pdf',
                         full.names = TRUE)
mcu_phase1 <- list.files(dest1, 
                         pattern = 'pdf',
                         full.names = TRUE)

mcu_phase3[1]
tb_pdftools <- pdftools::pdf_text(pdf = mcu_phase3[1])

text_tb <- tibble::tibble(chapter = base::seq_along(tb_pdftools),
                          text = tb_pdftools)


text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE)
# top 10 most common words in each book
a = text_tb %>%
  tidytext::unnest_tokens(word, text, token = 'words') %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word, sort = TRUE) %>%
  top_n(12)
p<-ggplot(data=a, aes(x = reorder(word, n), y =n)) +
  geom_bar(stat="identity", fill="darkred") + coord_flip() +
  theme(legend.position="none") + theme_minimal()
p
# calculate percent of word use across all novels
quantum_pct <- a %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::transmute(word, all_words = n / sum(n))

# calculate percent of word use within each novel
frequency <- quantum_pct %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::count(word) %>%
  dplyr::mutate(book_words = n / sum(n)) %>%
  dplyr::left_join(quantum_pct) %>%
  dplyr::arrange(dplyr::desc(book_words)) %>%
  dplyr::ungroup()

frequency
