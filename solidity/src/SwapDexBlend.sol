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

    receive() external payable {}

    function addLiquidity(uint256 tokenAmount) external payable {
        require(tokenAmount > 0 && msg.value > 0, "Invalid amounts");

        token.transferFrom(msg.sender, address(this), tokenAmount);
        reserveToken += tokenAmount;
        reserveEth += msg.value;
    }

    function getPriceEthToToken(uint256 ethIn) public view returns (uint256) {
        require(reserveEth > 0 && reserveToken > 0, "Empty pool");
        uint256 priceEthToToken = (ethIn * reserveToken) / reserveEth;
        return priceEthToToken;
    }

    function getPriceTokenToEth(uint256 tokenIn) public view returns (uint256) {
        require(reserveEth > 0 && reserveToken > 0, "Empty pool");
        uint256 priceTokenToEth = (tokenIn * reserveEth) / reserveToken;
        return priceTokenToEth;
    }

    function swapEthToToken() external payable {
        require(msg.value > 0, "No ETH sent");

        uint256 tokenOut = getPriceEthToToken(msg.value);
        require(tokenOut <= reserveToken, "Not enough liquidity");

        reserveEth += msg.value;
        reserveToken -= tokenOut;

        token.transfer(msg.sender, tokenOut);
    }

    function swapTokenToEth(uint256 tokenIn) external {
        require(tokenIn > 0, "Zero input");

        uint256 ethOut = getPriceTokenToEth(tokenIn);
        require(ethOut <= reserveEth, "Not enough liquidity");

        token.transferFrom(msg.sender, address(this), tokenIn);

        reserveToken += tokenIn;
        reserveEth -= ethOut;

        payable(msg.sender).transfer(ethOut);
    }
}
