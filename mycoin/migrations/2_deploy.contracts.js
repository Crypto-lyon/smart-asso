const Greeter = artifacts.require('Greeter');
const Organization = artifacts.require('Organization');

module.exports = function(deployer) {
  //deployer.deploy(Greeter,'Hello World from Crypto Lyon - 1802');
  deployer.deploy(Organization,'Crypto Lyon', 'crypto-lyon', 'https://www.crypto-lyon.fr');

};