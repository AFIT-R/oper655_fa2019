#RegEx Practice
pacman::p_load(pdftools,     # extract content from PDF documents
               XML,          # Working with XML formatted data
               here,         # References for file paths
               countrycode,  # Working with names of countries
               tibble,       # Creating and manipulating tibbles
               qdap,
               stringr) 

list <- ("Lt Aaron C. Giddings (aaron.giddings@afit.edu),
         Capt Brandon J. Hufstetler (brandon.hufstetler@afit.edu),
         2 Lt Trey S. Pujats (trey.pujats@afit.edu), 
         2 Lt Maria N. Schroeder (maria.schroeder@afit.edu),
         Capt Tyler M. Spangler (tyler.spangler@afit.edu),
         2 Lt Maxwell C. Thompson (maxwell.thompson@afit.edu),
         1 Lt Clarence O. Williams, III (clarence.williams@afit.edu)")
email_list <- regmatches(list, 
                  gregexpr("([_a-z0-9]+\\S.?[_a-z0-9]+@{1}[a-z]+.{1}[a-z]{2,4})", list))
email_list <- unlist(email_list)
