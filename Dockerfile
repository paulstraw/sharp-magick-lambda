FROM public.ecr.aws/lambda/nodejs:14

RUN yum update && yum groupinstall "Development Tools" -y

RUN yum install -y \
  wget \
  expat-devel \
  libtool-ltdl-devel \
  glib2-devel \
  libjpeg-turbo-devel \
  LibRaw-devel \
  orc-devel

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# vips lib files are installed to /usr/local/lib, which is not in
# LD_LIBRARY_PATH by default. `ldd node_modules/sharp/build/Release/sharp.node`
# won't be able to find them without this command.
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/lib"

# imagemagick
ARG IMAGICK_VERSION=7.1.0-5

RUN cd /usr/local/src \
  && wget -O ImageMagick-${IMAGICK_VERSION}.tar.gz -N https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz \
  && tar xzf ImageMagick-${IMAGICK_VERSION}.tar.gz \
  && cd ImageMagick-${IMAGICK_VERSION} \
  && ./configure --with-modules\
  && make V=0 \
  && make install

# libvips
ARG VIPS_VERSION=8.11.3

RUN cd /usr/local/src \
  && wget https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  && tar xzf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && ./configure \
  && make V=0 \
  && make install

COPY package.json package-lock.json ${LAMBDA_TASK_ROOT}

# Sharp docs:
# "When using npm v6 or earlier, the npm install --unsafe-perm flag must be used when installing as root or a sudo user."
RUN npm i --unsafe-perm

COPY src/ ${LAMBDA_TASK_ROOT}
