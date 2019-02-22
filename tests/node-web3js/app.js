const Web3 = require('web3');
const config = require('./config.json');

// set the provider you want from Web3.providers
web3 = new Web3(new Web3.providers.HttpProvider(config.node));

// Web3 API Version
console.log(`web3 version: ${web3.version.api}`);

// Account utilisé pour payer les fees
web3.eth.defaultAccount = web3.eth.accounts[0];

// Provient du build Truffle
const contractBuild = require('../../contracts/build/contracts/Organization.json');

const contract =  web3.eth.contract(contractBuild.abi).at(config.contract.address);

let options =  { gas: 300000 };

/*
* Affiche les informations sur l'organisation
*/
contract.getOrganizationInfo.call((e, r) => {
	console.log('------------------');
	if(!e) {
		console.log(`Name : ${r[0]}`);
		console.log(`Id : ${r[1]}`);
		console.log(`Website : ${r[2]}`);
		console.log(`Members : ${r[3]}`);
		console.log(`Contract address: ${contract.address}`);
	} else {
		console.error(e);
	}
	console.log('------------------');
})

let members = [/*{
	address: '0x9746***',
	firstName: 'Foo',
	lastName: 'Bar',
}*/];

/*
* Ajoute des membres à l'organisation
*/
members.forEach((member) => {
	contract.addMember(member.address, member.firstName, member.lastName, options, (e, r) => { 
		if(!e)
			console.log(`member added: ${r}`);
		else
			console.error(e);
	})
});

/*
* Affiche la liste des membres
*/
contract.getMemberList.call(options, (e, r) => { 
	console.log('Members list :');

	if(r !== null && r.length > 0) {
		r.forEach((address) => {
			contract.getMember(address, options, (e, r) => { 
				console.log(`Address : ${r[0]}`);
				console.log(`FirstName : ${r[1]}`);
				console.log(`LastName : ${r[2]}`);
				console.log(`Tokens : ${r[3]}`);
				console.log(`Id: ${r[4]}`);

				console.log('-------');
			})
		});
	}

	console.log('------------------');
})