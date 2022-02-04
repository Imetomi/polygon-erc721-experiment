require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');

const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString().trim();

module.exports = {
  defaultNetwork: "matic",
  networks: {
    hardhat: {
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}
