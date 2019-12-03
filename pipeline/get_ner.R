get_ner <- function(text,...){
  
  spacyr::spacy_initialize(model = "en_core_web_sm")

  ner <- spacyr::spacy_parse(text,...)

  spacyr::spacy_finalize()
  
  return(ner)
  
}


get_ner2 <- function(text,...){
  
  string <- NLP::as.String(text)

  token_annotator_sent <- openNLP::Maxent_Sent_Token_Annotator()
  token_annotator_word <- openNLP::Maxent_Word_Token_Annotator()
  
  # these next six allow for extraction of the specific entity types
  entity_annotator_ppls <- openNLP::Maxent_Entity_Annotator(kind = "person")
  entity_annotator_orgs <- openNLP::Maxent_Entity_Annotator(kind = "organization")
  entity_annotator_mone <- openNLP::Maxent_Entity_Annotator(kind = "money")
  entity_annotator_loca <- openNLP::Maxent_Entity_Annotator(kind = "location")
  entity_annotator_perc <- openNLP::Maxent_Entity_Annotator(kind = "percentage")
  entity_annotator_date <- openNLP::Maxent_Entity_Annotator(kind = "date")

  # we can now bundle them into one list
  annotators_all <- list(entity_annotator_ppls,
                         entity_annotator_orgs,
                         entity_annotator_mone,
                         entity_annotator_loca,
                         entity_annotator_perc,
                         entity_annotator_date)
  
  tokenized_string <- NLP::annotate(string, 
                                    list(token_annotator_sent,
                                         token_annotator_word))
  
  entity_annotations <- NLP::annotate(string,
                                      annotators_all,
                                      tokenized_string)
  
  entity_annotations2 <-
    NLP::AnnotatedPlainTextDocument(string, entity_annotations)
  
    text_content <- entity_annotations2$content
    annotation_data <- NLP::annotation(entity_annotations2)
    
    kinds <- sapply(annotation_data$features, `[[`, "kind")
    
    DF <- data.frame(kind = character(),
                     entity = character(),
                     stringsAsFactors = F)
    
    for(i in unlist(kinds)){
      
        entities <-  text_content[NLP::annotations_in_spans(entity_annotations[kinds == i],
                                                            entity_annotations[entity_annotations$type == "sentence"])]
        
        ent <- as.character(entities)
        
        df <- data.frame(kind = i,
                         entity = unlist(entities[entities != "character(0)"]),
                         stringsAsFactors = F)
        
        DF <- rbind(DF,df)
        
      
    }
    
    
    return(DF)
  
  
}