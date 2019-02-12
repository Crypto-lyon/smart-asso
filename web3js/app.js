const Web3 = require('web3');

// set the provider you want from Web3.providers
web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Web3 API Version
console.log(`web3 version: ${web3.version.api}`); // 0.20.x

// liste des accounts
//console.log(web3.eth.accounts);

// Default account
//web3.eth.defaultAccount = web3.eth.accounts[0];

// Provient du build Truffle
var erc20Abi = [
	{
		"constant": false,
		"inputs": [],
		"name": "kill",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_greeting",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "greet",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]

const erc20Contract =  web3.eth.contract(erc20Abi).at('0x79195B524aec0A94920c57F23aEca75B20c325B1');

console.log(`contract address: ${erc20Contract.address}`);

erc20Contract.greet((e, r) => {
    if(!e)
        console.log(r);
    else
        console.error(e);
 });