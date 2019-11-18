rm(list = ls())
root <- rprojroot::find_root(rprojroot::is_rstudio_project)

options(java.parameters = "- Xmx1024m")
pacman::p_load(tidyr,
               tidytext,
               tidyverse,
               textdata,
               dplyr,
               stringr,
               ggplot2,
               magrittr,
               wordcloud,
               reshape2,
               entity,
               monkeylearn,
               quanteda,
               spacyr,
               rJava,
               NLP,
               openNLP)

spacy_initialize()
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
file_loc <- file.path(root,"data","phone_user_reviews")

file_list <- list.files(path = file_loc,
                        pattern = "",
                        full.names = TRUE)
reviews_tidy <- tibble::tibble()
manu_pattern <- "/cellphones/[a-z0-9]+"
prod_pattern <- paste(manu_pattern, "-|/", sep = "")
for (i in file_list){
  input <- load(i,ex <- new.env())
  text_raw <- get(ls(ex),ex)
  text_en <- text_raw[text_raw$lang=="en",]
  rm(ex, text_raw, input, i)
  
  clean <- tibble::tibble(score = text_en$score,
                          maxscore = text_en$score_max,
                          text = text_en$extract,
                          product = gsub(prod_pattern, "", text_en$phone_url),
                          author = text_en$author,
                          manufacturer = gsub("/cellphones/","",str_extract(text_en$phone_url,manu_pattern)))#%>%
  #tidytext::unnest_tokens(word, text) 
  reviews_tidy <- base::rbind(reviews_tidy, clean)
  rm(text_en, clean)
}
rm(file_list, root, manu_pattern, prod_pattern, file_loc)

##################Uses spacyR######################################

sub_data1 <- as.data.frame(reviews_tidy[1:50000,], stringsAsFactors = FALSE)
sub_data2 <- as.data.frame(reviews_tidy[50001:100000,], stringsAsFactors = FALSE)
sub_data3 <- as.data.frame(reviews_tidy[100001:150000,], stringsAsFactors = FALSE)
sub_data4 <- as.data.frame(reviews_tidy[150001:200000,], stringsAsFactors = FALSE)
sub_data5 <- as.data.frame(reviews_tidy[200001:250000,], stringsAsFactors = FALSE)
sub_data6 <- as.data.frame(reviews_tidy[250001:300000,], stringsAsFactors = FALSE)
sub_data7 <- as.data.frame(reviews_tidy[300001:350000,], stringsAsFactors = FALSE)
sub_data8 <- as.data.frame(reviews_tidy[350001:400000,], stringsAsFactors = FALSE)
sub_data9 <- as.data.frame(reviews_tidy[400001:450000,], stringsAsFactors = FALSE)
sub_data10 <- as.data.frame(reviews_tidy[450001:500000,], stringsAsFactors = FALSE)
sub_data11 <- as.data.frame(reviews_tidy[500001:554746,], stringsAsFactors = FALSE)

setwd("C:/Users/Tyler/Documents/oper655_fa2019/student_project_folders/oper655_fa2019_spangler/NER")

parsed_1 <- spacy_parse(sub_data1$text, entity = TRUE)
save(parsed_1, file = "parsed1.RData")

parsed_2 <- spacy_parse(sub_data2$text, entity = TRUE)
save(parsed_2, file = "parsed2.RData")

parsed_3 <- spacy_parse(sub_data3$text, entity = TRUE)
save(parsed_3, file = "parsed3.RData")

parsed_4 <- spacy_parse(sub_data4$text, entity = TRUE)
save(parsed_4, file = "parsed4.RData")

parsed_5 <- spacy_parse(sub_data5$text, entity = TRUE)
save(parsed_5, file = "parsed5.RData")

parsed_6 <- spacy_parse(sub_data6$text, entity = TRUE)
save(parsed_6, file = "parsed6.RData")

parsed_7 <- spacy_parse(sub_data7$text, entity = TRUE)
save(parsed_7, file = "parsed7.RData")

parsed_8 <- spacy_parse(sub_data8$text, entity = TRUE)
save(parsed_8, file = "parsed8.RData")

parsed_9 <- spacy_parse(sub_data9$text, entity = TRUE)
save(parsed_9, file = "parsed9.RData")

parsed_10 <- spacy_parse(sub_data10$text, entity = TRUE)
save(parsed_10, file = "parsed10.RData")

parsed_11 <- spacy_parse(sub_data11$text, entity = TRUE)
save(parsed_11, file = "parsed11.RData")

file_loc <- getwd()
file_list <- list.files(path = file_loc,
                        pattern = ".RData",
                        full.names = TRUE)
full_parsed <- data.frame()
for (i in file_list){
  parsed <- load(i)
}

full_parsed <- rbind(parsed_1, parsed_2, parsed_3, parsed_4, parsed_5, parsed_6,
                     parsed_7, parsed_9, parsed_10, parsed_11)
 
full_extracted <- entity_extract(full_parsed, type = "all")
save(full_extracted, file = "fullextracted.RData")

full_extracted %>%
  filter(entity_type != "CARDINAL" & entity_type != "ORDINAL") %>%
  count(entity_type) %>%
  top_n(10) %>%
  ggplot(aes(x = entity_type, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

full_extracted %>%
  filter(entity_type == "PRODUCT") %>%
  group_by(entity_type) %>%
  count(entity) %>%
  top_n(10) %>%
  ggplot(aes(x = entity, y = n)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

consolidated_parsed <- entity_consolidate(full_parsed) 

consolidated_parsed %>%
  group_by(pos) %>%
  filter(entity_type != "")
  count(lemma) %>%
  top_n(10)

#######################Uses openNLP###########################################

#Code found in https://www.youtube.com/watch?v=0lpQludiI-0
reviews <- as.String(reviews_tidy$text[1:50])
sentence_ann <- Maxent_Sent_Token_Annotator()
word_ann <- Maxent_Word_Token_Annotator()
pos_ann <- Maxent_POS_Tag_Annotator()
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")
date_ann <- Maxent_Entity_Annotator(kind = "date")

annotators <- list(sentence_ann,
                   word_ann,
                   pos_ann,
                   person_ann,
                   location_ann,
                   organization_ann,
                   date_ann)
reviews_annotations <- annotate(reviews, annotators)
reviews_doc <- AnnotatedPlainTextDocument(reviews, reviews_annotations)

#Code found in https://rpubs.com/sreekashyapa/indassign1_task2_sreekashyap_addanki
k <- sapply(reviews_annotations$features, `[[`, "kind")
reviews_locations <- reviews[reviews_annotations[k == "location"]]
reviews_people <- reviews[reviews_annotations[k == "person"]]
reviews_organizations <- reviews[reviews_annotations[k == "organization"]]
reviews_date <- reviews[reviews_annotations[k == "date"]]
reviews_locations
reviews_people
reviews_organizations
reviews_date
