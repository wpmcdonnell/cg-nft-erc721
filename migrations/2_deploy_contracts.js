// eslint-disable-next-line no-undef
const CG721 = artifacts.require("CG721.sol");

module.exports = function(deployer) {
    deployer.deploy(CG721);
};