import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { ethers } from "hardhat";


describe("Test2", function () {
    it("test call", async function () {
        const TestCoin = await ethers.getContractFactory("TestCoin");
        const testCoin = await TestCoin.deploy('DOGE', 1000000000000,8);
        const [owner] = await ethers.getSigners();
        var balance = await testCoin.balanceOf(owner.address);
        console.log(`${owner.address} balance = ${balance}`)
        const Test2 = await ethers.getContractFactory("Test2");
        const test2 = await Test2.deploy(testCoin.address);
        await test2.test1(10);

        var targetAddress = testCoin.address;
        var inputData = TestCoin.interface.encodeFunctionData("balanceOf", [owner.address]);

        console.log(inputData);
        var calls = [];

        for(var i = 0;i<10;i++) {
           calls.push(inputData); 
        }
        await test2.test2(targetAddress, calls);
    });

});

  
