# Debugging

## Things to Check

* RAM utilization -- groestlcoind is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The groestlcoin blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 4GB+ is necessary.

## Viewing groestlcoind Logs

    docker logs groestlcoind-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the groestlcoind node, but will not connect to already running containers or processes.

    docker run -v groestlcoind-data:/groestlcoin --rm -it Groestlcoin/groestlcoind bash -l

You can also attach bash into running container to debug running groestlcoind

    docker exec -it groestlcoind-node bash -l
