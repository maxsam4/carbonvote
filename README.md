# CarbonVote

## Requirements
* Ruby
* Rake
* Bundler
* Redis
* Solidity 0.3.6-3fc68da (For pass contract verify at Etherscan.io)
* Ethereum Go (Geth)

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
