cat("\014") #Clear console
rm(list = ls()) #clear variables
dev.off()
library(pacman)
pacman::p_load( broom,
                coreNLP,
                dplyr,
                DT,
                ggplot2,
                ggraph,
                grid,
                here,
                igraph,
                knitr,
                lattice,
                LSAfun,
                magrittr,
                monkeylearn,
                NLP,
                openNLP,
                pdftools, 
                qdap,
                qdapDictionaries,
                qdapRegex,
                qdapTools,
                quanteda,
                RColorBrewer,
                reshape2,
                rJava,
                RWeka,
                scales,
                SnowballC,
                spacyr,
                stringr,
                tau,
                text2vec,
                textdata,
                textmineR,
                textrank,
                tidyr,
                tidytext,
                tidytext, 
                tidyverse,
                tm, 
                tokenizers,
                udpipe,
                widyr,
                wordcloud,
                XML
)



url  <- 'https://www.springfieldspringfield.co.uk/movie_script.php?movie=elf'
rcurl.doc <- RCurl::getURL(url,.opts = RCurl::curlOptions(followlocation = TRUE))
url_parsed <- XML::htmlParse(rcurl.doc, asText = TRUE)

#Create Text1
  text1 =  XML::xpathSApply(url_parsed, "//div[@class='scrolling-script-container']", xmlValue)
  text1 = gsub('\\\n', "", text1)
  text1 = gsub('\\  ', "", text1)
  text1 = gsub("Mmm","Mm", text1)
  text1 = gsub("Susan wells","Susan", text1)
  text1 = gsub("Walter Hobbs","Walter", text1)
  text1 = gsub("papa","Papa", text1)
  text1 = gsub("Papa Elf","Papa", text1)
  text1 = gsub("new York City","New York", text1)
  text1 = gsub("mike","Michael", text1)
  text1 = gsub("Ho ho ho ho ho","Ho ho ho", text1)
  text1 = gsub("ho ho ho","Ho ho ho", text1)
  text1 = gsub("greenway","Greenway", text1)
  text1 = gsub("charlotte","Charlotte", text1)
  text1 = gsub("chuck","Chuck", text1)
  text1 = gsub("Claus meter","Clause Meter", text1)
  text1 = gsub("elf","Elf", text1)
  text1 = gsub("Never","never", text1)
  text1 = gsub("a, san","a, Santa", text1)
  text1 = gsub("Lincoln tunnel","Lincoln Tunnel", text1)
  text1 = gsub("Aspires","aspires", text1)
  text1 = gsub("Wandering","wandering", text1)
  text1 = gsub("Spread","spread", text1)
  text1 = gsub("Behind","behind", text1)
  text1 = gsub("Carolyn Reynolds","Carolyn", text1)
  text1 = gsub("Decisin","decision", text1)
  
  text1 <- gsub("Santa clausis","Santa Claus",text1)
  text1 <- gsub("Santa Clausis","Santa Claus",text1)
  text1 <- gsub("Santa claus","Santa",text1)
  text1 <- gsub("Santa Claus","Santa",text1)
  text1 <- gsub("ray's pizzas","Rays Pizzas",text1)
  text1 <- gsub("Nice list","Nice_List",text1)
  text1 <- gsub("ho!","ho",text1)
  text1 <- gsub("Run","run",text1)
  
  
    


text2=data.frame(text1,stringsAsFactors = FALSE)
names(text2)<-"col1"
str(text2)

rm(url,rcurl.doc,url_parsed,text1)

spacy_initialize(model="en_core_web_sm")

presentation_parsed <- spacy_parse(text2$col1, entity = TRUE)
head(presentation_parsed)

full_extracted <- entity_extract(presentation_parsed)
head(full_extracted)


for (i in 1:nrow(full_extracted)) {
  if (full_extracted$entity[i]== "Santa" || 
      full_extracted$entity[i]== "Leon"  ||
      full_extracted$entity[i]== "Baby"  ||
      full_extracted$entity[i]== "Charlotte"  ||
      full_extracted$entity[i]== "arctic_puffin"  ||
      full_extracted$entity[i]=="Francisco" ||
      full_extracted$entity[i]=="Elf") {
    full_extracted$entity_type[i]="PERSON"
  }
  if (full_extracted$entity[i]== "Mm" ||
      full_extracted$entity[i]== "Ho_ho_ho" ||
      full_extracted$entity[i]== "Yaah" ||
      full_extracted$entity[i]== "syrup" ||
      full_extracted$entity[i]== "yoursElf" ||
      full_extracted$entity[i]== "Merry_Christmas" ){ 
    full_extracted$entity_type[i]="Other"
  }
  if (full_extracted$entity[i]== "the_candy_cane_forest" ||
      full_extracted$entity[i]== "the_Lincoln_Tunnel"){
    full_extracted$entity_type[i]="LOC"
  }  
  if (full_extracted$entity[i]== "Paparazzi"){
    full_extracted$entity_type[i]="ORG"
  } 
}


#Entity Types
full_extracted %>%
  count(entity_type) %>%
  top_n(100) %>%
  ggplot(aes(x = entity_type, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Entity Types") +
  xlab("Entity Type") +
  ylab("Count")


#Organization
full_extracted %>%
  filter(entity_type == "ORG") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(300) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Organization Entities") +
  xlab("Organizatons") +
  ylab("Mentions")

#Persons
full_extracted %>%
  filter(entity_type == "PERSON" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(15) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "What it Labeled as Persons") +
  xlab("Persons") +
  ylab("Mentions")

#Location
full_extracted %>%
  filter(entity_type == "LOC" | entity_type == "GPE") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(100) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Location/GPE Entities") +
  xlab("Locations") +
  ylab("Mentions")



#All Other
full_extracted %>%
  filter(entity_type != "PERSON" & entity_type != "LOC" & entity_type != "GPE" & entity_type != "ORG" ) %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(100) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  labs(title = "All Other") +
  xlab("All Other") +
  ylab("Mentions")

#Parts of Speech
presentation_parsed %>%
  group_by(pos) %>%
  count(entity) %>%
  ggplot(aes(x = pos, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  labs(title = "Parts of Speech") +
  xlab("Parts of Speech") +
  ylab("Count")

