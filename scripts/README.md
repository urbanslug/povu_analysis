

# Counting Variant Types

Parses a VCF file as if it were TSV. 
Runs on a single VCF file and summarieses the variant types based on the 
`VARTYPE` field in the `INFO` column

Run with 
```
Rscript vcf_count_types.R path/to/sample.vcf > stats.tsv
```
