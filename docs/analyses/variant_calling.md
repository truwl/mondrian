# Variant calling Analysis

Variant calling analysis runs the following workflows:

- Mutationseq
- Strelka
- Mutect

The analysis takes in tumour and normal bam files as input and generates a set of high confidence breakpoints that can be used for downstream analyses. 


## Input Data Format:

### Tumour:

A Bam file:
- generated by the `merge_cells` analysis from mondrian, as explained [here](data_formats/merged_library_bam.md) or
- single bam file with all tumour cells merged, and one read group per sample


### Normal:

A normal Bam file:
- generated by the `merge_cells` analysis on normal cell bams from mondrian as explained [here](data_formats/merged_library_bam.md), or
- single bam file with all normal cells merged, and one read group per sample, or
- bam file generated by bulk WGS sequencing


### Output Data Format:

- museq.vcf
- mutect.vcf
- strelka_snv.csv
- strelka_indel.vcf
- high_confidence.csv.gz