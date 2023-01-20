# >-----------------<
#  Type_R Collection
# >-----------------<
# Collection of prototype scripts in R performing a single, simple task 
# //FeAR// Jan-2023
#
# Custom Presets for Enhanced Heatmaps
#





# Package Loading --------------------------------------------------------------
# Load required packages and source external scripts

library(gplots)           # Heatmap with extensions - heatmap.2()
#library(ggplot2)          # Charts with Jitter (already loaded by PCAtools)
library(RColorBrewer)     # Color Palette for R





# Set i/o Paths --------------------------------------------------------------------

# WARNING: This way of sourcing only works within RStudio !!
wd <- dirname(rstudioapi::getSourceEditorContext()$path)

# Collection of custom functions
source(file.path(wd, "STALKER_Functions.R", fsep = .Platform$file.sep))

# Desktop local path
local_desk <- paste(Sys.getenv("USERPROFILE"), "Desktop",
                    sep = .Platform$file.sep)





# Data Loading -----------------------------------------------------------------


# Load a test expression matrix of DEGs from my Rheumatoid Arthritis microarray
# study. Etanercept (anti-TNFa) vs Methotrexate (MTX) contrast.
load(paste0(wd, "/TypeR_DataSets.RData"), verbose = TRUE)
gene_labels <- DEGsExpr_ETAvsMTX[,1]
data_set <- DEGsExpr_ETAvsMTX[,4:14]

# [[[ OR ]]]

# Browse local file system for a tab-separated-value log2-expression matrix
# You can either start from a statistically significant DEG set or a "full DEA"
# result table, since the script also implements a subsetting step.
myFile <- rstudioapi::selectFile(caption = "Select your Expression Matrix",
                                 label = "Select",
                                 path = local_desk,
                                 filter = "All Files (*)",
                                 existing = TRUE)
data_set <- read.table(myFile, header = FALSE, sep = "\t", dec = ".")


d <- show.data(data_set, cols = Inf)

# Extract column headings (sample identifiers)
header  = read.table(myFile, nrows = 1, header = FALSE, sep = "\t",
                     stringsAsFactors = FALSE)
data_set = read.table(myFile, skip = 1, header = FALSE, sep = "\t",
                     dec = ".")
colnames(data_set) = unlist(header)
head(data_set)
d = dim(data_set)
d

# Extract row names (gene identifiers)
rownames(data_set) = data_set[,1]
data_set = data_set[,2:d[2]]
header  = header[,2:d[2]]
head(data_set)
d = dim(data_set)
d




# Prepare Matrix ---------------------------------------------------------------

# heatmap.2() function takes a matrix (not a dataframe!) as input!
data_set.toHeat <- as.matrix(data_set)

# Gene-wise median-centering log2(expression)
data.medians <- apply(data_set.toHeat, 1, median, na.rm = TRUE)
data_set.toHeat <- sweep(data_set.toHeat,
                         MARGIN = 1,
                         STATS = data.medians)

# Set limits for color scale
# ETA vs MTX
bounds <- quantile(data_set.toHeat, c(0.05, 0.85))




# Clipping Stats
up.sat <- sum(data_set.toHeat > bounds[2])
down.sat <- sum(data_set.toHeat < bounds[1])
tot.entries <- ncol(data_set.toHeat) * nrow(data_set.toHeat)
cat("\n", up.sat, " out of ", tot.entries, " (",
    round((up.sat/tot.entries)*100, digits = 2),
    "%) entries upward saturating will be clipped\n\n", sep = "")
cat("\n", down.sat, " out of ", tot.entries, " (",
    round((down.sat/tot.entries)*100, digits = 2),
    "%) entries downward saturating will be clipped\n\n", sep = "")

# Clip
data_set.toHeat[data_set.toHeat > bounds[2]] <- bounds[2]
data_set.toHeat[data_set.toHeat < bounds[1]] <- bounds[1]




# Define Color Palettes --------------------------------------------------------
display.brewer.all()
# Palette Definition
#
# Some Double-gradient LUTs (list for quick-pick)
#   RdYlGn
#   RdYlBu
#   RdBu
#   BrBG
#   Spectral
#   PRGn
#
# Some Qualitative palettes (list for quick-pick)
#   Set1
#   Set2
#   Set3
#   Dark2
#
# colorRampPalette returns a function (!) that takes an integer argument
lvls = 51 # color levels (Better be odd)
mainLUT = colorRampPalette(brewer.pal(8, "RdBu"))(lvls)
# upregulated genes are normally marked red and downregulated genes blue
mainLUT <- rev(mainLUT)
qualLUT = brewer.pal(12, "Set3")

# Side-marking for categories of interest
e.struct = vector(mode = "character", length = d[1])
e.struct[1:d[1]] <- "#FFFFFF"  # All white, except... see below


# Define Gene sets -------------------------------------------------------------

  
  # Inflammation, Immune Response, and Metallopeptidase
  e.struct[which(DEGsExpr_ETAvsMTX[,3] == "Inflammation")] <- qualLUT[10]
  e.struct[which(DEGsExpr_ETAvsMTX[,3] == "Immune Response")] <- qualLUT[11]
  e.struct[which(DEGsExpr_ETAvsMTX[,3] == "Metallopeptidase")] <- qualLUT[5]


# Side bar stats
hg <- sum(e.struct != "#FFFFFF")
cat("\n", hg, " highlighted genes\n\n", sep = "")




# Heatmap ----------------------------------------------------------------------

# Plot the heatmap
heatmap.2(data_set.toHeat,
          scale = "row",
          col = mainLUT, RowSideColors = e.struct,
          trace = "none", # Get rid of trace lines
         density.info = "histogram",
         # lhei = c(2,8), lwid = c(2,4), # Control the aspect-ratio of the 4 subplots
          srtCol = 45, margins = c(7, 7), # Control label rotation and margins
          Colv = FALSE, Rowv = FALSE, dendrogram = "none")

# Save as .tiff
dev.print(device = tiff, filename = "Heatmap.tiff",
          width = 900, height = 4*d[1] + 300)



