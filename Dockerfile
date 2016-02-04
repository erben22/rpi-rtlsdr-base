# Version: 0.0.1

# Initial base is from the resin rpi-raspbian image.

FROM resin/rpi-raspbian
MAINTAINER R. Cody Erben "erben22@mtnaircomputer.net"
ENV REFRESHED_AT 2016-02-04
ENV RTL_SDR_REPO /tmp/rtl-sdr

# Enable the source repository for jessie:

RUN echo 'deb-src http://archive.raspbian.org/raspbian/ jessie main contrib non-free rpi' >> /etc/apt/sources.list

# Update the apt cache, install git, and
# then pull the build dependencies for rtl-sdr.

# May want to optimize this with something like the
# --no-install-recommends flag.

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install git
RUN apt-get build-dep rtl-sdr

# Cleanup apt to make the image a bit more tidy:

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Blacklist the rtl28xx driver so rtl-sdr is happy:

RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/raspi-blacklist.conf

# Pull the rtl-sdr repo and build!

RUN git clone git://git.osmocom.org/rtl-sdr.git $RTL_SDR_REPO

RUN mkdir $RTL_SDR_REPO/build
RUN cd $RTL_SDR_REPO/build && cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN cd $RTL_SDR_REPO/build && make
RUN cd $RTL_SDR_REPO/build && make install
RUN ldconfig

RUN rm -rf $RTL_SDR_REPO

# Stuff that will move into a container specific
# to running a given rtl program.

#EXPOSE 1234

#ENTRYPOINT ["/usr/local/bin/rtl_tcp", "-a", "172.17.0.1"]
