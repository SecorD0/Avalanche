#!/bin/bash
avalanche_version=`wget -qO- https://api.github.com/repos/ava-labs/avalanchego/releases/latest | jq -r ".tag_name" | sed "s%v%%g"`
wget -qO- "https://github.com/ava-labs/avalanchego/releases/download/v${avalanche_version}/avalanchego-linux-amd64-v${avalanche_version}.tar.gz" | tar --strip-components 1 -xzf -
./avalanchego "$@"
