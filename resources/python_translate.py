# Install the R package `reticulate` in RStudio
# Install Anaconda Python on your machine
#
# Run a Python from a .py file within RStudio 
# and it just KNOWS what to do 
from translate import Translator
translator= Translator(from_lang="german",to_lang="spanish")
translation = translator.translate("Guten Morgen")
print(translation)
