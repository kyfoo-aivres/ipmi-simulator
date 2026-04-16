FROM alpine
LABEL maintainer="vapor@vapor.io"

# Install build dependencies for OpenIPMI
RUN apk --update --no-cache add \
    build-base \
    libedit-dev \
    readline-dev \
    popt-dev \
    glib-dev \
    net-snmp-dev \
    ncurses-dev \
    openssl-dev \
    linux-headers \
    autoconf \
    automake \
    libtool \
    coreutils \
    git

# Build and install OpenIPMI from source inside container to prevent CRLF issues
RUN git clone https://github.com/cminyard/openipmi.git /src/openipmi && \
    cd /src/openipmi && \
    ./bootstrap && \
    ./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --localstatedir=/var \
                --with-python=no --with-swig=no --with-perl=no --with-tcl=no && \
    make && \
    make install && \
    rm -rf /src/openipmi

# Create the directories that will be used to persist state information
# for the IPMI simulator instance.
RUN mkdir -p /tmp/chassis

COPY . /tmp/ipmisim

EXPOSE 623/udp

CMD ["ipmi_sim", "-n", "-c", "/tmp/ipmisim/lan.conf", "-f", "/tmp/ipmisim/sim.emu"]