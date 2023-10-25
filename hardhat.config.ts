/// ENVVAR
// - ENABLE_GAS_REPORT
// - CI
// - RUNS
import "dotenv/config";

import yargs from "yargs";
import { nodeUrl, accounts } from "./utils/network";
import { HardhatUserConfig } from "hardhat/config";

import "hardhat-contract-sizer";
import "hardhat-spdx-license-identifier";
import "hardhat-docgen";
import "hardhat-deploy";
import "hardhat-abi-exporter";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-truffle5";
import "@nomiclabs/hardhat-solhint";
import "solidity-coverage";
import "@typechain/hardhat";

const argv = yargs
  .env("")
  .boolean("ci")
  .number("runs")
  .boolean("fork")
  .boolean("disableAutoMining");

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000000,
          },
        },
      },
    ]
  },
  defaultNetwork: "hardhat",
  networks: {
    mainnet: {
      live: true,
      url: nodeUrl("mainnet"),
      accounts: accounts("mainnet"),
      gas: "auto",
      gasMultiplier: 1.3,
      chainId: 1,
    },
  },
  paths: {
    sources: "./scripts/utils",
    tests: "./tests",

  },
  namedAccounts: {
    deployer: 0,
  },
};

export default config;
