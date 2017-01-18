# CarbonVote

## Requirements
* Ruby 2.4
* Rake 12.0.0
* Bundler 1.13.6
* Redis
* geth with rpc support


## Web3 deploy
```
var voteContract = web3.eth.contract([{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"addr","type":"address"}],"name":"LogVote","type":"event"}]);
var vote = voteContract.new({
  from: web3.eth.accounts[0],
  data: '0x606060405234610000575b60c9806100186000396000f30060606040525b609b5b3373ffffffffffffffffffffffffffffffffffffffff167fd66fd10d93c3fcf37a27c11c0e12214976632505c7954b53c023093d843fc1c460405180905060405180910390a260003411156098573373ffffffffffffffffffffffffffffffffffffffff166108fc349081150290604051809050600060405180830381858888f1935050505015156097576000565b5b5b565b0000a165627a7a72305820c3bf4973c10f90aef60ebe315482f91e6f9f6621922a21423b10b6c4e51b3afe0029',
  gas: '4700000'
}, function (e, contract) {
  console.log(e, contract);
  if (typeof contract.address !== 'undefined') {
    console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
  }
})
```

**Deployed contracts**

```
Testnet
address: 0x90c6178979f2290d3e973911cacff3df25b7d1e1 block: 1261638
address: 0x4664405e8219d4e5809fc59cfe48b5ff4d14b65a block: 1261642

Production
address: 0x3039d0a94d51c67a4f35e742b571874e53467804 block: 1836214
address: 0x58dd96aa829353032a21c95733ce484b949b2849 block: 1836217
```

## Start chain data puller

```shell
bundle exec rake pull
```

## Start Web Server

```shell
bundle exec rackup
```

then visit http://localhost:9292

## Q&A

Q: How to make a 0-ETH transactions with geth?

```
geth console
> personal.listAccounts
["your_address", ...]
> personal.unlockAccount('your_address')
> eth.sendTransaction({from: 'your_address', to: 'yes_or_no_address', value: 0})
```
