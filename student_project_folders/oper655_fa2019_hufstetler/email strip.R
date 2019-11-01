#install.packages('pacman')
pacman::p_load(pdftools,
               XML,
               here,
               countrycode,
               tibble,
               qdap,
               stringr,
               BiocManager)

pacman::p_load_gh("VerbalExpressions/RVerbalExpressions")

list <- "Lt Aaron C. Giddings (aaron.giddings@afit.edu), Capt Brandon J. Hufstetler (brandon.hufstetler@afit.edu), 2 Lt Trey S. Pujats (trey.pujats@afit.edu), 2 Lt Maria N. Schroeder (maria.schroeder@afit.edu), Capt Tyler M. Spangler (tyler.spangler@afit.edu), 2 Lt Maxwell C. Thompson (maxwell.thompson@afit.edu), 1 Lt Clarence O. Williams, III (clarence.williams@afit.edu)"
list.no_p <- gsub("\\(|\\)", replacement = " ", list)
list.split <-strsplit(list.no_p, " ")
grep(pattern = "@", unlist(list.split), value = TRUE)

list <- ("Lt Aaron C. Giddings (aaron.giddings@afit.edu), 
         Capt Brandon J. Hufstetler (brandon.hufstetler@afit.edu), 
         2 Lt Trey S. Pujats (trey.pujats@afit.edu), 
         2 Lt Maria N. Schroeder (maria.schroeder@afit.edu), 
         Capt Tyler M. Spangler (tyler.spangler@afit.edu), 
         2 Lt Maxwell C. Thompson (maxwell.thompson@afit.edu), 
         1 Lt Clarence O. Williams, III (clarence.williams@afit.edu)")
unlist(regmatches(list, gregexpr("([_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4}))", tolower(list))))

(
  [_a-z0-9-]+ # one or more lowercase letters, numbers, _, or -
    (\\.[_a-z0-9-]+)* # zero or more (period followed by lower case letters, numbers, _ or -)
    @ # exactly one @
    [a-z0-9-]+ # one or more lowercase alphanumerics, or -
    (\\.[a-z0-9-]+)* # zero ore more (period followed by lowercase letters, numbers, or -)
    (\\.[a-z]{2,4}) # exactly one period followed by 2-4 lowercase letters
  )



####### cell phone manufacturer strip
pacman::p_load(tidyr,
               tidytext,
               dplyr,
               stringr,
               ggplot2,
               magrittr)

root <- rprojroot::find_root(rprojroot::is_rstudio_project)
file_loc <- file.path(root,"data","phone_user_reviews")

file_list <- list.files(path = file_loc,
                        pattern = "",
                        full.names = TRUE)
reviews_tidy <- tibble::tibble()
for (i in file_list){
  input <- load(i,ex <- new.env())
  text_raw <- get(ls(ex),ex)
  text_en <- text_raw[text_raw$lang=="en",]
  rm(ex, text_raw, input, i)
  
  clean <- tibble::tibble(score = text_en$score,
                          max = text_en$score_max,
                          text = text_en$extract,
                          product = text_en$product,
                          author = text_en$author,
                          manufacturer = case_when(str_detect(product, regex("apple|iphone", ignore_case = T)) ~ "apple",
                                                   str_detect(product, regex("samsung|galaxy", ignore_case = T)) ~ "samsung",
                                                   str_detect(product, regex("sony|erics", ignore_case = T)) ~ "sony",
                                                   str_detect(product, regex("nokia|lumia|6310[a-z]?|2115i|2260|2270|2285", ignore_case = T)) ~ "nokia",
                                                   str_detect(product, regex("phillips|savvy", ignore_case = T)) ~ "phillips",
                                                   str_detect(product, regex("maxon|3204", ignore_case = T)) ~ "maxon",
                                                   str_detect(product, regex("siemens|s45", ignore_case = T)) ~ "siemens",
                                                   str_detect(product, regex("sharp|gx-10", ignore_case = T)) ~ "sharp",
                                                   str_detect(product, regex("cyclops|k3[0-9]{2}", ignore_case = T)) ~ "cyclops",
                                                   str_detect(product, regex("lg|ke820", ignore_case = T)) ~ "lg",
                                                   str_detect(product, regex("kyocera|mako|2135|2235|2255|2325", ignore_case = T)) ~ "kyocera",
                                                   str_detect(product, regex("audiovox|xv[0-9]{4}", ignore_case = T)) ~ "audiovox",
                                                   str_detect(product, regex("huawei|honor|m750|mate|p9", ignore_case = T)) ~ "huawei",
                                                   str_detect(product, regex("motorola|razr", ignore_case = T)) ~ "motorola",
                                                   str_detect(product, regex("lenovo|vibe", ignore_case = T)) ~ "lenovo",
                                                   str_detect(product, regex("oneplus", ignore_case = T)) ~ "oneplus",
                                                   str_detect(product, regex("xiaomi|redmi", ignore_case = T)) ~ "xiaomi",
                                                   str_detect(product, regex("faraday|htc", ignore_case = T)) ~ "htc",
                                                   str_detect(product, regex("asus", ignore_case = T)) ~ "asus",
                                                   str_detect(product, regex("ttfone", ignore_case = T)) ~ "ttfone",
                                                   str_detect(product, regex("doro|phoneeasy", ignore_case = T)) ~ "doro",
                                                   str_detect(product, regex("palm", ignore_case = T)) ~ "palm",
                                                   str_detect(product, regex("hd|ips", ignore_case = T)) ~ "hd",
                                                   str_detect(product, regex("mediatek|mtk", ignore_case = T)) ~ "mediatek",
                                                   str_detect(product, regex("zte|open\\sc|blade", ignore_case = T)) ~ "zte",
                                                   str_detect(product, regex("x6|cubot|gt72|x9", ignore_case = T)) ~ "cubot",
                                                   str_detect(product, regex("doogee|dagger|dg550", ignore_case = T)) ~ "doogee",
                                                   str_detect(product, regex("leagoo|lead\\s[0-9]?", ignore_case = T)) ~ "leagoo",
                                                   str_detect(product, regex("thl", ignore_case = T)) ~ "thl",
                                                   str_detect(product, regex("inew", ignore_case = T)) ~ "inew",
                                                   str_detect(product, regex("nec|232e", ignore_case = T)) ~ "nec",
                                                   str_detect(product, regex("acer", ignore_case = T)) ~ "acer",
                                                   str_detect(product, regex("alcatel", ignore_case = T)) ~ "alcatel",
                                                   str_detect(product, regex("archos", ignore_case = T)) ~ "archos",
                                                   str_detect(product, regex("asus|zenfone", ignore_case = T)) ~ "asus",
                                                   str_detect(product, regex("blackberry", ignore_case = T)) ~ "blackberry",
                                                   str_detect(product, regex("razer", ignore_case = T)) ~ "razer",
                                                   str_detect(product, regex("oppo", ignore_case = T)) ~ "oppo",
                                                   str_detect(product, regex("microsoft", ignore_case = T)) ~ "microsoft",
                                                   str_detect(product, regex("vivo", ignore_case = T)) ~ "vivo",
                                                   str_detect(product, regex("hitachi", ignore_case = T)) ~ "hitachi",
                                                   str_detect(product, regex("blu", ignore_case = T)) ~ "blu",
                                                   str_detect(product, regex("eten", ignore_case = T)) ~ "eten",
                                                   str_detect(product, regex("gionee", ignore_case = T)) ~ "gionee",
                                                   str_detect(product, regex("foxconn", ignore_case = T)) ~ "foxconn",
                                                   str_detect(product, regex("fujitsu", ignore_case = T)) ~ "fujitsu",
                                                   str_detect(product, regex("freedompop", ignore_case = T)) ~ "freedompop",
                                                   str_detect(product, regex("yu|micromax", ignore_case = T)) ~ "micromax",
                                                   str_detect(product, regex("mi\\s", ignore_case = T)) ~ "mi",
                                                   str_detect(product, regex("google", ignore_case = T)) ~ "google",
                                                   str_detect(product, regex("vodafone", ignore_case = T)) ~ "vodafone",
                                                   str_detect(product, regex("swift", ignore_case = T)) ~ "swift",
                                                   str_detect(product, regex("casio", ignore_case = T)) ~ "casio",
                                                   str_detect(product, regex("xolo", ignore_case = T)) ~ "xolo",
                                                   str_detect(product, regex("sanyo", ignore_case = T)) ~ "sanyo",
                                                   str_detect(product, regex("wileyfox", ignore_case = T)) ~ "wileyfox",
                                                   str_detect(product, regex("binatone", ignore_case = T)) ~ "binatone",
                                                   str_detect(product, regex("panasonic", ignore_case = T)) ~ "panasonic",
                                                   str_detect(product, regex("caterpillar", ignore_case = T)) ~ "caterpillar",
                                                   TRUE ~ "other")) %>%
    tidytext::unnest_tokens(word, text)
  reviews_tidy <- base::rbind(reviews_tidy, clean)
  rm(text_en, clean)
}
rm(file_list, root)
# Get Samsung Products
samsungpattern <- "e1200|tracfone|((j|s|note)\\s?([0-9]|10)?\\s)"
samtest <- reviews_tidy[reviews_tidy$manufacturer == "samsung",]
samtest %<>%
  mutate(product = gsub(" ","",str_extract(tolower(samtest$product),samsungpattern)))
table(samtest$product)
sum(table(samtest$product))
reviews_tidy[reviews_tidy$manufacturer == "samsung",] %<>%
  mutate(product = case_when(str_detect(product, regex("e1200", ignore_case = T)) ~ "e1200",
                             str_detect(product, regex("tracfone", ignore_case = T)) ~ "tracfone",
                             str_detect(product, regex("j\\s?2", ignore_case = T)) ~ "j2",
                             str_detect(product, regex("j\\s?3", ignore_case = T)) ~ "j3",
                             str_detect(product, regex("j\\s?5", ignore_case = T)) ~ "j5",
                             str_detect(product, regex("j\\s?7", ignore_case = T)) ~ "j7",
                             str_detect(product, regex("s\\s?2|s\\s?ii", ignore_case = T)) ~ "s2",
                             str_detect(product, regex("s\\s?3|i9300|s\\s?iii|i8190", ignore_case = T)) ~ "s3",
                             str_detect(product, regex("s\\s?4|i9500|s\\s?vi|i337", ignore_case = T)) ~ "s4",
                             str_detect(product, regex("s\\s?5|g900f", ignore_case = T)) ~ "s5",
                             str_detect(product, regex("s\\s?6", ignore_case = T)) ~ "s6",
                             str_detect(product, regex("s\\s?7|g930f", ignore_case = T)) ~ "s7",
                             str_detect(product, regex("s\\s?8", ignore_case = T)) ~ "s8",
                             str_detect(product, regex("note,|i717", ignore_case = T)) ~ "note",
                             str_detect(product, regex("note\\s?2|note\\s?ii", ignore_case = T)) ~ "note2",
                             str_detect(product, regex("note\\s?3", ignore_case = T)) ~ "note3",
                             str_detect(product, regex("note\\s?4", ignore_case = T)) ~ "note4",
                             str_detect(product, regex("note\\s?5", ignore_case = T)) ~ "note5",
                             str_detect(product, regex("note\\s?6", ignore_case = T)) ~ "note6",
                             str_detect(product, regex("note\\s?7", ignore_case = T)) ~ "note7",
                             str_detect(product, regex("note\\s?8", ignore_case = T)) ~ "note8",
                             str_detect(product, regex("note\\s?9", ignore_case = T)) ~ "note9",
                             str_detect(product, regex("note\\s?10", ignore_case = T)) ~ "note10",
                             str_detect(product, regex("galaxy", ignore_case = T)) ~ "galaxy_other",
                             TRUE ~ "other"))
# Get apple Products
iphonepattern <- "iphone\\s?[a-z0-9](gb){0}[a-z]?(\\s?plus)?\\s"
aptest <- reviews_tidy[reviews_tidy$manufacturer == "apple",]
aptest %<>%
  mutate(product = gsub(" ","",str_extract(tolower(aptest$product),iphonepattern)))
table(aptest$product)
reviews_tidy[reviews_tidy$manufacturer == "apple",] %<>%
  mutate(product = str_extract(tolower(appletest$product[1]),iphonepattern))

View(table(reviews_tidy[reviews_tidy$manufacturer == "apple",3]))
sort(table(reviews_tidy[,5]))

reviews_tidy[reviews_tidy$manufacturer == "samsung",] %>%
  unnest_tokens(word, product) %>%
  count(word, sort = T)
View(table(reviews_tidy$product[reviews_tidy$manufacturer == "apple"]))
# Set factor to keep episodes in order
office_tidy$season <- base::factor(office_tidy$season)
office_tidy$subep <- base::factor(office_tidy$subep)


x <- "apple iphone 7s plus new"
regmatches(x,gregexpr("iphone\\s?[a-z0-9][a-z]?(\\s?plus)?", tolower(x)))
