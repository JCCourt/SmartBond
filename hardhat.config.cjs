require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const config = {
  solidity: "0.8.28",
  networks: {
    // Sepolia testnet using Alchemy
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111,
    },
  },
  // Default network for Sepolia
  defaultNetwork: "sepolia",
};

module.exports = config;