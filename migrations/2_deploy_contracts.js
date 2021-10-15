var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Token = artifacts.require("./Token.sol");

module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, 42);
  deployer.deploy(Token, "STAKING", "STK");
};
