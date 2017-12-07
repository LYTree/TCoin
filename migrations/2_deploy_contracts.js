var MyCoin = artifacts.require("MyCoin");

module.exports = function(deployer) {
  deployer.deploy(MyCoin, 100000000);
};

