// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IFluentRust {
    function rustUint256() external view returns (uint256);    
    function rustGetTokenOut(uint256,uint256,uint256) external view returns (uint256);    
    function rustGetEthOut(uint256,uint256,uint256) external view returns (uint256);    
}

interface IERC20 {        
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface ISwapDexBlend{

    //Custom errors.
    error EtherNotSent();

}

contract SwapDexBlend is ISwapDexBlend{

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

    function testRustGetTokenOut(uint256 ethIn) external view returns (uint256) {
        uint256 tokenOut = fluentRust.rustGetTokenOut(ethIn,reserveEth,reserveToken);
        return tokenOut;
    }

    function testRustGetEthOut(uint256 tokenIn) external view returns (uint256) {
        uint256 ethOut = fluentRust.rustGetEthOut(tokenIn,reserveEth,reserveToken);
        return ethOut;
    }

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
        // k = (x+Δx)*(y-Δy) = (x_new)*(y_new)
        uint256 constantProduct = reserveEth * reserveToken;
        // ethIn = Δx
        uint256 newReserveEth = reserveEth + ethIn;
        uint256 newReserveToken = ((constantProduct) / newReserveEth);
        // tokenOut = Δy
        uint256 deltaToken = reserveToken - newReserveToken;
        // uint256 priceEthToToken = fluentRust.rustGetPriceEthToToken(ethIn);
        return deltaToken;
    }

    function getEthOut(uint256 tokenIn) public view returns (uint256) {
        require(reserveEth > 0 && reserveToken > 0, "Empty pool");
        // Swap math:
        // https://rareskills.io/post/uniswap-v2-price-impact
        // k = (y+Δy)*(x-Δx) = (y_new)*(x_new)
        uint256 constantProduct = reserveEth * reserveToken;
        // tokenIn = Δy
        uint256 newReserveToken = reserveToken + tokenIn; 
        uint256 newReserveEth = ((constantProduct) / newReserveToken);
        // ethOut = Δx
        uint256 ethOut = reserveEth - newReserveEth;
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

        (bool sentUser, ) = payable(msg.sender).call{value:ethOut}("");
        if(sentUser == false) revert EtherNotSent(); 
    }
}
