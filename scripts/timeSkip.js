// Script to time skip 1 year and test withdraw
import hre from "hardhat";
import contractJson from "../artifacts/contracts/TimeLockedBond.sol/TimeLockedBond.json" assert { type: "json" };

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Update if needed
  const contractABI = contractJson.abi;
  const contract = new hre.ethers.Contract(contractAddress, contractABI, deployer);

  // Skip 1 year (365 days)
  const seconds = 365 * 24 * 60 * 60;
  await hre.network.provider.send("evm_increaseTime", [seconds]);
  await hre.network.provider.send("evm_mine");
  console.log(`Skipped ${seconds} seconds (1 year)`);

  // Time skip only; no automatic withdraw
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
