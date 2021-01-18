Groestlcoind for Docker
===================

Docker image that runs the Groestlcoin groestlcoind node in a container for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 5 GB to store the block chain files (and always growing!)
* At least 1 GB RAM + 2 GB swap file


Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/Groestlcoin/docker-groestlcoind/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `groestlcoind-data` volume to persist the groestlcoind blockchain data, should exit immediately.  The `groestlcoind-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=groestlcoind-data
        docker run -v groestlcoind-data:/groestlcoin --name=groestlcoind-node -d \
            -p 1331:1331 \
            -p 127.0.0.1:1441:1441 \
            Groestlcoin/groestlcoind

2. Verify that the container is running and groestlcoind node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        Groestlcoin/groestlcoind:latest     "grs_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:1441->1441/tcp, 0.0.0.0:1331->1331/tcp   groestlcoind-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f groestlcoind-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
