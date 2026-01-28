#!/usr/bin/env Rscript

library(tidyr)
library(readr)

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))

# Read a VCF file into a dataframe
#
# Reads a VCF file and converts it into a data frame.
# Logic: Uses a preview buffer to find the #CHROM header line. 
# It then reads the file while treating the # character as literal text 
# rather than a comment indicator.
#
# Input: String (Path to .vcf or .vcf.gz).
# Output: Data frame with standardized VCF column names.
read_vcf_as_tsv <- function(vcf_path) {
  # read the the entire file
  all_lines <- readLines(vcf_path)
  
  # 2. Identify the header line (the last line starting with #)
  n_skip <- sum(grepl("^#", all_lines))
  
  # 3. Extract and clean the column names from that specific line
  raw_header <- all_lines[n_skip]
  clean_header <- strsplit(gsub("^#", "", raw_header), "\t")[[1]]
  
  # 4. Read the actual data
  # We skip all '#' lines (n_skip) to start exactly at the first data row
  vcf_df <- read.table(vcf_path, 
                         sep = "\t", 
                         skip = n_skip, 
                         comment.char = "", 
                         quote = "", 
                         stringsAsFactors = FALSE,
                         header = FALSE)
  
  # 5. Assign the cleaned names to the data frame
  colnames(vcf_df) <- clean_header
  
  return(vcf_df)
}

# Extracts variant classifications from INFO field
# 
extract_cols <- function(vcf_data){
  with_added_cols <- vcf_data %>%
    mutate(
      VARTYPE = sub(".*VARTYPE=([^;]+);.*", "\\1", INFO),
      TANGLED = sub(".*TANGLED=([^;]).*", "\\1", INFO),
      .after = CHROM  # This places both new columns immediately after 'INFO'
    )
  
  return (with_added_cols)
}

# Extracts and counts specific variant classifications
#
count_var_types <- function(vcf_data) {
  # 1. Define your master list of columns
  target_types <- c("DEL", "INS", "SUB", "INV", "INVSUB")
  
  # 2. Create a blank data frame with 0s
  # This serves as your "Default" state
  summary_df <- data.frame(matrix(0, nrow = 1, ncol = length(target_types)))
  colnames(summary_df) <- target_types
  
  # 3. Get the actual counts from the data
  actual_counts <- table(vcf_data$VARTYPE)
  
  # 4. Fill the template
  # We find which names in 'actual_counts' match our template columns
  found_types <- names(actual_counts) %in% target_types
  
  if (any(found_types)) {
    # Extract only the names that exist in our template to avoid errors
    valid_names <- names(actual_counts)[found_types]
    summary_df[1, valid_names] <- as.numeric(actual_counts[valid_names])
  }
  
  return(summary_df)
}

# --- Main Execution ---
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Error: Please provide a VCF file path.", call. = FALSE)
}

fp <- args[1]
vcf_data <- read_vcf_as_tsv(fp)
vcf_data <- extract_cols(vcf_data)
var_types <- count_var_types(vcf_data)

# 3. Output to stdout as TSV
# row.names=FALSE is important for clean TSV output
write.table(var_types, stdout(), sep = "\t", row.names = FALSE, quote = FALSE)