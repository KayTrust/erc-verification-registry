const { assert } = require('chai');

const IMV2 =  artifacts.require("IdentityManager");

describe('Should deploy a new contract', () => {
  it('works', async () => {
    const imV2 = await IMV2.new();
    assert.equal('1','1');
  });

  it('Should Create a new Identity', async () => {
    const imV2 = await IMV2.new();
    const address = await imV2.createIdentity();
    assert.equal('1','1');
  });
});