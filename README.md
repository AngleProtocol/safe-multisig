# Safe Multisig Boilerplate

Streamline your [Safe multisig](https://safe.global/) transaction maintenance using [Foundry](https://github.com/foundry-rs/foundry).

# Table of Contents

- [What is it?](#what-is-it)
- [Usage](#usage)
  - [Overview](#overview)
  - [Add Delegate](#add-delegate)
  - [Scripts: Propose](#scripts-propose)
  - [Scripts: Verify](#scripts-verify)
  - [Push Transaction to Gnosis](#push-a-transaction-to-gnosis)
- [Examples](#examples)
- [Getting Started](#getting-started)
  - [Install Foundry](#install-foundry)
  - [Install Packages](#install-packages)
  - [Setup Environment](#setup-environment)

## What is it?

At [AngleProtocol](https://github.com/AngleProtocol), there are some maintenance done through [Safe](https://safe.global/) multisigs. Doing this manually through the Safe interface can be cumbersome, especially when dealing with numerous transactions.

First, because you can end up with tens-hundreds of transactions doing the same logic but for different parameters/collaterals/etc. Also because building transactions by hand with the `Transaction Builder` can be error prone and fastidious. And more.

Our challenges included:

- set borrowing rates accross all collaterals and al chains
- set savings agEUR (stEUR) on all chains. Defining the annual return on staked agEUR
- whitelist tokens: Merkl reward tokens,...

These are specific examples, but it is generalizable to any need you have.

We are big supporters of [Safe](https://safe.global/) and [Foundry](https://github.com/foundry-rs/foundry), so we decided to build a tool leveraging both. With the goa lto make protocol contributors, institutional safe owner and personal safe owners life easier to manage any multisig interaction: protocol maintenance, funds, and more.

## Usage

### Overview

To manage the multisig:

1. Initially (done only once) set up a delegate for your organization to propose transactions on the Safe interface.
2. For any new transaction, use a Foundry script to create (even a bundle of actions). Test this via Foundry, and then push it with the delegate address to Safe.
3. Multisig owners will then sign the transaction to execute it.

### Add Delegate

The [addDelegate.py](./addDelegate.py) file helps to add a delegate to a Gnosis Safe. A delegate is an address that can propose transactions to a Gnosis Safe, it does not have any on-chain right. The delegate address just has the right to mess up with the portal of waiting transactions associated to a safe. There are some other utility functions in this file.

The reason for introducing a delegate is that the address of the delegate can be unsafe and its private key can be stored in clear (because it never directly interacts with the blockchain).

### Scripts: Propose

#### Fork

Some scripts need to make on chain calls, so you should run beforehand:

```bash
yarn fork:{CHAIN_NAME}
```

Don't forget to update the scripts in [./package.json](./package.json), if you are building on other chains.

#### Build the transaction

You can run a script with

```bash
yarn script:fork <script-path> 
```

For example:

```bash
yarn script:fork scripts/foundry/Example.s.sol 
```

which will generate an object in [scripts/foundry/transaction.json](scripts/foundry/transaction.json) with properties: chainId, data, operation, to, value. These are required to pass a transaction on Gnosis Safe.

#### Full expressivity

You can craft any script within the [folder](scripts/foundry/) using Foundry

### Scripts: Verify

Always test the transaction for validity: the multisig has the right to execute the transaction, verify the expected outcome.

After generating the object via [Scripts: Propose](#scripts:-Propose), run:

```bash
yarn test <test-contract-name>
```

E.g.:

```bash
yarn test ExampleTest
```

### Push a transaction to Gnosis

Once satisfied, push the transaction to Safe:

```bash
yarn submit:foundry
```

Ensure your [.env](./.env) is correctly set up, and you have the correct values in [scripts/foundry/transaction.json](scripts/foundry/transaction.json)

## Examples

This repository provides a general-purpose boilerplate. For specific implementations, refer to:

- [Angle Multisig](https://github.com/AngleProtocol/angle-multisig): set with one call all CDP (aka Borrow module) interest rate on all collaterals, set PSM (aka Transmuter) fee structure,...
- More examples will be added

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
