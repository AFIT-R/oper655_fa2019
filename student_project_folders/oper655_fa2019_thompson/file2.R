cat("\014") #Clear console
rm(list = ls()) #clear variables

#url="C:/Users/Max's USAFA PC/Documents/SCHOOL/Txt_Mining/ELF.html"

rcurl.doc <- RCurl::getURL("file:///C:/Users/Max's USAFA PC/Documents/SCHOOL/Txt_Mining/ELF.html",
                           .opts = RCurl::curlOptions(followlocation = TRUE))

# Parse html content
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

library(XML)
doc.text = unlist(xpathApply(url_parsed, '//p', xmlValue))

# Replace all \n by spaces
doc.text = gsub('\\n', "", doc.text)



#print(doc.text)

doc_text_2=""
j=1
for (i in 1:length(doc.text)) {
  if ( doc.text[i]!="" ) {
    doc_text_2[j]=doc.text[i]
    j=j+1
  }
}

head(doc_text_2,10)
doc_text_2[2820:2826]

library(tidytext)
text_tb <- tibble::tibble(text = doc_text_2)

library(magrittr)
doc_text_3 = text_tb %>% tidytext::unnest_tokens(word, text, token = 'words')

doc_text_3
