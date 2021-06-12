const CreateCampaigns = artifacts.require("CreateCampaigns");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CreateCampaigns", function (accounts) {
  let subject;
  before(async () => {
    subject = await CreateCampaigns.deployed();
  });

  it("should assert true", async function () {
    return assert.isTrue(true);
  });

  it("creates a campaign", async function () {
    await subject.createCampaign(2000, 1723449791000, {
      from: accounts[0],
      value: 4000,
    });
    assert.isTrue(true);
  });
});
