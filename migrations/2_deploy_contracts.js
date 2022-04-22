const InterestContract = artifacts.require("InterestContract");

module.exports = async function (deployer) {
	// Deploy InterestContract
	await deployer.deploy(InterestContract);
	const interestContract = await InterestContract.deployed();
};
