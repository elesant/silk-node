FROM ubuntu

# REPOS
RUN apt-get update; apt-get install -y -q software-properties-common python-software-properties

# LANGUAGE
RUN apt-get install -y -q language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8; dpkg-reconfigure locales

# DEFAULT
RUN apt-get install -y -q curl git make wget openssh-server zip tmux vim nano python python-setuptools

# INSTALL NODE
RUN cd /usr/local && curl http://nodejs.org/dist/v0.10.22/node-v0.10.22-linux-x64.tar.gz | tar --strip-components=1 -zxf- && cd
RUN npm -g update npm
RUN npm install -g forever

# RUNNING
RUN easy_install supervisor
ADD ./configs/supervisord.conf /etc/supervisord.conf
RUN mkdir /var/log/supervisor/
RUN mkdir /var/run/sshd

# USER
RUN adduser --disabled-password --gecos "" kite; usermod -a -G sudo kite
RUN echo "kite	ALL=NOPASSWD: ALL" >> /etc/sudoers
ADD app /home/kite/workspace
RUN mkdir /home/kite/.ssh

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 8000
EXPOSE 22

CMD ["/bin/bash", "/start.sh"]
