# Crypto_arb_tracker
### R project to list arbitrage opportunities

Running Cryptowatch.r will issue all the exchange/ pairs sorted by most interesting spread (where the ask price on an exchange is below bid price on another)
Data is sourced from the cryptowat.ch API

Exchanges:

`unique(bid.ask$markets.exchange)`
1. bitfinex 
2. gdax 
3. bitstamp 
4. kraken 
5. qryptos 
6. btc-china 
7. poloniex 
8. cexio 
9. gemini 
10. quoine 
11. bitflyer

