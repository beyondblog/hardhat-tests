import { ethers, upgrades } from "hardhat"

async function main() {

  const Test1 = await ethers.getContractFactory("Test1")
  var test1 = await Test1.deploy()
  await test1.deployed()

  var inputData = Test1.interface.encodeFunctionData("swapTest", ['100','200'])
  console.log(inputData)

  console.log('address: ' + test1.address)
  var transaction = await test1.call1('100', '200')
  var receipt = await ethers.provider.getTransactionReceipt(transaction.hash)
  console.log(`call1 gas use ${receipt.gasUsed} of ${transaction.gasLimit}`)

  transaction = await test1.call2(test1.address, inputData)
  var receipt = await ethers.provider.getTransactionReceipt(transaction.hash)
  console.log(`call2 gas use ${receipt.gasUsed} of ${transaction.gasLimit}`)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
});
