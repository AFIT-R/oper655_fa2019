install.packages("here")
install.packages("pdftools")
library(pdftools)
library(here)
root <- here('data', 'pdf_raw','supreme_court_opinions_2017')

trav_ban_pdf <- list.files(root, 
                           pattern = '17-965\\S+pdf$',
                           full.names = T)
trav_ban_pdf 

tb_pdftools <- pdftools::pdf_text(trav_ban_pdf)

# Length of trav_ban vector represents the
# number of pages in the pdf document
length(tb_pdftools)
pdftools::pdf_info(trav_ban_pdf)$pages
tb_pdftools[1]

cat(tb_pdftools[1]) 

cmd1 <- 'pdftotext' 
cmd2 <- '-layout'   
cmd3 <- trav_ban_pdf
cmd4 <- ''          

CMD1 <- glue::glue("{cmd1} {cmd2} {cmd3} {cmd4}")

system(CMD1)

trav_ban_txt <- list.files(root, 
                           pattern = '17-965\\S+txt$',
                           full.names = T)

tb_pdftotext <- readLines(trav_ban_txt,
                          warn = F)

# Number of lines in character vector returned
str(tb_pdftotext)

tb_pdftotext[1]

all_countries <- countrycode::codelist$country.name.en

countries <- tibble::tibble(name = all_countries)

countries$pages <- 
  sapply(seq_along(all_countries),
         FUN = function(x) grep(all_countries[x], tb_pdftools))

countries$total_pages <- 
  sapply(seq_along(countries$pages),
         FUN = function(x) length(countries$pages[x][[1]]))

countries <- subset(countries, 
                    subset = total_pages > 0)
##
usc_singles <- str_extract_all(string = tb_pdftools, 
                               pattern = "§\\S+") 

usc_doubles <- str_extract_all(string = tb_pdftools, 
                               pattern = "§§\\S+\\s+\\S+")


cmd1 <- 'pdftohtml' 
cmd2 <- '-s -i -q -xml'  
cmd3 <- trav_ban_pdf

# Two options to connect the strings
CMD1 <- glue::glue("{cmd1} {cmd2} {cmd3}")

system(CMD1)

# Extract html/xml content from URL
url <- stringr::str_replace(trav_ban_pdf, 
                            pattern = '[.]pdf',
                            replacement = '-html.html')

url_lines <- readLines(url)
url_lines_gsub <- qdap::mgsub(pattern     = c('§','â€œ','â€\u009d','â€™','Â','&#160;'),
                              replacement = c('&sect;','"'  ,    '"'   , "'" ,' ',   ' '),
                              url_lines)

# We need to get the href attributes from 
# the anchor tags <a> stored in the table 
# as table data tags <td>
# First, let's get all of the attributes
italic <- XML::xpathSApply(url_lines_gsub, "//i", XML::xmlValue)



install_name_tool -change \
/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home/lib/server/libjvm.dylib \
/Library/Java/JavaVirtualMachines/jdk-10.jdk/Contents/Home/lib/server/libjvm.dylib \ 
/Library/Frameworks/R.framework/Resources/library/rJava/libs/rJava.so


options("java.home"="/Library/Java/JavaVirtualMachines/jdk-13.0.1.jdk/Contents/Home/lib")

Sys.setenv(LD_LIBRARY_PATH='$JAVA_HOME/server')

dyn.load('/Library/Java/JavaVirtualMachines/jdk-13.0.1.jdk/Contents/Home/lib/server/libjvm.dylib')
install.packages("rJava")
library(rJava)
'''
Install Java Runtime Environment JRE from:
https://www.java.com/en/download/mac_download.jsp

Install Java Development Kit JDK 11 from:
https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html
https://www.oracle.com/technetwork/java/javase/downloads/jdk13-downloads-5672538.html

run the following command in the terminal:
sudo R CMD javareconf

After reinstalling JDK and rJava, The solution for me was closing Rstudio, running 
R CMD javareconf and then opening R in terminal, typing library(rJava), exiting 
the session, and then doing the same in Rstudio, at which point it finally worked.

Run the following cmd
dyn.load('/Library/Java/JavaVirtualMachines/jdk-13.0.1.jdk/Contents/Home/lib/server/libjvm.dylib')


tried this page
https://stackoverflow.com/questions/47658210/loading-rjava-on-mac-os-high-sierra


Deleted all R and RStudio, reinstalled, and then tried this:
http://www.owsiak.org/r-3-4-rjava-macos-and-even-more-mess/
'''


