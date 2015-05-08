FROM phusion/baseimage:0.9.16
MAINTAINER trick77 <jan@trick77.om> https://trick77.com/

RUN apt-get -qq update
RUN apt-get -y install python-software-properties \
    && add-apt-repository ppa:dlundquist/sniproxy \
    && apt-get update && apt-get -y install sniproxy

# Create runit services
RUN mkdir /etc/sniproxy
ADD ./config/dockerflix-sniproxy.conf /etc/sniproxy/sniproxy.conf
RUN mkdir /etc/service/sniproxy
ADD ./config/run_sniproxy /etc/service/sniproxy/run
RUN chmod +x /etc/service/sniproxy/run

# Final cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443
VOLUME ["/etc/sniproxy"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
