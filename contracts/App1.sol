// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract App1 {

    uint256 private value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 v) public {
        value = v;
    }

    function getVersion() public pure returns (string memory) {
        return "v1";
    }
}