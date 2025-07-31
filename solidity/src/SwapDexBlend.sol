// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IFluentRust {
    function rustUint256() external view returns (uint256);    
    function rustGetPriceEthToToken(uint256,uint256,uint256) external view returns (uint256);    
    function rustGetPriceTokenToEth(uint256,uint256,uint256) external view returns (uint256);    
}

interface IERC20 {        
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SwapDexBlend {

    IFluentRust public fluentRust;
    IERC20 public token;

    address public constant tokenAddress = 0x9030e7aa523b19D6A9d2327d45d3A3287b3EfAE1;

    uint256 public reserveToken;
    uint256 public reserveEth;

    constructor(address FluentRustAddress) {
        fluentRust = IFluentRust(FluentRustAddress);
        token = IERC20(0x9030e7aa523b19D6A9d2327d45d3A3287b3EfAE1);
    }

    function getRustUint256() external view returns (uint256) {
        uint256 rustUint256 = fluentRust.rustUint256();
        return rustUint256;
    }

    // function testRust1(uint256 ethIn) external view returns (uint256) {
    //     // uint256 priceEthToToken = fluentRust.rustGetPriceEthToToken(ethIn,reserveEth,reserveToken);
    //     uint256 priceEthToToken = fluentRust.rustGetPriceEthToToken(ethIn,100,100);
    //     return priceEthToToken;
    // }

    // function testRust2(uint256 tokenIn) external view returns (uint256) {
    //     uint256 priceTokenToEth = fluentRust.rustGetPriceTokenToEth(tokenIn,100,100);
    //     // uint256 priceEthToToken = fluentRust.rustGetPriceEthToToken(ethIn,reserveEth,reserveToken);
    //     return priceTokenToEth;
    // }

    function addLiquidity(uint256 tokenAmount) external payable {
        require(tokenAmount > 0 && msg.value > 0, "Invalid amounts");

        token.transferFrom(msg.sender, address(this), tokenAmount);
        reserveToken += tokenAmount;
        reserveEth += msg.value;
    }

    function getTokenOut(uint256 ethIn) public view returns (uint256) {
        require(reserveEth > 0 && reserveToken > 0, "Empty pool");
        // Swap math:
        // https://rareskills.io/post/uniswap-v2-price-impact
        uint256 constant_product = reserveEth * reserveToken;
        uint256 delta_eth = reserveEth + ethIn;
        uint256 tokenOut = reserveToken - ((constant_product) / delta_eth);
        // uint256 priceEthToToken = fluentRust.rustGetPriceEthToToken(ethIn);
        return tokenOut;
    }

    function getEthOut(uint256 tokenIn) public view returns (uint256) {
        require(reserveEth > 0 && reserveToken > 0, "Empty pool");
        // Swap math:
        // https://rareskills.io/post/uniswap-v2-price-impact
        uint256 constant_product = reserveEth * reserveToken;
        uint256 delta_token = reserveToken + tokenIn;
        uint256 ethOut = reserveEth - ((constant_product) / delta_token);
        // uint256 priceTokenToEth = fluentRust.rustGetPriceTokenToEth(tokenIn);
        return ethOut;
    }

    function swapEthToToken() external payable {
        require(msg.value > 0, "No ETH sent");

        uint256 tokenOut = getTokenOut(msg.value);
        require(tokenOut <= reserveToken, "Not enough liquidity");

        reserveEth += msg.value;
        reserveToken -= tokenOut;

        token.transfer(msg.sender, tokenOut);
    }

    function swapTokenToEth(uint256 tokenIn) external {
        require(tokenIn > 0, "Zero input");

        uint256 ethOut = getEthOut(tokenIn);
        require(ethOut <= reserveEth, "Not enough liquidity");

        token.transferFrom(msg.sender, address(this), tokenIn);

        reserveToken += tokenIn;
        reserveEth -= ethOut;

        payable(msg.sender).transfer(ethOut);
    }
}
