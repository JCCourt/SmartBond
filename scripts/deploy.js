import hre from "hardhat";

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const TimeLockedBond = await hre.ethers.getContractFactory("TimeLockedBond");
  const contract = await TimeLockedBond.deploy(deployer.address);

  await contract.deployed();
  console.log("TimeLockedBond deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});