// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract TestDex {
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {
        console.log(
            "call swapTokensForExactTokens amountOut = %d amountInMax = %d",
            amountOut,
            amountInMax
        );
        amounts = new uint256[](2);
        amounts[0] = 888;
        amounts[1] = 999;
    }
}
