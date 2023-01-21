# >-----------------<
#  Type_R Collection
# >-----------------<
# Collection of prototype scripts in R performing a single, simple task 
# //FeAR// Jan-2023
#
# Custom Presets for Enhanced MA-Plots
#
# Refs:
# https://rpkgs.datanovia.com/ggpubr
# The 'ggpubr' package provides some easy-to-use functions for creating and
# customizing 'ggplot2'-based publication ready plots.
#





library(ggpubr)


# Load example data set...
# data(diff_express) # Data sets in package 'ggpubr'

# ...or load real data from the wd
script_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(script_dir)
DEfull_acute <- read.delim(paste0(script_dir,"/DEfull_acute.txt"),
                           sep = "\t", header = TRUE)
DEfull_selected <- read.delim(paste0(script_dir,"/DEfull_selected.txt"),
                              sep = "\t", header = TRUE)

head(DEfull_acute)
head(DEfull_selected)

# Adjust matrix header
colnames(DEfull_acute) <- c("GeneSymbol", "Ensembl_ID",
                            colnames(DEfull_acute)[2:7])
colnames(DEfull_selected) <- c("GeneSymbol", "Ensembl_ID",
                               colnames(DEfull_selected)[2:7])

head(DEfull_acute)
head(DEfull_selected)


# MA-Plot Acute vs Ctrl
# use: top = 0, label.select = c("gene_name1", "gene_name2")) to select specific
# genes to show
label_acute <- c("GBP3",
                 "PXDN",
                 "GUCY1A2",
                 "PRICKLE1",
                 "ATG9B",
                 "APOL1")
label_selected <- c("CASP1",
                    "TRIM2",
                    "IFI27",
                    "BMP7",
                    "IL32",
                    "AREG",
                    "ADGRF1",
                    "TNIK",
                    "ANK3")

ggmaplot(DEfull_acute,
         main = "Acute vs Ctrl",
         xlab = expression(paste(log[2], "(mean counts+1)", sep = "")),
         ylab = expression(paste(log[2], "FC", sep = "")), # subscripting
         fdr = 0.05,
         fc = 2,
         palette = c("#1465AC", "#B31B21", "darkgray"),
         size = 0.8,
         alpha = 0.5,
         genenames = as.vector(DEfull_acute$GeneSymbol),
         legend = "top",
         top = 10,
         #label.select = label_acute,
         font.label = c("bold", 11),
         label.rectangle = FALSE,
         font.legend = "bold",
         font.main = "bold",
         ggtheme = ggplot2::theme_bw())

        # See ggplot2 official themes:
        #   theme_minimal()
        #   theme_bw()
        #   theme_gray()
        #   theme_classic()
        #   theme_void()

dev.print(device = png, filename = "MA-Plot_acute.png",
          width = 800, height = 600)
dev.print(device = pdf, "MA-Plot_acute.pdf")

# MA-Plot Selected vs Ctrl
ggmaplot(DEfull_selected,
         main = "Selected vs Ctrl",
         xlab = expression(paste(log[2], "(mean counts+1)", sep = "")),
         ylab = expression(paste(log[2], "FC", sep = "")),
         fdr = 0.05,
         fc = 2,
         palette = c("#1465AC", "#B31B21", "darkgray"),
         size = 0.8,
         alpha = 0.5,
         genenames = as.vector(DEfull_selected$GeneSymbol),
         legend = "top",
         top = 10,
         #label.select = label_selected,
         font.label = c("bold", 11),
         label.rectangle = FALSE,
         font.legend = "bold",
         font.main = "bold",
         ggtheme = ggplot2::theme_bw())

dev.print(device = png, filename = "MA-Plot_selected.png",
          width = 800, height = 600)
dev.print(device = pdf, "MA-Plot_selected.pdf")



