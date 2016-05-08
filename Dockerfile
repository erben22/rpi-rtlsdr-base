# Version: 0.0.2

# Initial base is from the resin rpi-raspbian image.

FROM resin/rpi-raspbian
MAINTAINER R. Cody Erben
ENV REFRESHED_AT 2016-05-07
ENV RTL_SDR_REPO /tmp/rtl-sdr

# Enable the source repository for jessie:

RUN echo 'deb-src http://archive.raspbian.org/raspbian/ jessie main contrib non-free rpi' >> /etc/apt/sources.list && \
  echo 'Acquire::HTTP::Proxy "http://192.168.2.66:3142";' >> /etc/apt/apt.conf.d/01proxy && \
    echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

# Update the apt cache, install git, and
# then pull the build dependencies for rtl-sdr.

RUN apt-get update && apt-get -y upgrade && \
  apt-get -y install git-core nano net-tools --no-install-recommends && \
  apt-get build-dep rtl-sdr --no-install-recommends && apt-get clean

#libusb-1.0-0-dev pkg-config ca-certificates git-core cmake build-essential --no-install-recommends

# Blacklist the rtl28xx driver so rtl-sdr is happy:

RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/raspi-blacklist.conf

# Pull the rtl-sdr repo and build!

RUN git clone git://git.osmocom.org/rtl-sdr.git $RTL_SDR_REPO && \
  mkdir $RTL_SDR_REPO/build && \
  cd $RTL_SDR_REPO/build && cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
  cd $RTL_SDR_REPO/build && make && \
  cd $RTL_SDR_REPO/build && make install && \
  ldconfig

# Cleanup our image cause that is how we roll:

#RUN apt-get -y --purge autoremove git-core rtl-sdr perl cmake cpp dpkg-dev \
#  make libusb-* g++
RUN rm -rf $RTL_SDR_REPO && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -f /var/cache/apt/archives/*.deb && \
  rm -f /var/cache/apt/archives/partial/*.deb && \
  rm -f /var/cache/apt/*.bin
