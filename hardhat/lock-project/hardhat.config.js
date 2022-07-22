//require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
const PRIVATE_KEY = process.env.PRIVATE_KEY;


module.exports = {
    solidity: "0.8.2",
    networks: {
      hardhat:{
        url :process.env.ALCHEMY_URL,
      },
      mainnet: {
        url: `https://api.avax.network/ext/bc/C/rpc`,
        accounts: [`${PRIVATE_KEY}`]
      },
      fuji: {
        url: `https://api.avax-test.network/ext/bc/C/rpc`,
          accounts: [`${PRIVATE_KEY}`]
      }
    }
};