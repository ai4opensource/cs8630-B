# Multivariate Data Visualization Examples with Tufte
# This script demonstrates various multivariate visualization techniques
# using the tufte package aesthetic principles

# Install tufte package if not already installed
if(!require("tufte", quietly = TRUE)) {
  install.packages("tufte")
}

# Install and load required packages
required_packages <- c("ggplot2", "GGally", "corrplot", "reshape2", 
                      "plotly", "MASS", "gridExtra", "dplyr", "tidyr")

for(pkg in required_packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

cat("All required packages loaded successfully!\n\n")

# ============================================================================
# 1. SCATTER PLOT MATRIX
# ============================================================================
cat("Creating scatter plot matrix...\n")
pairs(iris[,1:4], 
      col = iris$Species,
      pch = 19,
      main = "Iris Dataset: Scatter Plot Matrix")
legend("topright", 
       legend = levels(iris$Species),
       col = 1:3,
       pch = 19,
       bty = "n")

# Enhanced version with GGally
p1 <- ggpairs(iris, 
              columns = 1:4,
              aes(color = Species, alpha = 0.5),
              title = "Iris Dataset: Enhanced Pair Plot")
print(p1)

# ============================================================================
# 2. CORRELATION HEATMAP
# ============================================================================
cat("\nCreating correlation heatmaps...\n")
cor_matrix <- cor(mtcars)
corrplot(cor_matrix, 
         method = "color",
         type = "upper",
         order = "hclust",
         addCoef.col = "black",
         tl.col = "black",
         tl.srt = 45,
         number.cex = 0.7,
         title = "Correlation Heatmap: mtcars")

# ============================================================================
# 3. PARALLEL COORDINATES PLOT
# ============================================================================
cat("\nCreating parallel coordinates plot...\n")
parcoord(iris[,1:4], 
         col = as.numeric(iris$Species),
         var.label = TRUE,
         main = "Parallel Coordinates Plot: Iris Dataset")
legend("topright", 
       legend = levels(iris$Species),
       col = 1:3,
       lty = 1,
       bty = "n")

# ============================================================================
# 4. BUBBLE CHART
# ============================================================================
cat("\nCreating bubble chart...\n")
p2 <- ggplot(mtcars, aes(x = hp, y = mpg, size = cyl, color = factor(cyl))) +
  geom_point(alpha = 0.6) +
  scale_size_continuous(range = c(3, 15)) +
  labs(title = "Horsepower vs. MPG",
       subtitle = "Bubble size represents number of cylinders",
       x = "Horsepower",
       y = "Miles per Gallon",
       size = "Cylinders",
       color = "Cylinders") +
  theme_minimal()
print(p2)

# ============================================================================
# 5. TIME SERIES MULTIVARIATE
# ============================================================================
cat("\nCreating time series visualizations...\n")
economics_long <- economics %>%
  select(date, pce, pop, psavert, unemploy) %>%
  pivot_longer(cols = -date, names_to = "variable", values_to = "value")

p3 <- ggplot(economics_long, aes(x = date, y = value, color = variable)) +
  geom_line(size = 0.8) +
  facet_wrap(~ variable, scales = "free_y", ncol = 1) +
  labs(title = "US Economic Indicators Over Time",
       x = "Year",
       y = "Value") +
  theme_minimal() +
  theme(legend.position = "none")
print(p3)

# Normalized version
economics_normalized <- economics %>%
  select(date, pce, pop, psavert, unemploy) %>%
  mutate(across(-date, ~(.-min(.))/(max(.)-min(.)))) %>%
  pivot_longer(cols = -date, names_to = "variable", values_to = "value")

p4 <- ggplot(economics_normalized, aes(x = date, y = value, color = variable)) +
  geom_line(size = 0.8, alpha = 0.7) +
  labs(title = "Normalized US Economic Indicators",
       subtitle = "Scaled to 0-1 for comparison",
       x = "Year",
       y = "Normalized Value",
       color = "Indicator") +
  theme_minimal()
print(p4)

# ============================================================================
# 6. HEATMAPS
# ============================================================================
cat("\nCreating heatmaps...\n")
set.seed(123)
heatmap_data <- matrix(rnorm(100), nrow = 10)
rownames(heatmap_data) <- paste("Row", 1:10)
colnames(heatmap_data) <- paste("Col", 1:10)

heatmap(heatmap_data,
        col = colorRampPalette(c("blue", "white", "red"))(100),
        scale = "none",
        main = "Heatmap of Random Data")

# ggplot2 version
heatmap_df <- melt(heatmap_data)
colnames(heatmap_df) <- c("Row", "Column", "Value")

p5 <- ggplot(heatmap_df, aes(x = Column, y = Row, fill = Value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                      midpoint = 0) +
  labs(title = "Heatmap with ggplot2",
       fill = "Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(p5)

# ============================================================================
# 7. PRINCIPAL COMPONENT ANALYSIS (PCA)
# ============================================================================
cat("\nPerforming PCA and creating visualizations...\n")
iris_pca <- prcomp(iris[,1:4], scale. = TRUE)

pca_data <- data.frame(
  PC1 = iris_pca$x[,1],
  PC2 = iris_pca$x[,2],
  Species = iris$Species
)

var_explained <- round(100 * iris_pca$sdev^2 / sum(iris_pca$sdev^2), 1)

p6 <- ggplot(pca_data, aes(x = PC1, y = PC2, color = Species)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "PCA of Iris Dataset",
       x = paste0("PC1 (", var_explained[1], "% variance)"),
       y = paste0("PC2 (", var_explained[2], "% variance)")) +
  theme_minimal()
print(p6)

# PCA loadings
loadings <- iris_pca$rotation[,1:2]
loadings_df <- data.frame(
  Variable = rownames(loadings),
  PC1 = loadings[,1],
  PC2 = loadings[,2]
)

p7 <- ggplot(loadings_df, aes(x = PC1, y = PC2)) +
  geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.3, "cm")),
               size = 1, color = "red") +
  geom_text(aes(label = Variable), 
            hjust = -0.1, vjust = -0.1, size = 4) +
  labs(title = "PCA Loadings Plot",
       x = paste0("PC1 (", var_explained[1], "%)"),
       y = paste0("PC2 (", var_explained[2], "%)")) +
  theme_minimal() +
  coord_fixed()
print(p7)

# ============================================================================
# 8. BOX PLOTS AND VIOLIN PLOTS
# ============================================================================
cat("\nCreating box plots and violin plots...\n")
iris_long <- iris %>%
  pivot_longer(cols = -Species, names_to = "Measurement", values_to = "Value")

p8 <- ggplot(iris_long, aes(x = Measurement, y = Value, fill = Species)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Distribution of Measurements by Species",
       x = "Measurement Type",
       y = "Value (cm)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(p8)

p9 <- ggplot(iris_long, aes(x = Species, y = Value, fill = Species)) +
  geom_violin(alpha = 0.7, trim = FALSE) +
  geom_boxplot(width = 0.1, alpha = 0.5, outlier.shape = NA) +
  geom_jitter(width = 0.05, alpha = 0.3, size = 0.5) +
  facet_wrap(~ Measurement, scales = "free_y") +
  labs(title = "Distribution of Measurements by Species",
       x = "Species",
       y = "Value (cm)") +
  theme_minimal() +
  theme(legend.position = "none")
print(p9)

# ============================================================================
# 9. 2D DENSITY PLOTS
# ============================================================================
cat("\nCreating 2D density plots...\n")
p10 <- ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_density_2d_filled(alpha = 0.7) +
  geom_point(aes(color = Species), size = 2) +
  labs(title = "2D Density Plot: Sepal Length vs. Petal Length",
       x = "Sepal Length (cm)",
       y = "Petal Length (cm)") +
  theme_minimal()
print(p10)

# ============================================================================
# SUMMARY
# ============================================================================
cat("\n\n========================================\n")
cat("All visualizations created successfully!\n")
cat("========================================\n\n")

cat("Summary of visualizations created:\n")
cat("1. Scatter plot matrices (base R and GGally)\n")
cat("2. Correlation heatmaps\n")
cat("3. Parallel coordinates plots\n")
cat("4. Bubble charts\n")
cat("5. Time series plots (faceted and normalized)\n")
cat("6. Heatmaps (base R and ggplot2)\n")
cat("7. PCA plots (scores and loadings)\n")
cat("8. Box plots and violin plots\n")
cat("9. 2D density plots\n\n")

cat("To create a Tufte-style HTML report, run:\n")
cat("  rmarkdown::render('multivariate_visualization_examples.Rmd')\n\n")
