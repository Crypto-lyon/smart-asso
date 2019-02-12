# Tips

### Ganache CLI pour lancer une EVM en local
```
npm install -g ganache-cli
# puis ganache-cli
```

### Compilation

Permet de générer les fichier ABI
```
truffle compile
```

### Déployement:
```
truffle deploy --reset --network development # après setup de truffle-config.js
```

### Remix
`http://remix.ethereum.org`
Dans _Run_ seletionner _injected web3_ pour utiliser metamask


### Web3js
`https://www.npmjs.com/package/web3`


```
sudo npm install web3:0.20.7 --save
```

# Sources

##  ERC 20

`https://eips.ethereum.org/EIPS/eip-20`

###  tuto
`http://erc20token.sonnguyen.ws/en/latest/`

ganache-cli (`https://www.npmjs.com/package/ganache-cli`) au lieu de ethereumjs-testrpc

On peut aussi utiliser le soft "desktop" pour avoir l'explorer en GUI.

### OpenZeppelin implementation
`https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts/token/ERC20`

### autre implémentation (ConsenSys) :

`https://github.com/ConsenSys/Tokens/tree/master/contracts/eip20`