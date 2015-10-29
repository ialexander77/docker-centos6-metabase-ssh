# This Dockerfile will install Metabase
#  !!! Important !!!
# Please modify all variables in ENV section to your needs

FROM centos:centos6

MAINTAINER Alex Ivanov <info@myhona.net>

ENV METABASE_LATEST='http://downloads.metabase.com/v0.12.1/metabase.jar' \
    SSH_ROOTPASS='P@ssw0rd' \
    SSH_USERNAME='sshin' \
    SSH_USERPASS='P@ssw0rd'

# Update and install epel repo
RUN yum -y update --nogpgcheck && yum -y install epel-release --nogpgcheck

# System packages
RUN yum -y install --nogpgcheck nano wget bash-completion supervisor java psmisc net-tools openssh-server passwd pwgen

# Copy files to image
ADD ./start.sh /start.sh
ADD ./config.sh /config.sh

# Run commands inside image
RUN chmod 755 /*.sh
RUN /config.sh && rm -rf /config.sh

EXPOSE 3000 22

CMD ["/bin/bash", "/start.sh"]
