#!/usr/bin/env Rscript
# Render Script - Generate all output formats
# This script generates HTML, PDF, and other outputs from the R Markdown file

cat("========================================\n")
cat("Multivariate Visualization Renderer\n")
cat("========================================\n\n")

# Check if required packages are installed
required_packages <- c("rmarkdown", "knitr", "tufte")

cat("Checking required packages...\n")
for(pkg in required_packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, quiet = TRUE)
    library(pkg, character.only = TRUE)
  }
}
cat("All required packages are installed!\n\n")

# Define the input file
input_file <- "multivariate_visualization_examples.Rmd"

# Check if file exists
if(!file.exists(input_file)) {
  cat("ERROR: Could not find", input_file, "\n")
  cat("Make sure you are running this script from the repository directory.\n")
  quit(status = 1)
}

cat("Found input file:", input_file, "\n\n")

# ============================================================================
# OPTION 1: HTML Output (Default, works on all systems)
# ============================================================================

cat("Option 1: Generating HTML output...\n")
cat("------------------------------------\n")

tryCatch({
  rmarkdown::render(
    input = input_file,
    output_format = "tufte::tufte_html",
    output_file = "multivariate_visualization_examples.html"
  )
  cat("✓ HTML generated successfully!\n")
  cat("  Open: multivariate_visualization_examples.html\n\n")
}, error = function(e) {
  cat("✗ Error generating HTML:", conditionMessage(e), "\n\n")
})

# ============================================================================
# OPTION 2: PDF Output (Requires LaTeX installation)
# ============================================================================

cat("Option 2: Generating PDF output...\n")
cat("-----------------------------------\n")
cat("Note: This requires XeLaTeX to be installed on your system.\n\n")

# Check if LaTeX is available
has_latex <- FALSE
tryCatch({
  system2("xelatex", "--version", stdout = NULL, stderr = NULL)
  has_latex <- TRUE
}, error = function(e) {
  has_latex <- FALSE
})

if(has_latex) {
  cat("XeLaTeX found. Generating PDF...\n")
  tryCatch({
    rmarkdown::render(
      input = input_file,
      output_format = "tufte::tufte_handout",
      output_file = "multivariate_visualization_examples.pdf"
    )
    cat("✓ PDF generated successfully!\n")
    cat("  Open: multivariate_visualization_examples.pdf\n\n")
  }, error = function(e) {
    cat("✗ Error generating PDF:", conditionMessage(e), "\n")
    cat("  You may need to install additional LaTeX packages.\n\n")
  })
} else {
  cat("✗ XeLaTeX not found. Skipping PDF generation.\n")
  cat("  To generate PDFs, install a LaTeX distribution:\n")
  cat("  - Windows: MiKTeX (https://miktex.org/)\n")
  cat("  - Mac: MacTeX (https://www.tug.org/mactex/)\n")
  cat("  - Linux: sudo apt-get install texlive-xelatex\n")
  cat("  - Or use tinytex: install.packages('tinytex'); tinytex::install_tinytex()\n\n")
}

# ============================================================================
# OPTION 3: Alternative HTML with code folding
# ============================================================================

cat("Option 3: Generating HTML with code folding...\n")
cat("----------------------------------------------\n")

tryCatch({
  rmarkdown::render(
    input = input_file,
    output_format = rmarkdown::html_document(
      toc = TRUE,
      toc_float = TRUE,
      code_folding = "hide",
      theme = "flatly"
    ),
    output_file = "multivariate_visualization_examples_interactive.html"
  )
  cat("✓ Interactive HTML generated successfully!\n")
  cat("  Open: multivariate_visualization_examples_interactive.html\n\n")
}, error = function(e) {
  cat("✗ Error generating interactive HTML:", conditionMessage(e), "\n\n")
})

# ============================================================================
# Summary
# ============================================================================

cat("\n========================================\n")
cat("Summary\n")
cat("========================================\n\n")

# List generated files
output_files <- c(
  "multivariate_visualization_examples.html",
  "multivariate_visualization_examples.pdf",
  "multivariate_visualization_examples_interactive.html"
)

cat("Generated files:\n")
for(file in output_files) {
  if(file.exists(file)) {
    size <- file.info(file)$size
    size_kb <- round(size / 1024, 1)
    cat("  ✓", file, paste0("(", size_kb, " KB)\n"))
  }
}

cat("\n")
cat("To view the HTML output, simply open it in your web browser.\n")
cat("To regenerate at any time, run: Rscript render.R\n\n")

cat("========================================\n")
cat("Rendering complete!\n")
cat("========================================\n")
