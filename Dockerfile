FROM conda/miniconda3

RUN apt-get update && \
    apt-get clean

RUN conda install -c bioconda samtools && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir numpy pandas pysam

RUN mkdir -p /workspace
WORKDIR /workspace

ADD . /workspace

ENTRYPOINT [ "split_bam_cells.sh" ]

