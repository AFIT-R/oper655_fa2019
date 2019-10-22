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

