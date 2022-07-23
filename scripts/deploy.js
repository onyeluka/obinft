const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");


async function main() {
const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
const metadataURL = METADATA_URL;
const PeterObiContract = await ethers.getContractFactory("PeterObi");
const deployedPeterObiContract = await  PeterObiContract.deploy(
  metadataURL,
  whitelistContract
);
console.log(
  "Peter Obi Contract Address:",deployedPeterObiContract.address );
}


main()
.then(()=> process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});
