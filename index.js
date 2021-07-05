let Web3 = require('web3');
let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));



web3.eth.sendTransaction({from: "0x65Dc90c13C412544c34ccE4Cad152339c9304c23", to: "0xCd6081600545f5484278bBf857c30C8a26078D90", value: web3.utils.toWei("25","ether")});


