String<-"Lt Aaron C. Giddings (aaron.giddings@afit.edu), Capt Brandon J. Hufstetler (brandon.hufstetler@afit.edu), 2 Lt Trey S. Pujats (trey.pujats@afit.edu), 2 Lt Maria N. Schroeder (maria.schroeder@afit.edu), Capt Tyler M. Spangler (tyler.spangler@afit.edu), 2 Lt Maxwell C. Thompson (maxwell.thompson@afit.edu), 1 Lt Clarence O. Williams, III (clarence.williams@afit.edu)"
str_extract_all(String,  "(?<=\\().+?(?=\\))")

#   '?<=\\(' Looks behind for open parenthesis saying it will only be matched once at most