## Split Single Cell BAM File by Cell Barcode

### 1. Description

Singularity component for splitting a bam cell by cell barcode

### 2. How to Use

To build singularity image

```
singularity build --remote split_bams.simg Singularityfile.def
```

To run the container, mount the directories containing the input files and output file location and run

```
singularity exec -B /path/to/root split_bams.simg -b <path-to-bam> -c <path-to-barcodes> -o <path-to-output-folder> -n <number threads> [-i]
```

### 3. Options

| Input Parameters | Desciption |
| ---------------------|:----------------------------------:|
| -b | Path to bam file containing cell barcodes, may be unsorted |
| -c | Path to matched cell barcode file |
| -o | Path to output folder where sorted bam will be generated and split bam files will be created |
| -n | Number of threads used for sorting bam with samtools |
| -i | Optional boolean flag, if set, indexes the split bam files |

