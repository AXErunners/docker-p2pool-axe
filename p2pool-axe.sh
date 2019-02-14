#!/bin/bash
set -e

docker=$(which docker)

case "$1" in
  install)
    "$docker" pull axerunners/docker-p2pool-axe:latest
    ;;
  start)
    "$docker" run -d -p 0.0.0.0:7923:7923 -p 0.0.0.0:8999:8999 --env-file=env-mainnet --name p2pool-axe axerunners/docker-p2pool-axe:latest
    ;;
  stop)
    "$docker" stop p2pool-axe
    ;;
  start-testnet)
    "$docker" run -d -p 0.0.0.0:17923:17923 -p 0.0.0.0:8999:8999 --env-file=env-testnet --name p2pool-axe-testnet axerunners/docker-p2pool-axe:latest
    ;;
  stop-testnet)
    "$docker" stop p2pool-axe-testnet
    ;;

  uninstall)
    "$docker" rm p2pool-axe
    "$docker" rm p2pool-axe-testnet
    "$docker" rmi axerunners/docker-p2pool-axe
    ;;
  *)
    echo "Usage: $0 [install|start|stop|start-testnet|stop-testnet|uninstall]"
    exit 1
    ;;
esac

