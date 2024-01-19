/* eslint-disable no-undef */
// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");

describe("Ether transaction", function () {
  it("test transaction", async function () {
    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'contracts/artifacts/DDExchange.json'))
    let provider = new ethers.providers.Web3Provider(web3Provider);
    const signer = provider.getSigner()
    console.log(ethers.version);
    let DDExchange = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);
    const initialBalance = ethers.utils.parseEther("0.0025");
    let ddexchange = await DDExchange.deploy({value: initialBalance});
    console.log('DDExchange contract Address: ' + ddexchange.address);
    await ddexchange.deployed()
    const balance = await provider.getBalance(ddexchange.address);
    console.log('DDExchange contract balance: ' + balance);
    provider.pollingInterval = 200;
    await signer.sendTransaction({
      to: ddexchange.address,
      value: ethers.utils.parseEther("1.0")
    });
  });
});
