const { assert } = require("chai");
const ManifestNFT = artifacts.require("./ManifestNFT");

//check for chai
require("chai")
  .use(require("chai-as-promised"))
  .should();

contract("ManifestNFT", (accounts) => {
  let contract;
  //before tells our test to run first before anything else
  before(async () => {
    contract = await ManifestNFT.deployed();
  });

  //testing container-describe
  describe("deployment", async () => {
    //test samples with rigthing it
    it("deploys successfuly", async () => {
      const address = contract.address;
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });
    it("Has a Name", async () => {
      const name = await contract.name();
      assert.equal(name, "manifestArt");
    });
    it("Has a Symbol", async () => {
      const symbol = await contract.symbol();
      assert.equal(symbol, "MNFSTART");
    });
  });

  describe("minting", async () => {
    it("creates a new token", async () => {
      const result = await contract.mint("https...1");
      const totalSupply = await contract.totalSupply();
      //Success
      assert.equal(totalSupply, 1);
      const event = result.logs[0].args;
      assert.equal(
        event._from,
        "0x0000000000000000000000000000000000000000",
        "From the contract"
      );
      assert.equal(event._to, accounts[0], "to is ms.sender");

      //Failure
      await contract.mint("https...1").should.be.rejected;
    });
  });

  describe("Indexing", async () => {
    it("Lists Tokens", async () => {
      // mint new tokens
      await contract.mint("https...2");
      await contract.mint("https...3");
      await contract.mint("https...4");
      const totalSupply = await contract.totalSupply();
      //loop through list and grab tokens supply
      let result = [];
      let mnfst;
      for (let i = 1; i <= totalSupply; i++) {
        mnfst = await contract.mnfstNFTs(i - 1);
        result.push(mnfst);
      }
      //assert that our new array result will equal will equal our expected result
      let expected = ["https...1", "https...2", "https...3", "https...4"];
      assert.equal(result.join(","), expected.join(","));
    });
  });
});
