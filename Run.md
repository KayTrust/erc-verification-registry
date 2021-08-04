# Identity Contracts - Technical Steps

## Requisites

* Node10.x or 12.x

## Compiling Contracts

* Starting the ganache network

```shell
npx ganache-cli --deterministic
```

* NOTE: If you want to deploy it in a custom network set the private key in truffle-config.js

* compile with truffle installed locally for this project

```shell
npx truffle compile --reset
```

* Deploy your contracts

```shell
npx truffle migrate --network development --reset #for deployments with ganache
```

Note: To deploy to a real network you can configure your private key and rpc connection in the truffle-config.js

```shell
npx truffle migrate --network besu --reset #for deployments with a customized network
```

* Executing some functions

```shell
npx truffle exec --network development ./scripts/index.js
```

* Testing contracts

After creating some tests, run them with:

```shell
npx truffle test
```
