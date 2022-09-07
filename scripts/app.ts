import { ethers, upgrades } from "hardhat";

async function main() {

  const App1 = await ethers.getContractFactory("App1");
  const App2 = await ethers.getContractFactory("App2");

  const proxy = await upgrades.deployProxy(App1);
  await proxy.deployed()

  // 获取当前代理合约的升级地址是多少
  var implementationAddress = await upgrades.erc1967.getImplementationAddress(proxy.address);
  var version = await proxy.functions.getVersion()
  console.log(`proxy implementation address ${implementationAddress} version ${version}`)

  var value =  await proxy.functions.getValue();
  console.log(`app1 get before value ${value}`)
  await proxy.functions.setValue(10)
  console.log("set app1 value")
  value =  await proxy.functions.getValue();
  console.log(`app1 get after value ${value}`)
  await upgrades.upgradeProxy(proxy.address, App2);

  // 重新获取下当前实现的地址是多少
  implementationAddress = await upgrades.erc1967.getImplementationAddress(proxy.address);
  version = await proxy.functions.getVersion()
  console.log(`proxy implementation address ${implementationAddress} version ${version}`)

  var value =  await proxy.functions.getValue();
  console.log(`app2 get value ${value}`)

  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
