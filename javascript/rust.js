const ethers = require("ethers") // npm i ethers@5.7.2 https://github.com/smartcontractkit/full-blockchain-solidity-course-js/discussions/5139#discussioncomment-5444517

const rpcURL = "https://rpc.dev.gblend.xyz/" // Your RPC URL goes here

const provider = new ethers.providers.JsonRpcProvider(rpcURL)

const contractAddress = '0x04160C19738bB6429c0554fBdC11A96079D7297D'
const contractABI = [{"inputs":[],"name":"rustAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustBool","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustBytes","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustBytes32","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustInt256","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustString","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rustUint256","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]

const contractDeployed = new ethers.Contract(contractAddress, contractABI, provider);

let fluent_sepolia_chain_id = 20993;

testRustContractRead()

async function testRustContractRead() {

  const connectedNetworkObject = await provider.getNetwork();
  const chainIdConnected = connectedNetworkObject.chainId;
  console.log("chainIdConnected: " + chainIdConnected)

  if(chainIdConnected != fluent_sepolia_chain_id){
    console.log("RPC endpoint not connected to Fluent Sepolia (chainId: " + fluent_sepolia_chain_id + ").");
    console.log("Switch to Fluent Sepolia then try again.");
    return;
  }

  const rustString = await contractDeployed.rustString()
  console.log("rustString: " + rustString)

  const rustUint256 = await contractDeployed.rustUint256()
  console.log("rustUint256: " + rustUint256)

  const rustInt256 = await contractDeployed.rustInt256()
  console.log("rustInt256: " + rustInt256)

  const rustAddress = await contractDeployed.rustAddress()
  console.log("rustAddress: " + rustAddress)

  const rustBytes = await contractDeployed.rustBytes()
  console.log("rustBytes: " + rustBytes)

  const rustBytes32 = await contractDeployed.rustBytes32()
  console.log("rustBytes32: " + rustBytes32)

  const rustBool = await contractDeployed.rustBool()
  console.log("rustBool: " + rustBool)

}
