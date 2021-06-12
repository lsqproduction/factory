const CreateCampaigns = artifacts.require("CreateCampaigns");
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('CreateCampaigns', (accounts) => {
    let campaign;
    let factory;
    const fundingAccount = accounts[0];
    const calimingAccount = accounts[1];
    const fundingSize = 50;

    before(async () => {
    factory = await CreateCampaigns.deployed();


    it("creates a campaign", async function () {

    campaign = await Factory.createCampaign({ from: fundingAccount });
        await casino.fund({ from: fundingAccount, value: fundingSize });
        assert.equal(await web3.eth.getBalance(campaign.address), fundingSize);
    });
  });


}

