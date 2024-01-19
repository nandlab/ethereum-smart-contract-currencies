/* eslint-disable no-undef */
// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DDExchange", function () {
  it("test exchange", async function () {
    const DDCoin = await ethers.getContractFactory("DDCoin");
    const ddcoin = await DDCoin.deploy();
    await ddcoin.deployed();
    console.log("ddcoin deployed at: " + ddcoin.address);
    expect((await ddcoin.queryOwnBalance()).toNumber()).to.equal(0);
    const DDToken = await ethers.getContractFactory("DDToken");
    const ddtoken = await DDToken.deploy();
    await ddtoken.deployed();
    const ddtokenSignerAddress = await ddtoken.signer.getAddress();
    console.log("ddtoken deployed at: " + ddtoken.address);
    expect((await ddtoken.balanceOf(ddtokenSignerAddress)).toBigInt()).to
        .equal((await ddtoken.totalSupply()).toBigInt());
    const DDExchange = await ethers.getContractFactory("DDExchange");
    const ddexchange = await DDExchange.deploy();
    await ddexchange.deployed();
    console.log("ddexchange deployed at: " + ddexchange.address);
    const balance = 100;
    const mintCoins = await ddcoin.mintCoins(balance);
    await mintCoins.wait();
    await ddcoin.setApprovedExchange(ddexchange.address);
    expect((await ddcoin.queryOwnBalance()).toNumber()).to.equal(balance);
    await ddtoken.approve(ddexchange.address, 1000);
    ddexchange.setDdtAccess(ddtoken.address, ddtokenSignerAddress);
    ddexchange.setDdcAddress(ddcoin.address);
    // We are ready to exchange money
    // const user = ethers.Wallet.createRandom();
    // user.provider = ethers.getDefaultProvider();
    
    const [owner] = await ethers.getSigners();
    let privateKey = "0x3141592653589793238462643383279502884197169399375105820974944592"
    let user = new ethers.Wallet(privateKey, owner.provider);
    console.log("Preparing transaction...");
    let transaction = {
        to: await user.getAddress(),
        value: 40
    };
    console.log("Transferring some money to newly created account...");
    await owner.sendTransaction(transaction);
    console.log("Done.");

    const val = 20;
    await ddexchange.connect(user).exchangeEtherToMyCurrency("DDT", {"value": val});
    expect((await ddtoken.balanceOf(user)).toBigInt()).to.equal(val);
  });
});
