# rpi-rtlsdr-base-image

Repository for a base docker image for the Raspberry Pi with rtl-sdr support.  Leveraging from the resin/rpi-raspbian base image, this image serves as the base for running containers of the various rtl-sdr programs such as rtl_tcp.

### Upstream Links

* Docker Registry @ [erben22/rpi-rtlsdr-base-image](https://hub.docker.com/r/erben22/rpi-rtlsdr-base-image/)
* GitHub @ [erben22/rpi-rtlsdr-base-image](https://github.com/erben22/rpi-rtlsdr-base-image)

## Usage

This image is intended to be used as a base image to build other containers from to run specific rtl-sdr programs.  However, if one wishes to run this container directly, see the following examples.

* Run rtl_tcp in a container, exposing connections to it via port 1234.  Using --privileged and mapping the /dev/bus/usb volume, an RTL dongle is made available to the container, and clients will be able to connect via port 1234 to the docker hosts's address.

        sudo docker run -d -it -p 1234:1234 --privileged -v /dev/bus/usb:/dev/bus/usb erben22/rpi-rtlsdr-base-image /usr/local/bin/rtl_tcp -a 172.17.0.1

## Dockerfile Details

- Based off the resin/rpi-raspbian base image.
- The rtl-sdr build dependencies are installed along with git.
- The rtl-sdr repository is cloned.
- rtl-sdr is compiled and installed to /usr/local/bin.

## Why

Why not?  I had an interest in learning docker, and figured one area to jump in would be in some fiddly-diddlying I do with various Raspberry Pi's and running rtl-sdr programs.  Collecting the setup into a container allows me to more easily deploy a new Pi to the mix, or to tinker with new distributions while more easily getting the rtl-sdr programs up and running.
