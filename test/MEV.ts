import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { ethers } from "hardhat";

describe("MEV", function () {
  it("test call", async function () {
    const TestDex = await ethers.getContractFactory("TestDex");
    const testDex = await TestDex.deploy();
    const MEV = await ethers.getContractFactory("MEV");
    const mev = await MEV.deploy();

    var inputData = TestDex.interface.encodeFunctionData(
      "swapTokensForExactTokens",
      [1, 100, [], mev.address, 0]
    );
    console.log(inputData);

    mev.go([
      {
        target: testDex.address,
        appendPreOutput: [],
        callData: inputData,
      },
      {
        target: testDex.address,
        appendPreOutput: [96, 4 + 32, 128, 4 + 64],
        callData: inputData,
      },
    ]);
  });
});
