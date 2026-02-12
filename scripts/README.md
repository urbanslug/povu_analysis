# Variant calling and evaluation pipeline

This documentation outlines a pipeline for downloading pangenome graph data, 
calling variants, summarizing results, and comparing callsets.

## 1 Variant Calling

1.1 **Fetch data**  
   - Script: [`dl`](./dl)  
   - Language: `bash`  
   - Downloads MGC `.og` files from S3 and converts them to GFA v1.1 format using [odgi](https://github.com/pangenome/odgi).  
   - Usage:  
     ```
     ./dl -c "1,2,3,4,5,6,7,8,9,10,X,Y"
     ```

1.2 **Calling Variants**  
   - Script: [`gvc`](./gvc)  
   - Language: `bash`  
   - Calls variants using `povu gfa2vcf`.  
   - Usage:  
     ```
     ./gvc -c "1,2,3,4,5,6,7,8,9,10,X,Y"
     ```

## 2 Analyse Results

From a single VCF file

2.1. **Analyzing Results**  
   - Script: [`vcf_count_types.R`](./vcf_count_types.R)  
   - Language: `R`  
   - Parses a VCF file as TSV and summarizes variant types (`VARTYPE` field in `INFO`).  
   - Usage:  
     ```
     Rscript vcf_count_types.R path/to/sample.vcf > stats.tsv
     ```

## 3 Compare Results

### 3.1 Install Dependencies
Use conda to install the required tools:  
```
conda install -c bioconda bcftools odgi samtools
```

Follow instructions on RTG website for instructions on how to download [RTG Tools](https://realtimegenomics.com/products/rtg-tools)

### 3.2 Using [vcfeval](https://realtimegenomics.github.io/rtg-tools/rtg_command_reference.html#vcfeval)

1. **Generate an SDF of the FASTA file**  
   Convert a FASTA file to an SDF format (required by `vcfeval`):  
   Docs [SDF](https://realtimegenomics.github.io/rtg-tools/rtg_command_reference.html#rtg-command-syntax)
   ```
   rtg format --output x.sdf x.fa
   ```


2. **Sort the VCF File (if not sorted)**  
   Ensure the VCF file is sorted. [`bcftools` docs](https://samtools.github.io/bcftools/bcftools.html#sort):
   ```
   bcftools sort x.vcf -o x.sorted.vcf
   ```


3. **Compress the VCF File with bgzip**  
   Use [`bgzip`](https://manpages.debian.org/unstable/tabix/bgzip.1.en.html) to compress the VCF file:  
   ```
   bgzip < x.vcf > x.vcf.gz
   bgzip -r x.vcf.gz  # Create a .gzi index
   ```


4. **Index the VCF File**  
   Use [`tabix`](https://www.htslib.org/doc/tabix.html) to index the compressed VCF file:  
   ```
   tabix -p vcf chrX.pv.vcf.gz
   ```
