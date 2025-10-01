# Data Preparation Guide for Multivariate Visualization
# This script shows how to prepare your data for the visualization examples

# Load required libraries
library(dplyr)
library(tidyr)

cat("=================================================\n")
cat("Data Preparation for Multivariate Visualization\n")
cat("=================================================\n\n")

# ============================================================================
# 1. LOADING DATA FROM DIFFERENT SOURCES
# ============================================================================

cat("1. Loading Data from Different Sources\n")
cat("---------------------------------------\n\n")

# From CSV file
# my_data <- read.csv("path/to/your/data.csv")

# From Excel (requires readxl package)
# library(readxl)
# my_data <- read_excel("path/to/your/data.xlsx", sheet = 1)

# From database (requires DBI and specific driver)
# library(DBI)
# con <- dbConnect(RSQLite::SQLite(), "path/to/database.db")
# my_data <- dbGetQuery(con, "SELECT * FROM table_name")

# From web API (requires httr and jsonlite)
# library(httr)
# library(jsonlite)
# response <- GET("https://api.example.com/data")
# my_data <- fromJSON(content(response, "text"))

cat("Example: Using built-in iris dataset\n")
my_data <- iris
cat("Loaded", nrow(my_data), "rows and", ncol(my_data), "columns\n\n")

# ============================================================================
# 2. INITIAL DATA INSPECTION
# ============================================================================

cat("2. Initial Data Inspection\n")
cat("---------------------------\n\n")

# View first few rows
cat("First few rows:\n")
print(head(my_data, 3))
cat("\n")

# Check structure
cat("Data structure:\n")
str(my_data)
cat("\n")

# Summary statistics
cat("Summary statistics:\n")
print(summary(my_data))
cat("\n")

# Check for missing values
cat("Missing values per column:\n")
print(colSums(is.na(my_data)))
cat("\n")

# ============================================================================
# 3. DATA CLEANING
# ============================================================================

cat("3. Data Cleaning\n")
cat("----------------\n\n")

# Remove rows with missing values
cat("Before removing NAs:", nrow(my_data), "rows\n")
my_data_clean <- na.omit(my_data)
cat("After removing NAs:", nrow(my_data_clean), "rows\n\n")

# Alternative: Fill missing values with mean
# my_data$column_name[is.na(my_data$column_name)] <- mean(my_data$column_name, na.rm = TRUE)

# Remove duplicates
cat("Before removing duplicates:", nrow(my_data_clean), "rows\n")
my_data_clean <- distinct(my_data_clean)
cat("After removing duplicates:", nrow(my_data_clean), "rows\n\n")

# ============================================================================
# 4. DATA TRANSFORMATION
# ============================================================================

cat("4. Data Transformation\n")
cat("----------------------\n\n")

# Select specific columns
numeric_cols <- my_data_clean %>%
  select_if(is.numeric)
cat("Selected", ncol(numeric_cols), "numeric columns\n\n")

# Create new calculated columns
my_data_clean <- my_data_clean %>%
  mutate(
    Sepal.Area = Sepal.Length * Sepal.Width,
    Petal.Area = Petal.Length * Petal.Width
  )
cat("Added calculated columns: Sepal.Area, Petal.Area\n\n")

# Normalize data (0-1 scaling)
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

my_data_normalized <- my_data_clean %>%
  mutate(across(where(is.numeric), normalize))
cat("Normalized all numeric columns to 0-1 range\n\n")

# Standardize data (z-scores)
my_data_standardized <- my_data_clean %>%
  mutate(across(where(is.numeric), scale))
cat("Standardized all numeric columns (mean=0, sd=1)\n\n")

# ============================================================================
# 5. RESHAPING DATA
# ============================================================================

cat("5. Reshaping Data\n")
cat("-----------------\n\n")

# Wide to long format (for faceted plots)
my_data_long <- my_data_clean %>%
  select(-Sepal.Area, -Petal.Area) %>%  # Remove calculated columns for this example
  pivot_longer(
    cols = -Species,
    names_to = "Measurement",
    values_to = "Value"
  )

cat("Reshaped to long format:\n")
cat("Rows:", nrow(my_data_long), "\n")
cat("Columns:", ncol(my_data_long), "\n")
print(head(my_data_long, 3))
cat("\n")

# Long to wide format
my_data_wide <- my_data_long %>%
  pivot_wider(
    names_from = Measurement,
    values_from = Value
  )

cat("Reshaped back to wide format:\n")
cat("Rows:", nrow(my_data_wide), "\n")
cat("Columns:", ncol(my_data_wide), "\n\n")

# ============================================================================
# 6. GROUPING AND AGGREGATION
# ============================================================================

cat("6. Grouping and Aggregation\n")
cat("---------------------------\n\n")

# Calculate group statistics
group_stats <- my_data_clean %>%
  group_by(Species) %>%
  summarise(
    across(where(is.numeric), 
           list(mean = mean, 
                sd = sd, 
                min = min, 
                max = max),
           .names = "{.col}_{.fn}")
  )

cat("Group statistics by Species:\n")
print(group_stats)
cat("\n")

# ============================================================================
# 7. FILTERING AND SUBSETTING
# ============================================================================

cat("7. Filtering and Subsetting\n")
cat("---------------------------\n\n")

# Filter rows based on conditions
filtered_data <- my_data_clean %>%
  filter(
    Sepal.Length > 5.0,
    Petal.Length < 5.0
  )

cat("Filtered data (Sepal.Length > 5.0 AND Petal.Length < 5.0):\n")
cat("Rows:", nrow(filtered_data), "\n\n")

# Select top N rows
top_10 <- my_data_clean %>%
  arrange(desc(Petal.Length)) %>%
  head(10)

cat("Top 10 rows by Petal.Length:\n")
print(top_10)
cat("\n")

# ============================================================================
# 8. HANDLING CATEGORICAL VARIABLES
# ============================================================================

cat("8. Handling Categorical Variables\n")
cat("----------------------------------\n\n")

# Convert to factor
my_data_clean$Species <- as.factor(my_data_clean$Species)

# Check levels
cat("Factor levels for Species:", levels(my_data_clean$Species), "\n\n")

# Reorder factor levels
my_data_clean$Species <- factor(my_data_clean$Species, 
                               levels = c("setosa", "versicolor", "virginica"))

# Create binary indicator variables (one-hot encoding)
library(fastDummies)
if(require("fastDummies", quietly = TRUE)) {
  my_data_encoded <- dummy_cols(my_data_clean, 
                               select_columns = "Species",
                               remove_selected_columns = FALSE)
  cat("Created binary indicators for Species\n\n")
} else {
  cat("Install 'fastDummies' package for one-hot encoding: install.packages('fastDummies')\n\n")
}

# ============================================================================
# 9. DATE/TIME HANDLING
# ============================================================================

cat("9. Date/Time Handling\n")
cat("---------------------\n\n")

# Create example time series data
time_series_data <- data.frame(
  date = seq(as.Date("2020-01-01"), by = "month", length.out = 36),
  value1 = cumsum(rnorm(36, 0, 10)),
  value2 = cumsum(rnorm(36, 0, 15)),
  value3 = cumsum(rnorm(36, 0, 8))
)

# Extract date components
time_series_data <- time_series_data %>%
  mutate(
    year = format(date, "%Y"),
    month = format(date, "%m"),
    quarter = paste0("Q", ceiling(as.numeric(format(date, "%m")) / 3))
  )

cat("Time series data with extracted date components:\n")
print(head(time_series_data))
cat("\n")

# ============================================================================
# 10. OUTLIER DETECTION AND HANDLING
# ============================================================================

cat("10. Outlier Detection and Handling\n")
cat("-----------------------------------\n\n")

# Function to detect outliers using IQR method
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  return(x < lower_bound | x > upper_bound)
}

# Detect outliers in each numeric column
outlier_counts <- my_data_clean %>%
  select(where(is.numeric)) %>%
  summarise(across(everything(), ~sum(detect_outliers(.))))

cat("Number of outliers per column (IQR method):\n")
print(outlier_counts)
cat("\n")

# Remove outliers (example for one column)
my_data_no_outliers <- my_data_clean %>%
  filter(!detect_outliers(Sepal.Length))

cat("Rows before outlier removal:", nrow(my_data_clean), "\n")
cat("Rows after outlier removal:", nrow(my_data_no_outliers), "\n\n")

# ============================================================================
# 11. SAVING PREPARED DATA
# ============================================================================

cat("11. Saving Prepared Data\n")
cat("------------------------\n\n")

# Save to CSV
# write.csv(my_data_clean, "prepared_data.csv", row.names = FALSE)
cat("To save: write.csv(my_data_clean, 'prepared_data.csv', row.names = FALSE)\n\n")

# Save to RDS (R native format, preserves data types)
# saveRDS(my_data_clean, "prepared_data.rds")
cat("To save as RDS: saveRDS(my_data_clean, 'prepared_data.rds')\n\n")

# ============================================================================
# 12. QUICK VALIDATION CHECKS
# ============================================================================

cat("12. Quick Validation Checks\n")
cat("---------------------------\n\n")

# Check data dimensions
cat("Final data dimensions:", nrow(my_data_clean), "rows x", ncol(my_data_clean), "cols\n")

# Check data types
cat("\nColumn types:\n")
print(sapply(my_data_clean, class))

# Check for any remaining issues
cat("\nMissing values:", sum(is.na(my_data_clean)), "\n")
cat("Duplicate rows:", nrow(my_data_clean) - nrow(distinct(my_data_clean)), "\n")
cat("Infinite values:", sum(sapply(my_data_clean, function(x) sum(is.infinite(x)))), "\n")

cat("\n=================================================\n")
cat("Data preparation complete!\n")
cat("=================================================\n\n")

cat("Next steps:\n")
cat("1. Explore your data with: source('multivariate_examples.R')\n")
cat("2. Or generate a report: rmarkdown::render('multivariate_visualization_examples.Rmd')\n")
