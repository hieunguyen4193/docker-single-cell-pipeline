FROM rocker/rstudio:4.5.0
RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential -y
RUN apt install libudunits2-dev libgdal-dev libgeos-dev libproj-dev libfontconfig1-dev -y
RUN apt-get clean all && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    libhdf5-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libxt-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libglpk40 \
    libgit2-dev \
  && apt-get clean all && \
  apt-get purge && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt install libfontconfig1-dev 
RUN apt-get update && apt-get install libmagick++-6.q16-dev -y

RUN mkdir -p installation_src
# RUN update-alternatives --set libblas.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/blas/libblas.so.3
# RUN update-alternatives --set liblapack.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3

RUN apt-get install libblas3 libblas-dev libopenblas-dev -y

RUN mkdir -p /home/hieunguyen
RUN apt-get update && apt-get install -y python3 && ln -s /usr/bin/python3 /usr/bin/python

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.31.1/bedtools-2.31.1.tar.gz && tar -zxvf bedtools-2.31.1.tar.gz && cd bedtools2 && make
RUN apt-get install libncurses5-dev -y
RUN wget https://github.com/samtools/samtools/releases/download/1.22.1/samtools-1.22.1.tar.bz2 && tar -xvf samtools-1.22.1.tar.bz2 && cd samtools-1.22.1 && ./configure --prefix=/home/hieunguyen/samtools && make && make install

RUN mkdir -p /home/hieunguyen/
RUN mkdir -p /media

RUN apt-get update
RUN apt-get install -y \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

COPY ./install_R_packages.R /home/hieunguyen
RUN Rscript /home/hieunguyen/install_R_packages.R

# RUN mkdir -p /home/hieunguyen/miniconda3 && \
#     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/hieunguyen/miniconda3/miniconda.sh && \
#     bash /home/hieunguyen/miniconda3/miniconda.sh -b -u -p /home/hieunguyen/miniconda3 && \
#     rm /home/hieunguyen/miniconda3/miniconda.sh

# Note, Hieu: include TARGETARCH build argument to support multi-arch build
# https://docs.docker.com/engine/reference/commandline/buildx_build/#set-build
# OTHERWISE, the installed conda will not match the architecture of the image
# e.g., if building on an x86_64 host, the conda will be x86_64 even if the target image is arm64
# ROSETTA ERROR rosetta error: failed to open elf at /lib64/ld-linux-x86-64.so.2

ARG TARGETARCH
RUN mkdir /home/hieunguyen/miniconda3
RUN if [ "$TARGETARCH" = "amd64" ]; then ARCH="x86_64"; else ARCH="aarch64"; fi && \
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh \
  -O /home/hieunguyen/miniconda3/miniconda.sh && \
  bash /home/hieunguyen/miniconda3/miniconda.sh -b -u -p /home/hieunguyen/miniconda3 && \
  rm /home/hieunguyen/miniconda3/miniconda.sh

RUN apt-get install libzmq3-dev -y

ENV PATH=/home/hieunguyen/miniconda3/bin:${PATH}
##### install jupyterlab and R kernel.
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main & \
  conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN conda install numpy pandas matplotlib seaborn -y 
RUN pip install jupyterlab tqdm ipykernel 
RUN pip install 'scanpy[leiden]' 
RUN pip install -U scvi-tools
RUN pip install -U scikit-learn
RUN pip install torch torchvision

# bosung some packages for R. 
COPY ./install_R_packages2.R /home/hieunguyen
RUN Rscript /home/hieunguyen/install_R_packages2.R
RUN apt install cmake  -y

COPY ./install_R_packages3.R /home/hieunguyen
RUN Rscript /home/hieunguyen/install_R_packages3.R