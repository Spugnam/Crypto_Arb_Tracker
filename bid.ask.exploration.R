library(dplyr)
library(ggplot2)

setwd("/Users/Quentin/Documents/Cryptowatch Project")
bid.ask.loaded = read.csv("2017-08-29 151129 bid.ask.csv")

# Remove columns
bid.ask.cleaned <- cbind(
  bid.ask.loaded[,c("id", "base.id", "base.name", "quote.id", "quote.name", "markets.exchange", "markets.pair", "markets.active")],
  bid.ask.loaded[,16:26]
)

# Remove FIAT currencies
View(bid.ask[bid.ask$base.fiat==F & bid.ask$quote.fiat==F,])

attach(bid.ask.cleaned)
bid.ask.cleaned= na.omit(bid.ask.cleaned)

bid.ask.cleaned2 <- group_by(bid.ask.cleaned, id)

#Remove stale pairs
#cexio/ltcusd, cexio/ ltcbtc, kraken/ repusd, kraken/ btcgbp

#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='cexio' & bid.ask.cleaned2$markets.pair=='ltcusd'),]
bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='cexio' & bid.ask.cleaned2$markets.pair=='ltcbtc'),]
#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='kraken' & bid.ask.cleaned2$markets.pair=='repusd'),]
#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='kraken' & bid.ask.cleaned2$markets.pair=='btcgbp'),]

spreads <- summarise(bid.ask.cleaned2, spread_ratio = (max(bid.price1) - min(ask.price1) ) / max(bid.price1) * 100) %>% 
  arrange(., desc(spread_ratio))
spreads

#View(bid.ask.cleaned2)
#View(spreads)

View(bid.ask.cleaned2[bid.ask.cleaned2$id=="xrpbtc",])


