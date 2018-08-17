FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt install -y pkg-config zip g++ zlib1g-dev unzip wget

ENV PATH "/miniconda/bin:$PATH"

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /miniconda \
    && conda install numpy \
    && pip install six wheel

RUN wget https://github.com/bazelbuild/bazel/releases/download/0.16.1/bazel-0.16.1-installer-linux-x86_64.sh \
    && chmod +x bazel-0.16.1-installer-linux-x86_64.sh \
    && ./bazel-0.16.1-installer-linux-x86_64.sh

COPY nvidia-ml.list /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt install -y libnccl2 libnccl-dev \
    && mkdir -p /usr/local/cuda/lib/ \
    && cp /usr/lib/x86_64-linux-gnu/libnccl.so.2 /usr/local/cuda/lib/ \
    && cp /usr/include/nccl.h /usr/local/cuda/include/

COPY intelproducts.list /etc/apt/sources.list.d/intelproducts.list

RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
    && apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
    && apt-get update && apt install -y intel-mkl-2018.2-046

RUN mkdir /workspace
WORKDIR /workspace

RUN useradd -m -u 2001 yxqiu

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
