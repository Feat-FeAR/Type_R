# >-----------------<
#  Type_R Collection
# >-----------------<
# Collection of prototype scripts in R performing a single, simple task 
# //FeAR// Jan-2023
#
# Custom Presets for a Gene Ontology (GO) Bar Chart
#
# Refs:
# https://r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html
# ggplot2 coerces discrete axes to factors where the default order is
# alphabetical and/or numerical. To specify a different order you could use the
# forcats library (from the tidyverse) that is especially made to handle factors
# in R. It provides a suite of useful tools that solve common problems with
# factors. The fct_reorder() function allows to reorder the factor
# (term2plot$Name for example) following the value of another column
# (term2plot$q.value.FDR.B.H here).
#


# Script to plot ORA (functional enrichment by hypergeometric test) results
# starting from a ToppFun tab-delimited file
# The following columns must be present:
#   - Category
#   - ID
#   - Name
#   - Source
#   - q.value.FDR.B.H
#

library(forcats)  # from the tidyverse, for factor reordering through fct_reorder()
library(dplyr)    # for desc() function to sort in descending order
library(ggplot2)
library(openxlsx) # Reading, Writing, and Editing of .xlsx (Excel) Files
library(cmatools)

# Load data
# Desktop local path
local.Desktop <- paste0(Sys.getenv("USERPROFILE"), "/Desktop")
terms_file <- rstudioapi::selectFile(caption = "Select a list of terms",
                                     label = "Select",
                                     path = local.Desktop,
                                     filter = "All Files (*)",
                                     existing = TRUE)

if (grep("\\.xlsx?$", terms_file)) {
  terms_table <- read.xlsx(xlsxFile = terms_file, sheet = 1)
} else {
  terms_table <- read.delim(terms_file, sep = "\t", header = TRUE)
}

# Subset by category
term <- list() # create an empty list
term[["GO"]] <- subset(terms_table, grepl("^GO:", Category))
  term[["MF"]] <- subset(terms_table, Category == "GO: Molecular Function")
  term[["BP"]] <- subset(terms_table, Category == "GO: Biological Process")
  term[["CC"]] <- subset(terms_table, Category == "GO: Cellular Component")
term[["DO"]] <- subset(terms_table, Category == "Domain")
term[["PA"]] <- subset(terms_table, Category == "Pathway")
  term[["KE"]] <- subset(terms_table, grepl("KEGG", Source))
term[["TF"]] <- subset(terms_table, Category == "Transcription Factor Binding Site")
term[["FA"]] <- subset(terms_table, Category == "Gene Family")

lms(term)

# Subset by top-q-value
top_term <- term
for (db in names(term)) {
  top <- 10
  top <- min(dim(term[[db]])[1], top) # if entries are less than 'top'
  top_term[[db]] <- top_term[[db]][order(top_term[[db]]$q.value.FDR.B.H),]
  top_term[[db]] <- top_term[[db]][1:top,]
}

# Subset by a given list of terms of interest (TOIs) by ID
toi_MF <- c("GO:0005518",
            "GO:0000217",
            "GO:0062037",
            "GO:0016462")
toi_term <- list()
toi_term[["MF"]] <- term$MF[term$MF$ID %in% toi_MF,]



#-----------------------------------#
# Horizontal bar plot using ggplot2 #
#-----------------------------------#

# Select the terms to plot... here are some possibilities:

term2plot <- terms_table        # all terms (not recommended)
term2plot <- term$KE            # all KEGG pathways (the entire category)
term2plot <- top_term$BP        # the top-10 Biological Processes
term2plot <- rbind(top_term$FA,
                   top_term$DO) # top Gene Families AND top Domains
term2plot <- top_term$GO        # the top-10 GO-terms regardless of their category
term2plot <- rbind(top_term$MF,
                   top_term$BP,
                   top_term$CC) # top-10 MFs AND top-10 BPs AND top-10 CCs
term2plot <- toi_term$MF        # TOIs belonging to MF category



# Alphabetically ordered
ggplot(term2plot,
       aes(x = Name, y = -log10(q.value.FDR.B.H), fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  ggtitle("Functional Enrichment from ToppFun ORA") +
  xlab(NULL) + ylab(expression(-log[10](FDR)))

# q-value ranked
ggplot(term2plot,
       aes(x = fct_reorder(Name, desc(q.value.FDR.B.H)),
           y = -log10(q.value.FDR.B.H),
           fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  ggtitle("Functional Enrichment from ToppFun ORA") +
  xlab(NULL) + ylab(expression(-log[10](FDR)))

# q-value ranked within each Category
# Categories are numerically coded as multiples of 1e4 (i.e., 10000, 20000, ...)
# and provide an offset to separate different ontologies
ggplot(term2plot,
       aes(x = fct_reorder(
         Name, 1e4*as.numeric(as.factor(Category)) - log10(q.value.FDR.B.H)),
           y = -log10(q.value.FDR.B.H),
           fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  ggtitle("Functional Enrichment from ToppFun ORA") +
  xlab(NULL) + ylab(expression(-log[10](FDR)))

# To change bar colors add the following term:
# + scale_fill_manual(values=c("#9933FF",
#                              "#33FFFF",
#                              "red",
#                              "darkblue"))
  
  
  
# ...and using basic R function
#barplot(height = -log10(term2plot$q.value.FDR.B.H),
#        width = 1, space = 0.5, beside = TRUE, horiz = TRUE,
#        names.arg = term2plot$Name)
