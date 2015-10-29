docker-centos6-metabase-ssh
========================

This repo contains a recipe for making Docker container for SSH and Metabase on CentOS 6. 

Check your Docker version

    # docker version

Perform the build

    # docker build -rm -t <yourname>/docker-centos6-metabase-ssh .

As an alternate execute the script:

    # docker_build_image.sh

Check the image out.

    # docker images

Run it:

    # docker run -d -p 3000:3000 -p 2222:22 <yourname>/docker-centos6-metabase-ssh

Lasy way - modify first and run the script:

    # docker_run_container.sh

Get container ID:

    # docker ps -a

Keep in mind to change variables in Docker 'ENV' section:

The default values are, you can login to container using root or sshin user:

    SSH_ROOTPASS='P@ssw0rd'
    SSH_USERNAME='sshin'
    SSH_USERPASS='P@ssw0rd'
