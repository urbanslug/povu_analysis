library(readr)
library(dplyr)
library(tidyr)

f <- read_delim("~/src/hprc/povu/pv.tsv", delim = "\t")

f$vartype <- sub(".*VARTYPE=([^;]+);.*", "\\1", f$INFO)

# Dynamically define bins based on min(POS), max(POS), and the desired number of bins
num_bins <- 100  # Set the desired number of bins (you can adjust this value)
min_pos <- min(f$POS)
max_pos <- max(f$POS)
bin_edges <- seq(from = min_pos, to = max_pos, length.out = num_bins + 1)

# Assign BIN labels to each position
f$BIN <- cut(f$POS, breaks = bin_edges, include.lowest = TRUE)

# Count the frequency of each VARTYPE in each BIN
summary_table <- f %>%
  group_by(BIN, vartype) %>%
  summarise(Frequency = n()) %>%
  pivot_wider(names_from = vartype, values_from = Frequency, values_fill = 0)

# Prepare data for the grouped bar plot
summary_table_matrix <- as.matrix(summary_table[,-1])  # Exclude BIN column

barplot(
  t(summary_table_matrix),
  beside = TRUE,
  col = c("blue", "red", "green", "purple"),
  border = NA,
  legend.text = colnames(summary_table_matrix),
  args.legend = list(
    x = "topright",
    cex = 0.5            # smaller legend
  ),
  names.arg = rep("", nrow(summary_table_matrix)),  # no x-axis text
  las = 2,
  xlab = "POS Column Bins",
  ylab = "Count",
  main = "Barplot Comparing VARTYPE Frequencies Across Bins"
)
