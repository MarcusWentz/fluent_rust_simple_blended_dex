#![cfg_attr(target_arch = "wasm32", no_std)]
extern crate alloc;

use fluentbase_sdk::{
    basic_entrypoint,
    derive::{router, Contract},
    SharedAPI,
    U256,    // alloy Solidity type for uint256
};

#[derive(Contract)]
struct ROUTER<SDK> {
    sdk: SDK,
}

pub trait RouterAPI {
    // Make sure type interfaces are defined here or else there will be a compiler error.
    fn rust_uint256(&self) -> U256;
    fn rust_get_token_out(
        &self,
        eth_in: U256,
        reserve_eth: U256,
        reserve_token: U256) 
    -> U256;
    fn rust_get_eth_out(
        &self,
        token_in: U256,
        reserve_eth: U256,
        reserve_token: U256
    ) -> U256;
}

#[router(mode = "solidity")]
impl<SDK: SharedAPI> RouterAPI for ROUTER<SDK> {

    // ERC-20 with Fluent SDK example:
    // https://github.com/fluentlabs-xyz/fluentbase/blob/devel/contracts/examples/erc20/lib.rs

    #[function_id("rustUint256()")]
    fn rust_uint256(&self) -> U256 {
        let uint256_test = U256::from(10);
        return uint256_test;
    }

    #[function_id("rustGetTokenOut(uint256,uint256,uint256)")]
    fn rust_get_token_out(
        &self,  
        eth_in: U256,
        reserve_eth: U256,
        reserve_token: U256
        ) -> U256 {
        // Swap math:
        // https://rareskills.io/post/uniswap-v2-price-impact
        // k = (x+Δx)*(y-Δy) = (x_new)*(y_new)
        let constant_product = reserve_eth * reserve_token;
        // ethIn = Δx
        let new_reserve_eth = reserve_eth + eth_in;
        let new_reserve_token = constant_product / new_reserve_eth;
        // tokenOut = Δy
        let token_out : U256 = reserve_token - new_reserve_token;
        return token_out;
    }

    #[function_id("rustGetEthOut(uint256,uint256,uint256)")]
    fn rust_get_eth_out(
        &self,  
        token_in: U256,
        reserve_eth: U256,
        reserve_token: U256
    ) -> U256 {
        // Swap math:
        // https://rareskills.io/post/uniswap-v2-price-impact
        // k = (y+Δy)*(x-Δx) = (y_new)*(x_new)
        let constant_product = reserve_eth * reserve_token;
        // tokenIn = Δy
        let new_reserve_token = reserve_token + token_in; 
        let new_reserve_eth = constant_product / new_reserve_token;
        // ethOut = Δx
        let eth_out = reserve_eth - new_reserve_eth;
        return eth_out;
    }

}

impl<SDK: SharedAPI> ROUTER<SDK> {
    fn deploy(&self) {
        // any custom deployment logic here
    }
}

basic_entrypoint!(ROUTER);