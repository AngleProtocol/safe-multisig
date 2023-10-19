# Safe Multisig

This repo contains scripts to push transaction to multisigs associated to Angle Protocol on Gnosis.
More generally, signers of multisig can also use this repo to check that the transactions they see on the Gnosis Safe interface on the front correspond to what they expect.

## Getting started

### Install Foundry

If you don't have Foundry:

```bash
curl -L https://foundry.paradigm.xyz | bash

source /root/.zshrc
# or, if you're under bash: source /root/.bashrc

foundryup
```

To install the standard library:

```bash
forge install foundry-rs/forge-std
```

To update libraries:

```bash
forge update
```

### Install packages

You can install all dependencies by running

```bash
yarn
forge i
```

Install python dependencies (see [.requirements.txt](./requirements.txt)):

## Setup environment

## Pre-requisites

You must provide some necessary environment variables (see [.env.example](./.env.example)):

```env
SAFE = ""
CHAIN_ID = ""
DELEGATE_ADDRESS = ""
DELEGATOR_ADDRESS = ""
DELEGATOR_PRIVATE_KEY = ""

ETH_NODE_URI_RINKEBY=""
MNEMONIC_RINKEBY=""

ETH_NODE_URI_MAINNET=""
ETH_NODE_URI_POLYGON=""
ETH_NODE_URI_OPTIMISM=""
ETH_NODE_URI_ARBITRUM=""
ETH_NODE_URI_AVALANCHE=""
ETH_NODE_URI_FORK=""
```

For more chains support add the necessary URIs for your specific chains

## Gnosis interactions

### Add Delegate

The [addDelegate.py](./addDelegate.py) file helps to add a delegate to a Gnosis Safe. A delegate is an address that can propose transactions to a Gnosis Safe, it does not have any on-chain right. The delegate address just has the right to mess up with the portal of waiting transactions associated to a safe. There are some other utility functions in this file.

The reason for introducing a delegate is that the address of the delegate can be unsafe and its private key can be stored in clear (because it never directly interacts with the blockchain).

### Scripts: Propose and Verify

You can run a script with

```bash
yarn script:fork
```

which will generate an object in [scripts/foundry/transaction.json](scripts/foundry/transaction.json) with properties: chainId, data,operation,to,value. These are required to pass a transaction on Gnosis Safe.

Some scripts need to make on chain calls, so you should run beforehand:

```bash
yarn fork:{CHAIN_NAME}
```

Don't forget to update the scripts in [./package.json](./package.json)

#### Push a transaction to Gnosis

Simply run:

```bash
yarn submit:foundry
```

Make sure that your [.env](./.env) is correctly set for this and that you have the right values in `[scripts/foundry/transaction.json](scripts/foundry/transaction.json)
