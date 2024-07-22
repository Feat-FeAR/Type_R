# TO ADD:
# download user manual PDFs locally
# check the installed packages (comparison with BPL e CPL)


# -------------- #
#  Bioconductor  #
# -------------- #

# Install core packages "BiocManager" and "BiocVersion"
if (!require("BiocManager", quietly = TRUE))
	install.packages("BiocManager")
BiocManager::install()

# Base Bioconductor Packages
BP_level_1 <- c(
  "Biobase", # Base Functions for Bioconductor
  "MatrixGenerics", # Summary Statistics for Matrix-Like Objects - rowMedians()
  "preprocessCore",# Normalization by Quantile-Quantile Algorithm
  "limma", # Empirical Bayes Method for Differential Expression Analysis
  "RankProd", # Rank Product Method for Differential Expression Analysis
  "DESeq2", # Differential Expression Analysis by Negative Binomial Distribution
  "genefilter", # Gene Expression Filtering
  "futile.logger", # Logging Utility for R
  "VennDiagram" # High-Resolution Venn and Euler Plots
  )

# Advanced Bioconductor Packages
BP_level_2 <- c(
  "PCAtools", # Principal Component Analysis
  "GEOquery",
  "EnhancedVolcano", # Volcano plots with enhanced coloring and labeling
  "affy", # Preprocessing tools for older Affymetrix oligonucleotide arrays (3' IVT)
  "oligo", # Preprocessing tools for newer Affymetrix oligonucleotide arrays (GeneChip/Exo + popular old platforms)
  "affycoretools",
  "clusterProfiler", # Package for ORA and GSEA in R
  "enrichplot", # Plot ORA and GSEA results
  "pathview" # Download KEGG enrichment path locally
  )

# Special-purpose Bioconductor Packages (annotation Data Bases packages <*.db>)
BP_level_3 <- c(
  "AnnotationDbi",
  "org.Hs.eg.db",
  "org.Mm.eg.db",
  "hgu133a.db",
  "hgu133b.db",
  "hgu133plus2.db",
  "hugene10sttranscriptcluster.db",
  "HsAgilentDesign026652.db"
  )

# These packages (Affymetrix Platform Design Packages <pd.*>) should be
# installed and loaded automatically when calling read.celfiles() function from
# the 'oligo' package:
#
# "pd.hg.u133a" # Platform Design Info for The Manufacturer's Name HG-U133A
# "pd.hg.u133b" # Platform Design Info for The Manufacturer's Name HG-U133B
# "pd.hg.u133.plus.2" # Platform Design Info for HG-U133 Plus 2.0
# "pd.hugene.1.0.st.v1" # Platform Design Info for Affymetrix HuGene-1_0-st-v1




# ------ #
#  CRAN  #
# ------ #

# From CRAN repository

CP_level_1 <- c(
  "car", # VIF and factorial ANOVA using Type III Sums of Squares
  "rafalib", # Bland Altman Plots (aka MA Plots)
  "VennDiagram", # High-Resolution Venn and Euler Plots
  "openxlsx", # Reading, Writing, and Editing of .xlsx (Excel) Files
  "gplots", # Heatmap with extensions - heatmap.2()
  "ggplot2", # Creating graphics based on The Grammar of Graphics
  "reshape2", # Flexibly Reshape Data: A Reboot of the Reshape Package
  "RColorBrewer",     # Color Palette for R
  "RSQLite" # SQLite interface for R
  )

CP_level_2 <- c(
  "tools",
  "stringr",
  "plyr", # Tools for Splitting, Applying and Combining Data
  "dplyr", # Data frames manipulation tools
  "googledrive", # Access Google Drive from R (from the tidyverse)
  "rgl", # to build 3D charts - plot3d(), play3d()
  "magick", # for advanced image processing - scatter3d()
  "devtools", # for R package developing
  "roxygen2",
  "testthat",
  "knitr",
  "svDialogs", # Dialog Boxes for Windows and Linuxes
  "ggnewscale",
  "mclust", # Gaussian Mixture Modelling for Model-Based Clustering
  "BWStest" # Baumgartner-Weiss-Schindler Test of Equal Distributions
  )


CP_level_3 <- c(
  "tidyverse" # the entire tidyverse - R packages for data science
  )





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

# Install packages
BiocManager::install(BPL)
install.packages(CPL)



# -------- #
#  GitHub  #
# -------- #
if (lev >= 2) {
  devtools::install_github("TCP-Lab/r4tcpl")
}
