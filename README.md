# Safe Multisig Boilerplate

Streamline your [Safe multisig](https://safe.global/) transaction maintenance using [Foundry](https://github.com/foundry-rs/foundry).

## Table of Contents

- [Why a multisig management repo?](#why-a-multisig-management-repo)
- [Usage](#usage)
  - [Overview](#overview)
  - [Add Delegate](#add-delegate)
  - [Propose a transaction](#propose-a-transaction)
  - [Verify a transaction](#verify-a-transaction)
  - [Push Transaction to Gnosis](#push-a-transaction-to-gnosis)
- [Examples](#examples)
- [Getting Started](#getting-started)
  - [Install Foundry](#install-foundry)
  - [Install Packages](#install-packages)
  - [Setup Environment](#setup-environment)

## Why a multisig management repo?

Maintenance of smart contracts system through [Safe](https://safe.global/) multisigs can be cumbersome, especially if relying on the Safe interface to do this.

You may end up doing tens or hundreds of transactions with the same logic but different parameters, or craft complex transactions with the `Transaction Builder` which can be error prone and fastidious.

This repo leverages both [Safe](https://safe.global/) and [Foundry](https://github.com/foundry-rs/foundry) to make the life of protocol contributors, institutional safe owner or personal safe owners easier when it comes to dealing with multisig interaction. This applies to any type of use case whether it is protocol maintenance, streaming funds, launching new features and more.

## Usage

### Overview

To manage a multisig with this repo:

1. Initially (done only once) set up a delegate for your organization to propose transactions on the Safe interface.
2. For any new transaction, use a Foundry script to create (even a bundle of actions). Test this via Foundry, and then push it with the delegate address to Safe.
3. Multisig owners will then sign the transaction to execute it.

### Add Delegate

The [addDelegate.py](./addDelegate.py) file helps to add a delegate to a Gnosis Safe.

A delegate is an address that can propose transactions to a Gnosis Safe, it does not have any onchain right. The delegate address just has the right to mess up with the portal of waiting transactions associated to a safe. There are some other utility functions in this file.

The reason for introducing a delegate is that the address of the delegate can be unsafe and its private key can be stored in clear (because it never directly interacts with the blockchain).

### Propose a transaction

#### Build your script

To propose a transaction through the Gnosis Safe UI, what you first need is a script corresponding to the transaction you want to push.

For example: `scripts/foundry/Example.s.sol` contains an example of a script designed to build the transaction to pause an ERC20 token that is pausable.

You can craft any script within the [folder](scripts/foundry/) using Foundry

In any case, you will need the script to compile before running it and so if calling functions of other contracts, you'll most likely need to provide the Solidity interfaces of the contracts that you'll be calling from your script.

Once your script is ready, you can then prepare to submit it to your Gnosis Safe so your signers just have to sign it.

#### Fork

Your script may need to make on chain calls, so you should run beforehand:

```bash
yarn fork:{CHAIN_NAME}
```

Don't forget to update the scripts in [./package.json](./package.json), if you are building on other chains.

#### Build the transaction

You can run a script with:

```bash
yarn script:fork <script-path>
```

For example:

```bash
yarn script:fork scripts/foundry/Example.s.sol
```

This will generate an object in [scripts/foundry/transaction.json](scripts/foundry/transaction.json) with properties: chainId, data, operation, to, value. These are required to pass a transaction on Gnosis Safe.

### Verify a transaction

You may want to test the validity of the transaction you submit to your multisig and verify the expected outcome.

To do this, after generating the object via [Propose a Transaction](#propose-a-transaction), you can run:

```bash
yarn test <test-contract-name>
```

E.g.:

```bash
yarn test ExampleTest
```

### Push a transaction to Gnosis

Once your tests are satisfied, you can push the transaction to your Safe with:

```bash
yarn submit:foundry
```

Ensure your [.env](./.env) is correctly set up, and you have the correct values and addresses in [scripts/foundry/transaction.json](scripts/foundry/transaction.json)

## Examples

This repository provides a general-purpose boilerplate. For specific implementations, refer to [Angle Multisig](https://github.com/AngleProtocol/angle-multisig) repo which has examples of how to set interest rates across all Angle collateral assets or modify the fee structure of the PSM (aka Transmuter).

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
PRIVATE_KEY = ""

ETH_NODE_URI_MAINNET=""
ETH_NODE_URI_POLYGON=""
ETH_NODE_URI_OPTIMISM=""
ETH_NODE_URI_ARBITRUM=""
ETH_NODE_URI_AVALANCHE=""
```

For more chains support add the necessary URIs for your specific chains.
