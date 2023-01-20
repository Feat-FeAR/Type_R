# >-----------------<
#  Type_R Collection
# >-----------------<
# Collection of prototype scripts in R performing a single, simple task 
# //FeAR// Jan-2023
#
# Custom Presets for Enhanced Pair Plots
#
# Refs:
# http://www.sthda.com/english/wiki/scatter-plot-matrices-r-base-graphs
# http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
#





# Global Parameters ------------------------------------------------------------

p_shape <- 19 # Point shape (it can be a vector of different shapes)
p_size <- 1 # Point size
l_size <- 3 # Size of diagonal labels
l_face <- 4 # Face and font of diagonal labels:
#    Sans Serif: 1=normal, 2=bold, 3=italics, 4=bold italics, 5= Greek symbols
#    Serif:      6=normal, 7=bold, 8=italics, 9=bold italics
#    Monospaced: 10=normal, 11=bold, 12=italics, 13=bold italics

# Personal palette
per_pal <- c("#00AFBB","#E7B800","#FC4E07","lightgreen","lightpink3")





# Load a dataset ---------------------------------------------------------------

# Edgar Anderson's Iris Data
# from System Library's 'datasets' package (loaded by default)
data_set <- iris[,1:4]    # Numeric
Categoric <- iris$Species # Factor
myColor <- per_pal[Categoric]

# Adhesion dataset
wd <- dirname(rstudioapi::getSourceEditorContext()$path)
load(paste0(wd,"/myDataSets.RData"), verbose = TRUE)
data_set <- ISO_surface
myColor <- "steelblue4"





# 1 - Basic --------------------------------------------------------------------
pairs(data_set,
      pch = p_shape,
      cex = p_size,
      cex.labels = l_size,
      font.labels = l_face)

# 2 - Upper panel only ---------------------------------------------------------
pairs(data_set,
      pch = p_shape,
      cex = p_size,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = NULL)

# 3 - Color categories ---------------------------------------------------------
pairs(data_set,
      pch = p_shape,
      cex = p_size,
      col = myColor,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = NULL)





# 4 - Correlation Matrix A -----------------------------------------------------
# Add correlation matrix on the lower panels (with fixed text size)
# Correlation panel (lower)
panel.cor_v1 <- function(x, y){ # x and y are assigned to any feature pair
  # Graphical parameter par("usr") is a vector of the form c(x1, x2, y1, y2)
  # giving the extremes of the user coordinates of the plotting region
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- round(cor(x, y), digits = 3)
  text(0.5, 0.5, r, cex = 2)
}
# Customize upper panel
upper.panel_v1 <- function(x, y){
  points(x, y, pch = p_shape, cex = p_size, col = myColor)
}
# Create the plots
pairs(data_set,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = panel.cor_v1,
      upper.panel = upper.panel_v1)





# 5 - Correlation Matrix B -----------------------------------------------------
# Add correlation matrix on the lower panels with proportional text size
panel.cor_v2 <- function(x, y){
  usr <- par("usr"); on.exit(par(usr)) 
  par(usr = c(0, 1, 0, 1))
  r <- round(cor(x, y), digits = 2)
  txt <- paste0("R = ", r)
  cex.cor <- 0.9/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
pairs(data_set,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = panel.cor_v2,
      upper.panel = upper.panel_v1)





# 6 - Correlation Matrix C -----------------------------------------------------
# Add correlation matrix on the lower panels with heatmapped background color in
# a correlogram-style representation (see Alternative Packages section below)

library(RColorBrewer) # Color Palette for R - display.brewer.all()

# Palette Definition
# NOTE: 'colorRampPalette' returns a function (!) that takes an integer argument
#       being the number of required shades of color (not to be confused with
#       the number of actual colors taken from the mother LUT, that is the first
#       argument of 'brewer.pal' -> choose between 3 and 11 colors)
shades <- 201 # Better be odd (here to map correlations from -1 to +1, plus 0)
half_scale <- (shades-1)/2
myLUT <- colorRampPalette(brewer.pal(9, "RdBu"))(shades)
myLUT <- rev(myLUT) # To map high correlation values to red

panel.cor_v3 <- function(x, y){
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- round(cor(x, y), digits = 3)
  index <- trunc(r * half_scale) + half_scale + 1
  rect(par("usr")[1], par("usr")[3],
       par("usr")[2], par("usr")[4],
       col = myLUT[index])
  text(0.5, 0.5, r, cex = 2)
}
pairs(data_set,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = panel.cor_v3,
      upper.panel = upper.panel_v1)





# 7 - Correlation inside -------------------------------------------------------
# Add correlations on the scatter plots
upper.panel_v2 <- function(x, y){
  points(x, y, pch = p_shape, cex = p_size, col = myColor)
  r <- round(cor(x, y), digits = 2)
  txt <- paste0("R = ", r)
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  text(0.5, 0.9, txt)
}
pairs(data_set,
      cex.labels = l_size,
      font.labels = l_face,
      lower.panel = NULL,
      upper.panel = upper.panel_v2)





# 8 - Diagonal Histograms ------------------------------------------------------ 
# Put histograms on the diagonal
panel.hist <- function(x, ...){
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5))
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y) # here y is the counts!
  rect(breaks[-nB], 0, breaks[-1], y, col = myColor, ...)
}
pairs(data_set,
      cex.labels = l_size - 1.5,
      font.labels = l_face,
      lower.panel = NULL,
      upper.panel = upper.panel_v1,
      diag.panel = panel.hist,
      horOdd = TRUE)





# 9 - Smooth curve -------------------------------------------------------------
# Add a smooth fitting curve in the upper panel
upper.panel_v3 <- function(x, y){
  panel.smooth(x, y, pch = p_shape, cex = p_size,
               col = myColor, col.smooth = 2, span = 2/3, iter = 3)
}
pairs(data_set,
      cex.labels = l_size - 1.5,
      font.labels = l_face,
      upper.panel = upper.panel_v3,
      lower.panel = NULL,
      diag.panel = panel.hist,
      horOdd = TRUE)





# 10 - All together ! ----------------------------------------------------------
upper.panel_v4 <- function(x, y){
  panel.smooth(x, y, pch = p_shape, cex = p_size,
               col = myColor, col.smooth = 2, span = 2/3, iter = 3)
  r <- round(cor(x, y), digits = 3)
  txt <- paste0("R = ", r)
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  text(0.5, 0.9, txt)
}
pairs(data_set,
      cex.labels = l_size - 1.5,
      font.labels = l_face,
      lower.panel = panel.cor_v3,
      upper.panel = upper.panel_v4,
      diag.panel = panel.hist,
      horOdd = TRUE)





# 11 - Alternative Packages ----------------------------------------------------

# Using 'psych' package
library(psych)
pairs.panels(data_set,
             pch = p_shape, # Point shape
             cex = p_size, # Point size (it works only if cex.cor is specified)
             cex.cor = 1, # size of the text in the correlations
             method = "pearson", # Correlation method
             digits = 3,
             smooth = TRUE, # Draw LOESS smooths
             lm = TRUE, # Plot a linear fit rather than LOESS smoothed fits
             col = myColor, # Color of the fits
             cor = TRUE, # Should correlations be shown in the upper panel?
             jiggle = FALSE, # Should the points be jittered before plotting?
             factor = 2, # Factor for jittering (1-5)
             hist.col = myColor,
             breaks = "Sturges", # Control for the number of breaks in the histogram
             scale = FALSE, # Correlation with proportional text size
             density = TRUE, # Show density plots above histograms
             ellipses = TRUE, # Show correlation ellipses
             smoother = FALSE, # smooth.scatter the data points 
             stars = FALSE,
             ci = TRUE) # Draw confidence intervals



# Using heatmap() function from 'stats' package
heatmap(x = cor(data_set),
        col = myLUT,
        symm = TRUE)



# Using Hmisc and corrplot packages
# Function stats::cor() returns only the correlation coefficients between
# variables. On the contrary, Hmisc package also gives the correlation p-value. 
# However in corrplot() both the color and size of the circles are set by the
# correlation, while p-values are used for the action specified by 'insig' param
library(Hmisc)
library(corrplot)
h_corr <- rcorr(as.matrix(data_set))
corrplot(h_corr$r,
         type = "upper",
         order = "hclust",
         p.mat = h_corr$P,
         sig.level = 0.05,
         insig = "pch", # Cross non significant correlations
         tl.col = "black",
         tl.srt = 45)
# NOTE: An error is thrown when using corrplot with rcorr() correlation matrix:
#            Error in data.frame(..., check.names = FALSE) : 
#            arguments imply differing number of rows: xx, yy
#       ...however, everything seems OK.



