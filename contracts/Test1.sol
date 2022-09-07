// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract Test1 {
    event Log(uint256, uint256);

    function call1(uint256 a, uint256 b) public {
        uint256 startGas = gasleft();
        uint256[] memory amounts = this.swapTest(a, b);
        uint256 gasUsed = startGas - gasleft();
        console.log("call1 gasUsed = %s", gasUsed);
    }

    function call2(address target, bytes memory callData) public {
        uint256 startGas = gasleft();
        (bool success, bytes memory ret) = target.call(callData);
        uint256 gasUsed = startGas - gasleft();
        console.log("call2 gasUsed = %s", gasUsed);

        startGas = gasleft();
        this.test1(callData);
        gasUsed = startGas - gasleft();
        console.log("call bytes memory gasUsed = %s", gasUsed);

        startGas = gasleft();
        (uint256 a, uint256 b) = abi.decode(callData, (uint256, uint256));
        gasUsed = startGas - gasleft();
        console.log("abi.decode gasUsed = %s", gasUsed);

        startGas = gasleft();
        this.test2(a, b);
        gasUsed = startGas - gasleft();
        console.log("direct call gasUsed = %s", gasUsed);
    }

    function test1(bytes memory callData) external {}
    function test2(uint256 a, uint256 b) external {}

    function swapTest(uint256 a, uint256 b)
        external
        returns (uint256[] memory amounts)
    {
        amounts = new uint256[](2);
        amounts[0] = a + 100;
        amounts[1] = b + 100;
        emit Log(amounts[0], amounts[1]);
    }
}
