// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IFluentRust {
    function rustUint256() external view returns (uint256);    
}

interface IERC20 {        
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract FluentSdkRustTypesTest {

    IFluentRust public fluentRust;
    IERC20 public token;

    address public constant tokenAddress = 0x9030e7aa523b19D6A9d2327d45d3A3287b3EfAE1;

    uint256 public reserveToken;
    uint256 public reserveNative;

    constructor(address FluentRustAddress) {
        fluentRust = IFluentRust(FluentRustAddress);
            token = IERC20(0x9030e7aa523b19D6A9d2327d45d3A3287b3EfAE1);

    }

    function getRustUint256() external view returns (uint256) {
        uint256 rustUint256 = fluentRust.rustUint256();
        return rustUint256;
    }

    receive() external payable {}

    function addLiquidity(uint256 tokenAmount) external payable {
        require(tokenAmount > 0 && msg.value > 0, "Invalid amounts");

        token.transferFrom(msg.sender, address(this), tokenAmount);
        reserveToken += tokenAmount;
        reserveNative += msg.value;
    }

    function getPriceNativeToToken(uint256 ethIn) public view returns (uint256) {
        require(reserveNative > 0 && reserveToken > 0, "Empty pool");
        return (ethIn * reserveToken) / reserveNative;
    }

    function getPriceTokenToNative(uint256 tokenIn) public view returns (uint256) {
        require(reserveNative > 0 && reserveToken > 0, "Empty pool");
        return (tokenIn * reserveNative) / reserveToken;
    }

    function swapNativeToToken() external payable {
        require(msg.value > 0, "No ETH sent");

        uint256 tokenOut = getPriceNativeToToken(msg.value);
        require(tokenOut <= reserveToken, "Not enough liquidity");

        reserveNative += msg.value;
        reserveToken -= tokenOut;

        token.transfer(msg.sender, tokenOut);
    }

    function swapTokenToNative(uint256 tokenIn) external {
        require(tokenIn > 0, "Zero input");

        uint256 ethOut = getPriceTokenToNative(tokenIn);
        require(ethOut <= reserveNative, "Not enough liquidity");

        token.transferFrom(msg.sender, address(this), tokenIn);

        reserveToken += tokenIn;
        reserveNative -= ethOut;

        payable(msg.sender).transfer(ethOut);
    }
}
