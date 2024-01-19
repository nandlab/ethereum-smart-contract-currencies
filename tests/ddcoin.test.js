/* eslint-disable no-undef */
// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DDCoin", function () {
  it("test initial value", async function () {
    const DDCoin = await ethers.getContractFactory("DDCoin");
    const ddcoin = await DDCoin.deploy();
    await ddcoin.deployed();
    console.log("ddcoin deployed at:" + ddcoin.address);
    expect((await ddcoin.queryOwnBalance()).toNumber()).to.equal(0);
  });
  it("test minting coins", async function () {
    const DDCoin = await ethers.getContractFactory("DDCoin");
    const ddcoin = await DDCoin.deploy();
    await ddcoin.deployed();
    console.log("ddcoin deployed at:" + ddcoin.address);
    const ddcoin2 = await ethers.getContractAt("DDCoin", ddcoin.address);
    expect((await ddcoin2.queryOwnBalance()).toNumber()).to.equal(0);
    const balance = 100;
    const mintCoins = await ddcoin2.mintCoins(balance);
    await mintCoins.wait();
    expect((await ddcoin2.queryOwnBalance()).toNumber()).to.equal(balance);
  });
});
