// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

// import {Test, console} from "forge-std/Test.sol";
// import {FluentSdkRustTypesTest, IFluentRust} from "../src/FluentSdkRustTypesTest.sol";

// contract FluentSdkRustTypesTestTest is Test {

//     FluentSdkRustTypesTest public fluentSdkRustTypesTest;

//     address constant rustContractFluentTestnet = 0x04160C19738bB6429c0554fBdC11A96079D7297D;

//     function setUp() public {
//         fluentSdkRustTypesTest = new FluentSdkRustTypesTest(rustContractFluentTestnet);
//     }

//     function test_get_fluentRust() view public {
//         IFluentRust test_fluentRust = fluentSdkRustTypesTest.fluentRust();
//         address rustContractAddress = address(test_fluentRust);
//         assertEq(rustContractAddress, rustContractFluentTestnet);
//     }
    
//     function test_get_string() view public {
//         string memory test_string = fluentSdkRustTypesTest.getRustString();
//         assertEq(test_string, "Hello World");
//     }

//     function test_get_uint256() view public {
//         uint256 test_uint256 = fluentSdkRustTypesTest.getRustUint256();
//         assertEq(test_uint256, 10);
//     }

//     function test_get_int256() view public {
//         int256 test_int256 = fluentSdkRustTypesTest.getRustInt256();
//         assertEq(test_int256, -10);
//     }

//     function test_get_address() view public {
//         address test_address = fluentSdkRustTypesTest.getRustAddress();
//         assertEq(test_address, 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);
//     }

//     function test_get_bytes32() view public {
//         bytes32 test_bytes32_contract = fluentSdkRustTypesTest.getRustBytes32();
//         bytes32 test_bytes32_value = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
//         assertEq(test_bytes32_contract, test_bytes32_value);
//     }

//     function test_get_bytes() view public {
//         bytes memory test_bytes_contract = fluentSdkRustTypesTest.getRustBytes();
//         bytes memory test_bytes_value = hex"464c55454e54";
//         assertEq(test_bytes_contract, test_bytes_value);
//     }

//     function test_get_bool() view public {
//         bool test_bool = fluentSdkRustTypesTest.getRustBool();
//         assertEq(test_bool, true);
//     }

// }
