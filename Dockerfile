# sshd
#
# VERSION               0.0.2

FROM chef/ubuntu-12.04

RUN echo 'Acquire::http::proxy "http://username:password@proxy:port/";' > /etc/apt/apt.conf

ENV http_proxy http://username:password@proxy:port/
ENV HTTP_PROXY $(http_proxy)
ENV HTTPS_PROXY $(http_proxy)
ENV ALL_PROXY $(http_proxy)

RUN echo 'export http_proxy=http://username:password@proxy:port/' >> /etc/profile && echo 'export HTTP_PROXY=http://username:password@proxy:port/' >> /etc/profile && echo 'export HTTPS_PROXY=http://username:password@proxy:port/' >> /etc/profile && echo 'export ALL_PROXY=http://username:password@proxy:port/'

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
# generate a nice UTF-8 locale for our use
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "export DEBIAN_FRONTEND=noninteractive" >> /etc/profile
# let Upstart know it's in a container
RUN echo "container=docker" >> /etc/profile

RUN apt-get update && apt-get install apt-utils -y && apt-get install -y openssh-server sudo net-tools curl wget
RUN mkdir /var/run/sshd
RUN echo 'root:vagrant' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && service ssh stop

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


RUN useradd -d /home/vagrant/ -m -s /bin/bash vagrant
RUN cat /etc/sudoers | grep "^vagrant" || echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /home/vagrant/.ssh && wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys && chown vagrant:vagrant /home/vagrant/.ssh -R && chmod 600 /home/vagrant/.ssh -R
RUN mkdir /root/.ssh && wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /root/.ssh/authorized_keys && chown root:root /root/.ssh -R && chmod 600 /root/.ssh -R
EXPOSE 22