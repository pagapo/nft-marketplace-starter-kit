const ManifestNFT = artifacts.require("ManifestNFT");

module.exports = function(deployer) {
  deployer.deploy(ManifestNFT);
};
