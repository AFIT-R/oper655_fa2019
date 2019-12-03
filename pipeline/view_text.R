#' @importFrom readr write_lines
#' @importFrom rmarkdown render
#' @importFrom utils browseURL
#'
#' @param text The text being viewed as a character vector 
#' @param collapse This argument will be used to set the spacing
#' @param sumsent A character vector of summary sentences from the \code{lexRankr} package
view_text <- function(text, 
                      collapse = "\n",
                      sumsent = NULL, 
                      ner = NULL) {
  
  ner_sub <- function(obj, sub, select, drop = T,space1,space2) {
    
    paste0(space1,subset(obj, kind == sub, select = select, drop = T),space2)
    
  }
  
  css <- character()
  
  if(!missing(sumsent) & !is.null(sumsent) & is.character(sumsent)) {
  
      css <- "<style>
               sumsent { border: green solid 1px;
                         border-radius: 20px;
                         background-color: green;
                         padding: 0.5px 5px;
                         color: white;
                       }
              </style>"
      
     text <- qdap::mgsub(text.var = text,
                         sumsent,
                         paste0("<sumsent>",sumsent,"</sumsent>"))
      
  }
  
  if(!missing(ner) & !is.null(ner)) {
  
      css <- "<style>
               nerorg  { border: black solid 1px;
                         border-radius: 20px;
                         background-color: black;
                         padding: 0.5px 5px;
                         color: white;
               }
               nerpers { border: blue solid 1px;
                         border-radius: 20px;
                         background-color: blue;
                         padding: 0.5px 5px;
                         color: white;
               }
               nerdate { border: red solid 1px;
                         border-radius: 20px;
                         background-color: red;
                         padding: 0.5px 5px;
                         color: white;
               }
               nermon {  border: green solid 1px;
                         border-radius: 20px;
                         background-color: green;
                         padding: 0.5px 5px;
                         color: white;
               }
               nerperc { border: purple solid 1px;
                         border-radius: 20px;
                         background-color: purple;
                         padding: 0.5px 5px;
                         color: white;
               }
               nerloc {  border: orange solid 1px;
                         border-radius: 20px;
                         background-color: orange;
                         padding: 0.5px 5px;
                         color: white;
               }
              </style>"
      
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"organization","entity",T," ","(' '|[.])"),
                         paste0("<nerorg>",ner_sub(ner,"organization","entity",T,"",""),"</nerorg>"),
                         fixed = F)
     
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"person","entity",T," ","(\\s+|[.])"),
                         paste0("<nerpers>",ner_sub(ner,"person","entity",T,"",""),"</nerpers>"),
                         fixed = F)
     
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"location","entity",T," ","(\\s+|[.])"),
                         paste0("<nerloc>", ner_sub(ner,"location","entity",T,"",""),"</nerloc>"),
                         fixed = F)
     
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"date","entity",T," ","(\\s+|[.])"),
                         paste0("<nerdate>",ner_sub(ner,"date","entity",T,"",""),"</nerdate>"),
                         fixed = F)
     
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"money","entity",T," ","(\\s+|[.])"),
                         paste0("<nermon>", ner_sub(ner,"money","entity",T,"",""),"</nermon>"),
                         fixed = F)
     
     text <- qdap::mgsub(text.var = text,
                         ner_sub(ner,"percentage","entity",T," ","(\\s+|[.])"),
                         paste0("<nerperc>",ner_sub(ner,"percentage","entity",T,"",""),"</nerperc>"),
                         fixed = F)
      
  }

  tmp <- tempdir()
  
  file.create(file.path(tmp, "text.Rmd"))
  
  rmd_header <- c("---",
                  "title: 'View Text'",
                  "output: html_document",
                  "---")
  
  Encoding(text) <- "UTF-8"
  
  
  readr::write_lines(x = paste(c(paste(rmd_header,collapse = "\n"),
                                 css,
                                 paste(text, collapse = collapse))),
                     path = file.path(tmp, "text.Rmd"))
  
  rmarkdown::render(file.path(tmp, "text.Rmd"),
                    output_dir = tmp,
                    encoding = "UTF-8")
  
  browseURL(file.path(tmp, "text.html"))
  
  
}