# sshd
#
# VERSION               0.0.2

FROM chef/ubuntu-12.04

RUN apt-get update && apt-get install -y openssh-server sudo
RUN mkdir /var/run/sshd
RUN echo 'root:vagrant' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -d /home/vagrant/ -m -s /bin/bash vagrant
RUN cat /etc/sudoers | grep "^vagrant" || echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22