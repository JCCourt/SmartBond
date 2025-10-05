import "@nomicfoundation/hardhat-ethers";
import dotenv from "dotenv";

dotenv.config();

const config = {
  solidity: "0.8.28",
  networks: {
    // Local Hardhat network (default)
    hardhat: {
      chainId: 31337,
    },
    // Local network (if you're running hardhat node)
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
    // Sepolia testnet using Alchemy
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111,
    },
  },
  // Default network for when no --network flag is specified
  defaultNetwork: "hardhat",
};

export default config;