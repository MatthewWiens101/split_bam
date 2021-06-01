#!/bin/bash
# to run: source path/to/split_bam_cells.sh <path_to_bam> <name_of_output_directory> <path_to_barcodes> <nthreads> <options: -i>
# nthreads: the number of threads which will be used during samtools sorting
# options:
#   -i: index the bam files after splitting
# requires: python3 with pysam (and other dependencies) and samtools

set -eu

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

path_to_bam=""
output_dir=""
path_to_barcodes=""
nthreads=""
index=false

# TODO exit is not working, causes ssh connection to terminate
usage() { echo "Usage: $0 -b <path_to_bam> -o <output_directory> -c <path_to_barcodes> -n <nthreads> [-i]" >&2; exit 1; }
[ $# -eq 0 ] && usage
while getopts ":b:o:c:n:i" o; do
    case ${o} in
        b)
            path_to_bam=${OPTARG}
            #echo "path to bam: ${OPTARG}"
            ;;
        o)
            output_dir=${OPTARG}
            #echo output dir: ${OPTARG}
            ;;
        c)
            path_to_barcodes=${OPTARG}
            #echo path to barcodes: ${OPTARG}
            ;;
        n)
            nthreads=${OPTARG}
            #echo nthreads: ${OPTARG}
            re='^[0-9]+$'
            if ! [[ $nthreads =~ $re ]] ; then
              echo "nthreads (-n) not a number" >&2; exit 1;
            fi
            ;;
        i)
            index=true
            #echo index is true
            ;;
        *)
            usage
            ;;
    esac
done


if [ -z "${path_to_bam}" ] || [ -z "${output_dir}" ] || [ -z "${path_to_barcodes}" ] || [ -z "${nthreads}" ]; then
    usage
fi



if [ ! -d "${output_dir}" ]
then
  mkdir ${output_dir}
fi

echo "sorting"
samtools sort -t "CB" -O BAM -o ${output_dir}/sorted.bam -@ "${nthreads}" ${path_to_bam}
echo "done sorting"
if [ ! -d "${output_dir}/split_bams" ]
then
  mkdir ${output_dir}/split_bams
fi
python3 ${script_dir}/src/split_script.py -b "${output_dir}/sorted.bam" -o "${output_dir}/split_bams" -c "${path_to_barcodes}"
echo "done splitting"
#rm ${output_dir}/sorted.sam
if [ "$index" = true ]
then
  for inf in ${output_dir}/split_bams/*.bam; do samtools index -b $inf; done
  echo "done indexing"
fi


