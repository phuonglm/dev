# sshd
#
# VERSION               0.0.2

FROM chef/ubuntu-12.04

#RUN echo 'Acquire::http::proxy "http://username:password@proxy:3128/";' > /etc/apt/apt.conf
RUN apt-get update && apt-get install -y openssh-server sudo net-tools curl wget
RUN mkdir /var/run/sshd
RUN echo 'root:vagrant' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && service ssh stop

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -d /home/vagrant/ -m -s /bin/bash vagrant
RUN cat /etc/sudoers | grep "^vagrant" || echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /home/vagrant/.ssh && wget https://github.com/mitchellh/vagrant/blob/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys && chown vagrant:vagrant /home/vagrant/.ssh -R && chmod 600 /home/vagrant/.ssh -R
RUN mkdir /root/.ssh && wget https://github.com/mitchellh/vagrant/blob/master/keys/vagrant.pub -O /root/.ssh/authorized_keys && chown root:root /root/.ssh -R && chmod 600 /root/.ssh -R
EXPOSE 22