// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "./IERC20.sol";

contract Test2 {
    IERC20 private USDT;

    constructor(address coin) {
        USDT = IERC20(coin);
    }

    function test1(int256 count) external {
        address user = msg.sender;
        uint256 startGas = gasleft();
        for (int256 i = 0; i < count; i++) {
            USDT.balanceOf(user);
        }
        uint256 gasUsed = startGas - gasleft();
        console.log("test1 gasUsed = %s", gasUsed);
    }

    function test2(address target, bytes[] memory calls) external {
        console.log(calls.length);
        uint256 startGas = gasleft();
        for (uint256 i = 0; i < calls.length; i++) {
            target.call(calls[i]);
        }
        uint256 gasUsed = startGas - gasleft();
        console.log("test2 gasUsed = %s", gasUsed);
    }
}
