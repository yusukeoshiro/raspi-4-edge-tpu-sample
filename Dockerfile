FROM yusukeoshiro/opencv-arm
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y curl gnupg
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update
RUN apt-get install -y libedgetpu1-std
RUN apt-get install -y python3-edgetpu

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y \
    install sudo xvfb \
    git wget virtualenv python3-numpy python3-scipy netpbm \
    ghostscript libffi-dev libjpeg-turbo-progs \
    python3-setuptools \
    python3-dev cmake  \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev \
    python3-tk \
    libharfbuzz-dev libfribidi-dev && apt-get clean
RUN apt-get install -yq  libssl-dev openssl build-essential gcc
RUN apt-get install -y python3 python3-dev python3-distutils

# RUN wget https://bootstrap.pypa.io/get-pip.py
# RUN python3.7 get-pip.py

RUN python3 -m pip install --upgrade cython
RUN python3 -m pip install --upgrade wheel
RUN python3 -m pip install --upgrade Pillow
RUN python3 -m pip install --upgrade numpy

RUN apt-get update -y && apt-get install -yq wget libssl-dev openssl build-essential gcc zlib1g-dev
RUN apt-get install -y usbutils curl

# RUN python3.7 -m pip install --upgrade opencv-python
RUN python3 -m pip install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp36-cp36m-linux_aarch64.whl


RUN git clone https://github.com/google-coral/tflite.git
RUN cd tflite/python/examples/classification && bash install_requirements.sh

CMD ["cd tflite/python/examples/classification && python3 classify_image.py --model models/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite --labels models/inat_bird_labels.txt --input images/parrot.jpg"]
