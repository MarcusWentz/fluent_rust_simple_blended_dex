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
    fn rust_get_price_eth_to_token(
        &self,
        eth_in: U256,
        reserve_eth: U256,
        reserve_token: U256) 
    -> U256;
    fn rust_get_price_token_to_eth(
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

    #[function_id("rustGetPriceEthToToken(uint256,uint256,uint256)")]
    fn rust_get_price_eth_to_token(
        &self,  
        eth_in: U256,
        reserve_eth: U256,
        reserve_token: U256
        ) -> U256 {
        let price_eth_to_token : U256 = (eth_in*reserve_token)/reserve_eth;
        return price_eth_to_token;
    }

    #[function_id("rustGetPriceTokenToEth(uint256,uint256,uint256)")]
    fn rust_get_price_token_to_eth(
        &self,  
        token_in: U256,
        reserve_eth: U256,
        reserve_token: U256
    ) -> U256 {
        let price_token_to_eth : U256 = (token_in*reserve_eth)/reserve_token;
        return price_token_to_eth;
    }

}

impl<SDK: SharedAPI> ROUTER<SDK> {
    fn deploy(&self) {
        // any custom deployment logic here
    }
}

basic_entrypoint!(ROUTER);