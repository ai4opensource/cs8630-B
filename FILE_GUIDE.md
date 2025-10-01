# Project Structure and File Guide

## Overview
This repository provides comprehensive starter code for multivariate data visualization in R using the `tufte` package. All examples follow Edward Tufte's principles of clear and effective data presentation.

## File Structure

```
cs8630-B/
├── README.md                                    # Main documentation
├── QUICKSTART.md                                # Quick start guide
├── LICENSE                                      # MIT License
├── .gitignore                                   # Git ignore patterns
│
├── multivariate_visualization_examples.Rmd      # ⭐ Main R Markdown document
├── multivariate_examples.R                      # ⭐ Standalone R script
├── data_preparation.R                           # Data preparation utilities
├── render.R                                     # Automated rendering script
└── config_example.yml                           # Configuration example
```

## File Descriptions

### 📘 Documentation Files

#### README.md (190 lines)
- Complete project overview and documentation
- Installation instructions for R and required packages
- Usage examples for all three main scripts
- Detailed list of all 11 visualization techniques
- Learning resources and customization guide

#### QUICKSTART.md (291 lines)
- 5-minute setup guide
- Three quick ways to get started
- Common use cases with code examples
- Troubleshooting section
- Quick reference card for ggplot2 and dplyr

#### LICENSE
- MIT License for open source usage

### 📊 Main Visualization Files

#### multivariate_visualization_examples.Rmd (470 lines) ⭐
**The comprehensive R Markdown document with Tufte styling**

Contains 11 different visualization techniques:
1. Scatter Plot Matrices (base R and GGally)
2. Correlation Heatmaps (with significance testing)
3. Parallel Coordinates Plots (static and interactive)
4. Bubble Charts (3-variable visualization)
5. Time Series Multivariate Plots (faceted and normalized)
6. Heatmaps (base R and ggplot2)
7. Principal Component Analysis (PCA with biplots)
8. 3D Scatter Plots (interactive with plotly)
9. Box and Violin Plots (with distributions)
10. 2D Density Plots (with contours)
11. Faceted Visualizations (small multiples)

**Features:**
- Margin notes and sidenotes (Tufte style)
- Full-width figures
- Academic citations
- Summary statistics tables
- Clean, minimalist design

**Usage:**
```r
rmarkdown::render("multivariate_visualization_examples.Rmd")
```

#### multivariate_examples.R (254 lines) ⭐
**Standalone R script for quick visualization generation**

Same visualization techniques as the Rmd file but:
- Can be run directly in R console
- Displays plots interactively
- No document rendering needed
- Progress messages included
- Perfect for iterative exploration

**Usage:**
```r
source("multivariate_examples.R")
```

### 🔧 Utility Files

#### data_preparation.R (332 lines)
**Complete data preparation and cleaning guide**

Covers:
1. Loading data from multiple sources (CSV, Excel, databases, APIs)
2. Initial data inspection (structure, summary, missing values)
3. Data cleaning (removing NAs, duplicates)
4. Data transformation (normalization, standardization)
5. Reshaping data (wide/long format)
6. Grouping and aggregation
7. Filtering and subsetting
8. Handling categorical variables
9. Date/time handling
10. Outlier detection and handling
11. Saving prepared data
12. Validation checks

**Usage:**
```r
source("data_preparation.R")
```

#### render.R (144 lines)
**Automated rendering script for multiple output formats**

Generates:
- HTML output (Tufte styled)
- PDF output (requires LaTeX)
- Interactive HTML (with code folding)

Includes:
- Automatic package checking
- LaTeX availability detection
- Error handling
- Progress reporting
- File size reporting

**Usage:**
```bash
Rscript render.R
# or
./render.R  # if executable
```

#### config_example.yml (72 lines)
**Example configuration file**

Shows how to configure:
- Data sources (file paths, built-in datasets)
- Column specifications (numeric, categorical, date)
- Visualization preferences (colors, themes, enabled plots)
- Output options (formats, directory, naming)
- Advanced options (correlation method, PCA settings, outlier handling)

**Usage:**
```r
library(yaml)
config <- read_yaml("config_example.yml")
```

## Quick Start Examples

### Example 1: Generate HTML Report
```r
# Install packages (first time only)
install.packages(c("tufte", "rmarkdown", "ggplot2", "GGally"))

# Generate report
rmarkdown::render("multivariate_visualization_examples.Rmd")

# Open multivariate_visualization_examples.html in browser
```

### Example 2: Interactive Exploration
```r
# Run all visualizations interactively
source("multivariate_examples.R")

# Plots appear in your graphics window
```

### Example 3: Prepare Your Own Data
```r
# Load your data
my_data <- read.csv("your_data.csv")

# Follow the data preparation guide
source("data_preparation.R")

# Then adapt visualizations to your data
library(ggplot2)
library(GGally)

ggpairs(my_data, columns = 1:4)
```

## Visualization Techniques Summary

| Technique | Best For | Interactive? | File Location |
|-----------|----------|--------------|---------------|
| Scatter Matrix | Pairwise relationships | No | Section: Scatter Plot Matrices |
| Correlation Heatmap | Finding correlations | No | Section: Correlation Heatmaps |
| Parallel Coordinates | High-dimensional data | Yes (plotly) | Section: Parallel Coordinates |
| Bubble Chart | 3 continuous variables | No | Section: Bubble Charts |
| Time Series | Temporal patterns | No | Section: Time Series |
| Heatmap | Matrix data | No | Section: Heatmaps |
| PCA | Dimensionality reduction | No | Section: PCA |
| 3D Scatter | 3D relationships | Yes (plotly) | Section: 3D Scatter |
| Box/Violin | Distributions | No | Section: Box Plots |
| 2D Density | Concentration | No | Section: Density Plots |
| Faceted | Group comparison | No | Section: Faceted |

## Datasets Used

All examples use built-in R datasets:

| Dataset | Observations | Variables | Type |
|---------|--------------|-----------|------|
| iris | 150 | 5 | Multivariate (4 numeric + 1 categorical) |
| mtcars | 32 | 11 | Multivariate (all numeric) |
| economics | 574 | 6 | Time series (1 date + 5 numeric) |

## Package Dependencies

### Core Packages
- `tufte` - Document styling
- `rmarkdown` - Document rendering
- `knitr` - Dynamic report generation

### Visualization Packages
- `ggplot2` - Grammar of graphics
- `GGally` - Enhanced pair plots
- `corrplot` - Correlation plots
- `plotly` - Interactive plots

### Data Manipulation
- `dplyr` - Data transformation
- `tidyr` - Data reshaping
- `reshape2` - Data melting

### Statistical Analysis
- `MASS` - Parallel coordinates and stats

### Optional
- `gridExtra` - Arrange multiple plots
- `yaml` - Configuration files
- `fastDummies` - One-hot encoding

## Output Files

When you run the scripts, you may generate:

```
output/
├── multivariate_visualization_examples.html        # Main HTML report
├── multivariate_visualization_examples.pdf         # PDF version (requires LaTeX)
├── multivariate_visualization_examples_interactive.html  # Interactive HTML
└── *_cache/                                        # Cached computations
```

## Tips for Success

1. **Start Simple**: Begin with `source("multivariate_examples.R")` to see all visualizations
2. **Read the Guide**: QUICKSTART.md has step-by-step instructions
3. **Use Templates**: Adapt the provided code for your own data
4. **Check Data**: Use data_preparation.R to clean your data first
5. **Experiment**: Modify colors, sizes, and layouts to match your needs

## Getting Help

- R documentation: `?function_name`
- Package vignettes: `vignette(package = "packagename")`
- RStudio Community: https://community.rstudio.com/
- Stack Overflow: Tag questions with [r] and [ggplot2]

## Contributing

Feel free to:
- Add more visualization examples
- Improve documentation
- Fix bugs or typos
- Add support for new data formats
- Create tutorials or blog posts

## License

MIT License - See LICENSE file for details.

---

**Happy Visualizing! 📊✨**

For questions or issues, please open an issue on GitHub.
