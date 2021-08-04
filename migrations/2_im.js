const IM = artifacts.require('IdentityManager')

module.exports = async function(deployer){
    await deployer.deploy(IM);
}