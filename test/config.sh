#!/bin/bash
set -e

testAlias+=(
	[groestlcoind:trusty]='groestlcoind'
)

imageTests+=(
	[groestlcoind]='
		rpcpassword
	'
)
