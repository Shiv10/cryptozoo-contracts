const { ethers } = require('hardhat');

async function main() {
  const CryptToken = ethers.getContractFactory("CryptToken");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
