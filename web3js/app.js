const Web3 = require('web3');

// set the provider you want from Web3.providers
web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Web3 API Version
console.log(`web3 version: ${web3.version.api}`); // 0.20.x

// liste des accounts
//console.log(web3.eth.accounts);

// Default account
web3.eth.defaultAccount = web3.eth.accounts[0]; // Adresse utilisée pour le gas des contracts

// Provient du build Truffle
const contractAbi = require('./abi.json');

const contract =  web3.eth.contract(contractAbi).at('0x3448a15700a5422Db13Fc0E811765526DD8E95F3');



/*
 * call : ne coute pas d'ether et n'affecte pas la blockchain: local
 * => call : renvoi le résultat de la fonction 
 * 
 * transaction: broadcastés sur network et coute du gas
 * => retourne l'id de la transaction 
 * 
 * https://ethereum.stackexchange.com/questions/12841/with-web3-how-would-i-get-transaction-and-function-result
*/


let options =  { gas: 300000 };

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

/*let member = {
	address: '0x34a9fe2da0f793c69b68a347f5726eb4f5f5fd5c',
	firstName: 'Emmanuel',
	lastName: 'Vallon',
};
contract.addMember(member.address, member.firstName, member.lastName, options, (e, r) => { 
	if(!e)
		console.log(`member added: ${r}`);
	else
		console.error(e);
})*/


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