# Quick Start Guide: Multivariate Visualization with Tufte

This guide will help you get started with the multivariate visualization examples in just a few minutes.

## 1. Quick Setup (5 minutes)

### Step 1: Install R
If you don't have R installed, download it from [https://cran.r-project.org/](https://cran.r-project.org/)

### Step 2: Install RStudio (Optional but Recommended)
Download from [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)

### Step 3: Install Core Packages
Open R or RStudio and run:

```r
install.packages(c("tufte", "rmarkdown", "ggplot2", "GGally", 
                   "corrplot", "plotly", "dplyr", "tidyr"))
```

## 2. Run Your First Visualization (1 minute)

### Option A: Interactive Script

```r
# Download and run the standalone script
source("multivariate_examples.R")
```

This will create all visualizations in your R graphics window.

### Option B: Generate HTML Report

```r
# Generate a beautiful HTML report
rmarkdown::render("multivariate_visualization_examples.Rmd")
```

Then open `multivariate_visualization_examples.html` in your web browser.

## 3. Understanding the Examples

### What You'll Learn

The examples cover **11 different visualization techniques**:

1. **Scatter Plot Matrix** - See all pairwise relationships at once
2. **Correlation Heatmap** - Identify strong correlations visually
3. **Parallel Coordinates** - Compare multivariate observations
4. **Bubble Chart** - Show 3 variables in 2D space
5. **Time Series** - Visualize temporal multivariate data
6. **Heatmap** - Display matrix data with color coding
7. **PCA (Principal Component Analysis)** - Reduce dimensionality
8. **3D Scatter Plot** - Interactive 3D exploration
9. **Box & Violin Plots** - Compare distributions across groups
10. **2D Density Plot** - Show concentration of observations
11. **Faceted Plots** - Create small multiples for comparison

### Example Datasets Used

- **iris** - Flower measurements (150 observations, 4 variables)
- **mtcars** - Car specifications (32 observations, 11 variables)
- **economics** - US economic data (time series, 6 variables)

## 4. Customize for Your Data

### Basic Template

Here's how to adapt any example to your data:

```r
# 1. Load your data
my_data <- read.csv("your_data.csv")

# 2. Explore with scatter plot matrix
pairs(my_data[, 1:4],  # Select your numeric columns
      col = my_data$category_column,
      main = "My Data Overview")

# 3. Create correlation heatmap
library(corrplot)
cor_matrix <- cor(my_data[, c("var1", "var2", "var3", "var4")])
corrplot(cor_matrix, method = "color")

# 4. PCA for dimensionality reduction
pca_result <- prcomp(my_data[, 1:4], scale. = TRUE)
biplot(pca_result)
```

## 5. Common Use Cases

### Use Case 1: Exploring a New Dataset

```r
# Quick exploration pipeline
library(dplyr)
library(ggplot2)
library(GGally)

# Load data
data <- read.csv("new_dataset.csv")

# Summary statistics
summary(data)

# Pairwise relationships
ggpairs(data)

# Correlation matrix
library(corrplot)
corrplot(cor(select_if(data, is.numeric)))
```

### Use Case 2: Comparing Groups

```r
library(ggplot2)

# Box plots for multiple variables
data_long <- data %>%
  pivot_longer(cols = -group_column, 
               names_to = "variable", 
               values_to = "value")

ggplot(data_long, aes(x = variable, y = value, fill = group_column)) +
  geom_boxplot() +
  theme_minimal()
```

### Use Case 3: Time Series Analysis

```r
# Plot multiple time series
ggplot(data_long, aes(x = date, y = value, color = variable)) +
  geom_line() +
  facet_wrap(~ variable, scales = "free_y") +
  theme_minimal()
```

## 6. Tufte Style Features

The Tufte package provides special formatting features:

### Margin Notes

```r
# In R Markdown
`r margin_note("This is a note in the margin")`
```

### Side Figures

```{r, fig.margin=TRUE, fig.cap="A margin figure"}
plot(1:10)
```

### Full Width Figures

```{r, fig.fullwidth=TRUE, fig.cap="A full width figure"}
plot(1:10)
```

### New Thought

```r
`r newthought('This starts a new section')` with special formatting.
```

## 7. Troubleshooting

### Problem: Packages won't install

**Solution:**
```r
# Try installing from a different mirror
options(repos = "https://cloud.r-project.org/")
install.packages("package_name")
```

### Problem: R Markdown won't render to PDF

**Solution:**
You need LaTeX installed. For HTML output (no LaTeX needed):
```r
rmarkdown::render("file.Rmd", output_format = "html_document")
```

### Problem: Graphics device error

**Solution:**
```r
# Close all graphics devices and try again
graphics.off()
```

### Problem: Memory issues with large datasets

**Solution:**
```r
# Sample your data first
sample_data <- my_data[sample(nrow(my_data), 5000), ]

# Then create visualizations
pairs(sample_data)
```

## 8. Next Steps

### Learn More

1. **Tufte's Books:**
   - "The Visual Display of Quantitative Information"
   - "Envisioning Information"
   - "Visual Explanations"

2. **Online Resources:**
   - [ggplot2 documentation](https://ggplot2.tidyverse.org/)
   - [R Graphics Cookbook](https://r-graphics.org/)
   - [Data Visualization: A Practical Introduction](https://socviz.co/)

3. **Advanced Topics:**
   - Interactive visualizations with Shiny
   - Advanced dimensionality reduction (t-SNE, UMAP)
   - Network and graph visualizations
   - Geospatial multivariate data

### Experiment!

The best way to learn is by experimenting:

1. Start with the provided examples
2. Modify colors, sizes, and layouts
3. Try with your own data
4. Combine multiple visualization types
5. Share your results!

## 9. Quick Reference Card

### Essential ggplot2 Commands

```r
# Basic structure
ggplot(data, aes(x = var1, y = var2)) +
  geom_point()  # scatter plot

# Common geoms
geom_line()      # line plot
geom_bar()       # bar chart
geom_boxplot()   # box plot
geom_violin()    # violin plot
geom_density()   # density plot
geom_tile()      # heatmap

# Faceting
facet_wrap(~ variable)           # wrap by one variable
facet_grid(rows ~ cols)          # grid by two variables

# Themes
theme_minimal()
theme_classic()
theme_bw()
```

### Essential dplyr Commands

```r
select()    # choose columns
filter()    # choose rows
mutate()    # create new columns
summarise() # aggregate data
group_by()  # group for operations
arrange()   # sort rows
```

## 10. Getting Help

- **R Documentation:** `?function_name` or `help(function_name)`
- **Package Vignettes:** `vignette(package = "package_name")`
- **Stack Overflow:** Tag your questions with [r] and [ggplot2]
- **RStudio Community:** [community.rstudio.com](https://community.rstudio.com/)

---

**Ready to start? Run this now:**

```r
# Clone or download the repository, then:
source("multivariate_examples.R")
```

Happy visualizing! 📊✨
