Smart Asso - DAO tests
===============================


https://www.crypto-lyon.fr


Pourquoi ce projet ?
----------------

Ce projet est né à l'initiative des membres de l'association Crypto Lyon.
Il vise à faciliter les prises de décisions et l'organisation de structures 
comme des coopératives, associations ou partis politiques.

Developpement
-------------------

### Truffle config

#### Installation
```
npm install -g truffle
```

#### Compiler les contrats
```
cd contracts
truffle compile
```

#### Déployer les contrats

Sur un wallet ganache en local:
```
npm install -g ganache-cli # https://www.npmjs.com/package/ganache-cli
ganache-cli
truffle deploy --reset --network development
```

Sur le wallet dev.ethereum-lyon.fr:

```
# configurer l'authentification pour le HDWallet
cp auth.template.json auth.json
vi auth.json
# puis 
truffle deploy --reset --network private
```

Les différents networks sont configurables dans `truffle-config.js`.

Tools
-------

### Truffle flatener:

Utile pour déployer dans remix et pour publier le code du contrat dans etherscan.

```
truffle-flattener contracts/Organization.sol > flat.sol
```



Tests
-------

Pour intéragir avec le contrat en utilisant node et web3.js:

### Configuration:

```
cd tests/node-web3js
cp config.template.json config.json
vi config.json
```

### Lancement

```
npm install
node app.js
```


License
-------

MIT
https://opensource.org/licenses/MIT.
