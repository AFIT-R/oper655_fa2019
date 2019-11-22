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
               widyr,
               textdata,
               tidyr,
               topicmodels)

pacman::p_load_gh("dgrtwo/drlib",
                  "trinker/termco", 
                  "trinker/coreNLPsetup",        
                  "trinker/tagger")

####################################
#             Data Prep            #
####################################

#Load Dataset
root <- rprojroot::find_root(rprojroot::is_rstudio_project)
root <- file.path(root, "student_project_folders", "oper655_fa2019_spangler", "Project", "Texas Last Statement - CSV.csv")
data <- readr::read_csv(root)

#Creates Years in Prison Variable
data$Years_in_Prison <- data$Age - data$AgeWhenReceived
#Initialize Age Bins
#data$Age20_29 <- 0
#data$Age30_39 <- 0
#data$Age40_49 <- 0
#data$Age50_59 <- 0
#data$Age60_69 <- 0
data$Age2 <- 0
#Bin Age Groups
for (i in 1:length(data$Age)){
  if ((data$Age[i] >= 20)&(data$Age[i] < 30)){
    #data$Age20_29[i] = 1
    data$Age2[i] = "20-29"
  }
  if ((data$Age[i] >= 30)&(data$Age[i] < 40)){
    #data$Age30_39[i] = 1
    data$Age2[i] = "30-39"
  }
  if ((data$Age[i] >= 40)&(data$Age[i] < 50)){
    #data$Age40_49[i] = 1
    data$Age2[i] = "40-49"
  }
  if ((data$Age[i] >= 50)&(data$Age[i] < 60)){
    #data$Age50_59[i] = 1
    data$Age2[i] = "50-59"
   }
  if ((data$Age[i] >= 60)&(data$Age[i] < 70)){
    #data$Age60_69[i] = 1
    data$Age2[i] = "60-69"
  }
}

#Initialize Years in Prison Bins
data$Years_in_Prison2 <- 0

for (i in 1:length(data$Years_in_Prison)){
  if(is.na(data$Years_in_Prison[i])){
    next
  } 
  if (data$Years_in_Prison[i] <= 5){
      data$Years_in_Prison2[i] = "0-5"
  }
  if((data$Years_in_Prison[i] >5)&(data$Years_in_Prison[i] <= 10)){
    data$Years_in_Prison2[i] = "6-10"
  }
  if ((data$Years_in_Prison[i] > 10)&(data$Years_in_Prison[i] <= 15)){
    data$Years_in_Prison2[i] = "11-15"
  }
  if ((data$Years_in_Prison[i] >15) & (data$Years_in_Prison[i] <= 20)){
    data$Years_in_Prison2[i] = "16-20"
  }
  if((data$Years_in_Prison[i]>20)&(data$Years_in_Prison[i] <= 25)){
    data$Years_in_Prison2[i] = "21-25"
  }
  if((data$Years_in_Prison[i] > 25)&(data$Years_in_Prison[i] <= 30)){
    data$Years_in_Prison2 = "26-30"
  }
  if((data$Years_in_Prison[i] > 30)){
    data$Years_in_Prison2[i] = "30+"
  }
}

for (i in 1:length(data$Years_in_Prison)){
  if(is.na(data$Years_in_Prison[i])){
    data$Years_in_Prison2[i] = "Not Available"
  }
}

for (i in 1:length(data$NumberVictim)){
  if(is.na(data$NumberVictim[i])){
    data$NumberVictim[i] = "Not Available"
  }
}


#Removes NAs from all cells and replaces with Not Available
for (i in 1:length(data$Age)){
  for (j in 1:23){
    if (is.na(data[i,j])){
      data[i,j] = "Not Available"
    }
  }
}
View(data)


  

#Distribution of Convictions among Independent Vars
data %>%
  count(CountyOfConviction, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = CountyOfConviction, n))+
  geom_bar(stat = "identity") +
  xlab("County of Conviction") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by County") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90))

data %>%
  count(Age2, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = Age2, n))+
  geom_bar(stat = "identity") +
  xlab("Age") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by Age") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90))

data %>%
  count(Years_in_Prison2, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = Years_in_Prison2, n))+
  geom_bar(stat = "identity") +
  xlab("Years in Prison") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by Years in Prison") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90)) +
  scale_x_discrete(name = "Years in Prison",
                   limits = c("0-5", "6-10", "11-15", "16-20", "21-25", "30+", "Not Available"))

data %>%
  count(Race, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = Race, n))+
  geom_bar(stat = "identity") +
  xlab("Race") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by Race") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90))

data %>%
  count(EducationLevel, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = EducationLevel, n))+
  geom_bar(stat = "identity") +
  xlab("Education Level") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by Education Level") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90)) +
  scale_x_discrete(name = "Education Level",
                   limits = c("0", "3", "4", "5", "6", "7",
                              "8", "9", "10", "11", "12", 
                              "13", "14", "16", "Not Available"))
data %>%
  count(NumberVictim, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = NumberVictim, n))+
  geom_bar(stat = "identity") +
  xlab("Number Victim") +
  ylab("Number of Convictions") +
  labs(title = "Number of Death Penalty Convictions by Number Victim") +
  theme(plot.title = element_text(hjust = .5)) +
  theme(axis.text = element_text(angle = 90)) +
  scale_x_discrete(name = "Number Victim",
                  limits = c("0", "1", "2", "3", "4", "5", "6", "Not Available"))
                            

##############################################
#        Word Counts By Groupings            #
##############################################

#Unnest words and count Total Words
data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Words", y = "Count", x = "Word") +
  coord_flip()

#Unnest Trigram and Count (NA is no last statement)
data %>%
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(trigram, -n), y = n)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Trigrams", x = "Trigram", y = "Count") +
  theme(axis.text = element_text(angle = 90)) 
        
#Unnest Words/Trigrams and groups by Race
data %>% 
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  group_by(Race) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = word, y = n, fill = Race)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Race, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

data %>% 
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  filter(Race != "Other") %>%
  group_by(Race) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = trigram, y = n, fill = Race)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Race, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

#Groups by Age
data %>% 
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  group_by(Age2) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = word, y = n, fill = Age2)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Age2, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

data %>% 
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  group_by(Age2) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = reorder(trigram, n), y = n, fill = Age2)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Age2, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

#Groups by Ed Level
data %>% 
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  group_by(EducationLevel) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = word, y = n, fill = EducationLevel)) +
  geom_bar(stat = "identity") +
  facet_wrap(~EducationLevel, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

data %>% 
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  filter(EducationLevel > 5 & EducationLevel < 14) %>%
  group_by(EducationLevel) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = trigram, y = n, fill = EducationLevel)) +
  geom_bar(stat = "identity") +
  facet_wrap(~EducationLevel, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

#Groups by Years in Prison Bins
data %>% 
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  group_by(Years_in_Prison2) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = word, y = n, fill = Years_in_Prison2)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Years_in_Prison2, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

data %>% 
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  filter(Years_in_Prison2 != "30+" & Years_in_Prison2 != "Not Available") %>%
  group_by(Years_in_Prison2) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = trigram, y = n, fill = Years_in_Prison2)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Years_in_Prison2, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

#Groups by NumberVictim
data %>% 
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  group_by(NumberVictim) %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = word, y = n, fill = NumberVictim)) +
  geom_bar(stat = "identity") +
  facet_wrap(~NumberVictim, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

data %>% 
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  filter(NumberVictim >=1 & NumberVictim<= 4) %>%
  group_by(NumberVictim) %>%
  count(trigram, sort = TRUE) %>%
  top_n(10) %>%
  ungroup() %>%
  ggplot(aes(x = trigram, y = n, fill = NumberVictim)) +
  geom_bar(stat = "identity") +
  facet_wrap(~NumberVictim, scales = "free_y") +
  labs(x = NULL, y = "Frequency") +
  coord_flip() +
  theme(legend.position = "none")

#################################################################
#                     Word Frequencies                          #
#################################################################

#Determine Percent of Word Use across all races
race_pct <- 
  data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(word) %>%
  transmute(word, all_words = n/sum(n))

frequency <- 
  data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(Race, word) %>%
  mutate(race_word = n/sum(n)) %>%
  left_join(race_pct) %>%
  arrange(desc(race_word)) %>%
  ungroup()

ggplot(frequency,
       aes(x = race_word,
           y = all_words,
           color = abs(all_words - race_word))) + 
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = .1, size = 2.5, width = .3, height = .3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) +
  scale_color_gradient(limits = c(0,.001),
                       low = "darkslategray4",
                       high = "gray75") +
  facet_wrap(~Race, ncol = 2) +
  theme(legend.position = "none")
  labs(y = "Race Word Frequency", x= NULL)
                
data_pct <- 
  data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(word) %>%
  transmute(word, all_words = n/sum(n)) %>%
  arrange(desc(all_words))

trigram_freq <- data %>%
  unnest_tokens(trigram, LastStatement, token = "ngrams", n = 3) %>%
  count(trigram) %>%
  transmute(trigram, all_trigram = n/sum(n)) %>%
  arrange(desc(all_trigram))

trigram_freq %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(trigram, -all_trigram), y = all_trigram)) +
  geom_bar(stat = "identity") +
  labs(title = "Trigram Frequency", x = "Trigram", y = "Frequency")+
  theme(axis.text = element_text(angle = 90)) 


data_pct %>%
  top_n(10) %>%
ggplot(aes(x = reorder(word, all_words), y = all_words)) +
  geom_bar(stat = "identity") +
  labs(title = "Word Frequency", x = "Word", y = "Frequency") +
  coord_flip()

data %>%
    unnest_tokens(word, LastStatement) %>%
    anti_join(stop_words) %>%
    count(EducationLevel, word) %>%
    mutate(Ed_word = n/sum(n)) %>%
    left_join(data_pct) %>%
    arrange(desc(Ed_word)) %>%
    ungroup() 

data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(Age2, word) %>%
  mutate(Age_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(Age_word)) %>%
  ungroup()

data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(NumberVictim, word) %>%
  mutate(NumVic_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(NumVic_word)) %>%
  ungroup()

#TFIDF
data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(Race, word) %>%
  mutate(Race_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(Race_word)) %>%
  ungroup() %>%
  bind_tf_idf(word, Race, n) %>%
  arrange(desc(tf_idf))

data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(Age2, word) %>%
  mutate(Age2_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(Age2_word)) %>%
  ungroup() %>%
  bind_tf_idf(word, Age2, n) %>%
  arrange(desc(tf_idf))

data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(Years_in_Prison2, word) %>%
  mutate(YearsinPrison_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(YearsinPrison_word)) %>%
  ungroup() %>%
  bind_tf_idf(word, Years_in_Prison2, n) %>%
  arrange(desc(tf_idf))

data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(EducationLevel, word) %>%
  mutate(EdLevel_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(EdLevel_word)) %>%
  ungroup() %>%
  bind_tf_idf(word, EducationLevel, n) %>%
  arrange(desc(tf_idf))
  
data %>%
  unnest_tokens(word, LastStatement) %>%
  anti_join(stop_words) %>%
  count(NumberVictim, word) %>%
  mutate(NumVic_word = n/sum(n)) %>%
  left_join(data_pct) %>%
  arrange(desc(NumVic_word)) %>%
  ungroup() %>%
  bind_tf_idf(word, NumberVictim, n) %>%
  arrange(desc(tf_idf))


##############################################
#                  Topic Modeling            #
##############################################
unnesteddata <- data %>%
  unnest_tokens(words, LastStatement)
dfm_data <- unnesteddata %>%
  tidytext::cast_dfm(LastStatment)
