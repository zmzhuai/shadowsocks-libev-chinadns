FROM ubuntu:trusty

MAINTAINER Min Zhang <zmzhuai@gmail.com>

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev
ENV SHADOWSOCKSDIR /tmp/shadowsocks-libev
ENV CHINADNSDIR /tmp/chinadns
ENV SSVERSION v2.4.7
ENV CDVERSION 1.3.2
ENV PORT 8338

# Set up building environment
RUN apt-get -y update \
        && apt-get install -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $SHADOWSOCKSDIR
WORKDIR $SHADOWSOCKSDIR
RUN git checkout $SSVERSION \
     && ./configure \
     && make \
     && make install

# Get the ChinaDNS code, build and install
RUN git clone https://github.com/shadowsocks/ChinaDNS.git $CHINADNSDIR
WORKDIR $CHINADNSDIR
RUN git checkout $CDVERSION \
     && chmod +x ./autogen.sh \
     && ./autogen.sh \
     && ./configure \
     && make \
     && make install

# Tear down building environment and delete git repository
WORKDIR /
RUN rm -rf $SHADOWSOCKSDIR/ \
     && rm -rf $CHINADNSDIR/ \
     && apt-get --purge autoremove -y $DEPENDENCIES

# Port in the json config file won't take affect. Instead we'll use 8388.
#EXPOSE $PORT

# Override the host and port in the config file.
#ADD entrypoint /
#ENTRYPOINT ["/entrypoint"]
#CMD ["-h"]]

