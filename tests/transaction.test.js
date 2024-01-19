/* eslint-disable no-undef */
// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Ether transaction", function () {
  it("test transaction", async function () {
    console.log(ethers.version);
    let [owner] = await ethers.getSigners();
    owner.provider.pollingInterval = 200;
    let balance = (await owner.getBalance()).toBigInt();
    console.log(`Current balance is: ${balance}`);
    let value = ethers.utils.parseEther("1.0");
    expect(balance).to.be.at.least(value);
    let recipient = "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2";
    console.log(`Sending some ETH to recipient ${recipient}`);
    await owner.sendTransaction({
        "to": recipient,
        "value": value
    });
    let newBalance = (await owner.getBalance()).toBigInt();
    console.log(`New balance is: ${newBalance}`);
    expect(newBalance - balance).to.be(value);
  });
});
