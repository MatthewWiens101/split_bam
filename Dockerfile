FROM conda/miniconda3

RUN conda update --all && conda clean -afy

RUN pip install --no-cache-dir numpy pandas pysam

RUN apt-get update && \
    apt-get clean

RUN conda install -c bioconda samtools && rm -rf /var/lib/apt/lists/* && conda clean -afy

RUN mkdir -p /workspace
WORKDIR /workspace

RUN python --version

ADD . /workspace

ENTRYPOINT [ "/workspace/split_bam_cells.sh" ]

# build with:
# docker build -t split_bam .

