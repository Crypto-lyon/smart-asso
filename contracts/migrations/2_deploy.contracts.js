const Organization = artifacts.require('Organization');

module.exports = function(deployer) {
  deployer.deploy(Organization,'Crypto Lyon', 'crypto-lyon', 'https://www.crypto-lyon.fr');
};