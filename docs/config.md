groestlcoind config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v groestlcoind-data:/groestlcoin --name=groestlcoind-node -d \
            -p 1331:1331 \
            -p 127.0.0.1:1441:1441 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            groestlcoin/groestlcoind

Or you can use your very own config file like that:

        docker run -v groestlcoind-data:/groestlcoin --name=groestlcoind-node -d \
            -p 1331:1331 \
            -p 127.0.0.1:1441:1441 \
            -v /etc/mygroestlcoin.conf:/groestlcoin/.groestlcoin/groestlcoin.conf \
            groestlcoin/groestlcoind
