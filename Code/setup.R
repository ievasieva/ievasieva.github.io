## @knitr setup
install.packages("install.load")
library(install.load)
# List of packages required for this analysis
pkg <- c("corrr", "readr", "tidyr", "devtools", "dplyr", 
         "plyr", "tidyselect", "e1071", "purrr", "FactoMineR", 
         "psy", "psych", "GPArotation", "tibble", 
         "boot", "ltm", "xtable", "kableExtra", 
         "sem", "lavaan", "irr", 
         "QCA", "SetMethods", 
         "corrplot", "ggpubr", "mclust", 
         "ggplot2", "venn", "Hmisc", "janitor", 
         "DiagrammeR", "rsvg", "htmlwidgets", "DiagrammeRsvg", 
         "knitr", "rmarkdown")
install_load(pkg)

## @knitr readfull
bots<- botsread("bots_renamed")

## @knitr readanonymous
bots<- botsread("bots_renamed_anon")

## @knitr readsurveyvars
surveyvariables<- botsread("surveyvariables")
