
# -------------- #
#  Bioconductor  #
# -------------- #

# Install core packages "BiocManager" and "BiocVersion"
if (!require("BiocManager", quietly = TRUE))
	install.packages("BiocManager")
BiocManager::install()

# Base Bioconductor Packages
BP_level_1 <- c(
  "Biobase",
  "MatrixGenerics", # Summary Statistics for  Matrix-Like Objects - rowMedians()
  "preprocessCore",# Normalization by Quantile-Quantile Algorithm
  "limma", # Empirical Bayes Method for Differential Expression
  "RankProd", # Rank Product Method for Differential Expression
  "genefilter") # Expression Gene Filtering

# Advanced Bioconductor Packages
BP_level_2 <- c(
  "PCAtools", # Principal Component Analysis
  "GEOquery",
  "EnhancedVolcano", # Volcano Plots
  "affy",
  "oligo",
  "affycoretools")

# Specific-purpose Bioconductor Packages
BP_level_3 <- c(
  "AnnotationDbi",
  "hgu133a.db",
  "hgu133b.db",
  "hgu133plus2.db",
  "hugene10sttranscriptcluster.db",
  "HsAgilentDesign026652.db")


# ------ #
#  CRAN  #
# ------ #

# From CRAN repository

CP_level_1 <- c(
  "car", # VIF and factorial ANOVA using Type III Sums of Squares
  "rafalib", # Bland Altman Plots (aka MA Plots)
  "VennDiagram", # Venn Diagrams
  "openxlsx", # Reading, Writing, and Editing of .xlsx (Excel) Files
  "gplots", # Heatmap with extensions - heatmap.2()
  "ggplot2",
  "RColorBrewer")     # Color Palette for R

CP_level_2 <- c(
  "tidyverse",
  "rgl", # to build 3D charts - plot3d(), play3d()
  "magick", # for advanced image processing - scatter3d()
  "devtools", # for R package developing
  "roxygen2",
  "testthat",
  "knitr",
  "svDialogs") # Dialog Boxes for Windows and Linuxes

CP_level_3 <- c()





# Build Bioconductor and CRAN Package Lists (BPL and CPL)
if (lev == 1) {
  BPL <- BP_level_1
  CPL <- CP_level_1
} else if (lev == 2) {
  BPL <- c(BP_level_1, BP_level_2)
  CPL <- c(CP_level_1, CP_level_2)
} else if (lev == 3) {
  BPL <- c(BP_level_1, BP_level_2, BP_level_3)
  CPL <- c(CP_level_1, CP_level_2, CP_level_3)
} else {
  stop("Invalid `level` value")
}

# Install Bioconductor packages
BiocManager::install(BPL)
install.packages(CPL)
