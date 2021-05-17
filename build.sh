#!/bin/bash
#SBATCH --job-name build
#SBATCH --cpus-per-task 1
#SBATCH -p upgrade

#singularity keys list
singularity build --remote ~/singularity/split_bam-latest.simg Singularityfile.def

