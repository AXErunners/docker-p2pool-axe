# Dockerfile for P2Pool-AXE Server
# https://www.axerunners.com

FROM alpine as builder
MAINTAINER AXErunners
LABEL description="Dockerized P2Pool-AXE"

WORKDIR /p2pool
ENV P2POOL_AXE_HOME /p2pool/p2pool-axe
ENV P2POOL_AXE_REPO https://github.com/axerunners/p2pool-axe

RUN apk --no-cache add \
    git \
    perl \
    python \
    python-dev \
    py-twisted \
    gcc \
    g++ \
  && git clone $P2POOL_AXE_REPO $P2POOL_AXE_HOME \
  && cd $P2POOL_AXE_HOME \
  && git submodule init \
  && git submodule update \
  && cd axe_hash && python setup.py install && cd .. \
  && apk -v del \
    git \
    python-dev \
    perl \
    gcc \
    g++

FROM alpine
MAINTAINER AXErunners
LABEL description="Dockerized P2Pool-AXE"
WORKDIR /p2pool
RUN apk --no-cache add python py-twisted
COPY --from=builder /p2pool/p2pool-axe .
EXPOSE 7923 8999 17923 18999

ENV P2POOL_AXE_HOME /p2pool/p2pool-axe
WORKDIR $P2POOL_AXE_HOME
RUN chown -R nobody $P2POOL_AXE_HOME
USER nobody

ENV AXE_RPCUSER axerpc
ENV AXE_RPCPASSWORD 4C3NET7icz9xNE3CY1X7eSVrtpmSb6KcjEgMJW3armRV
ENV AXE_RPCHOST 192.168.99.1
ENV AXE_RPCPORT 9337
ENV AXE_P2PPORT 9937
ENV AXE_FEE 0
ENV AXE_DONATION 0
ENV AXE_ADDRESS PH52QidRqvgAqmnaLwCFVG4bvaNkAN7qAX
ENV AXE_OTHER_PARAM --no-bugreport --disable-advertise

# Default arguments, can be overriden
CMD python run_p2pool.py \
  --give-author $AXE_DONATION \
  -f $AXE_FEE \
  -a $AXE_ADDRESS \
  --axed-address $AXE_RPCHOST \
  --axed-rpc-port $AXE_RPCPORT \
  --axed-p2p-port $AXE_P2PPORT \
  $AXE_OTHER_PARAM \
  $AXE_RPCUSER $AXE_RPCPASSWORD

# End.
