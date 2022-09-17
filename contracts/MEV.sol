// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract MEV {
    struct Call {
        address target;
        bytes callData;
        // 二元组 提取上一次参数的位置, 放入callData的位置
        uint8[] appendPreOutput;
    }

    function test1() public {
        uint256 p1 = 1;
        uint256 p2 = 2;
        bytes memory preOutput = abi.encode(p1, p2);
        bytes32 a;
        bytes32 b;
        console.log("preOutput before = ");
        console.logBytes(preOutput);
        assembly {
            // 获取 0 ~ 32 字节的数据
            a := mload(add(preOutput, 32))
            // 获取 32 ~ 64 字节的数据
            b := mload(add(preOutput, 64))
            // 修改 0 ~32字节用b替换
            mstore(add(preOutput, 32), b)
        }

        console.log("preOutput after = ");
        console.logBytes(preOutput);
        // 分割出 p1 和 p2 两个变量
        console.logBytes32(a);
        console.logBytes32(b);
    }

    function go(Call[] calldata calls) public {
        bytes memory preOutput;
        bool success;
        bytes memory callData;
        for (uint8 i = 0; i < calls.length; i++) {
            callData = calls[i].callData;
            if (preOutput.length > 0 && calls[i].appendPreOutput.length > 0) {
                // 加工上一次的参数结果
                for (uint8 j = 0; j < calls[i].appendPreOutput.length; j += 2) {
                    // bytes拼接处理
                    uint8 fromParamPos = calls[i].appendPreOutput[j];
                    uint8 toParamPos = calls[i].appendPreOutput[j + 1];
                    bytes32 a;
                    assembly {
                        a := mload(add(preOutput, fromParamPos))
                        mstore(add(callData, toParamPos), a)
                    }
                }
                // console.log("after callData=");
                // console.logBytes(callData);
            }

            (success, preOutput) = calls[i].target.call(callData);
            console.log("success = %s", success);
            // console.log("callData=");
            // console.logBytes(calls[i].callData);
            // console.log("preOutput=");
            // console.logBytes(preOutput);
        }
    }

    function toUint256(bytes memory _bytes, uint256 _start)
        internal
        pure
        returns (uint256)
    {
        uint256 tempUint;
        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }
        return tempUint;
    }
}
