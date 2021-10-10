const { assert } = require('chai');
require('chai').use(require('chai-as-promised')).should();

const Gov = artifacts.require('./MakenaGov.sol');

contract('MakenaGov', (accounts) => {
  let contract;
  before(async () => {
    contract = await Gov.new();
  });
  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = contract.address;
      console.log(address);
      assert.notEqual(address, '');
      assert.notEqual(address, 0x0);
    });
  });
  describe('dice', async () => {
    it('roll dice', async () => {
      let key = await contract.roll();
      let res = key.logs[0].args.key.toNumber();
      console.log({ res });
      let check = await contract.checkDice(res);
      const { dice, blockNum, hash } = check.logs[0].args;
      console.log({ dice: dice.toNumber(), blockNum: blockNum.toNumber(), hash });
    });
  });
});
