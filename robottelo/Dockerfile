FROM fedora:latest
MAINTAINER https://github.com/SatelliteQE

ENV HOME /root
WORKDIR /root

RUN dnf -y update; dnf clean all
RUN dnf install -y git python-devel python-pip
RUN dnf install -y gcc make redhat-rpm-config

# Upgrade pip itself
RUN pip install --upgrade pip

# Clone Robottelo
RUN git clone https://github.com/SatelliteQE/robottelo.git

# Install Python deps
RUN cd robottelo && pip install -r requirements.txt
RUN cd robottelo && pip install -r requirements-optional.txt

ADD startup.sh /tmp/
RUN chmod +x /tmp/startup.sh

# Clean up
RUN rm -rf /root/robottelo

# runtime
EXPOSE 22

CMD /tmp/startup.sh
