#https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/

library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

options(stringsAsFactors = FALSE)
options(scipen=999)

url  <- "https://api.cryptowat.ch"

# # Retrieve root (cost/ remaining allowance)
# url  <- "https://api.cryptowat.ch"
# path <- ""
# 
# raw.result <- GET(url = url, path = path)
# names(raw.result)
# raw.result$status_code
# head(raw.result$content)
# 
# this.raw.content <- rawToChar(raw.result$content)
# this.content <- fromJSON(this.raw.content)
# this.content[[1]]
# this.content[[2]]
# 
# # Convert to dataframe
# this.content.df <- do.call(what = "cbind", args = lapply(this.content, as.data.frame))
# this.content.df

# # Retrieve Assets (crypto/ fiat currencies)
# url  <- "https://api.cryptowat.ch"
# path <- "/assets"
# 
# raw.result <- GET(url = url, path = path)
# this.raw.content <- rawToChar(raw.result$content)
# this.content <- fromJSON(this.raw.content)
# this.content[[1]]
# class(this.content[[1]]) # dataframe


# # Retrieve single asset
# url  <- "https://api.cryptowat.ch"
# path <- "/assets/eth"
# 
# raw.result <- GET(url = url, path = path)
# this.raw.content <- rawToChar(raw.result$content)
# this.content <- fromJSON(this.raw.content)
# 
# this.content[[1]]$markets$base

# # Trades
# #https://api.cryptowat.ch/markets/gdax/btcusd/trades?limit=10
# url  <- "https://api.cryptowat.ch"
# path <- "/markets/gdax/btcusd/trades"
# query <- list(limit=6)
# 
# raw.result <- GET(url = url, path = path, query=query)
#      
# this.raw.content <- rawToChar(raw.result$content)
# this.content <- fromJSON(this.raw.content)
# 
# # other way
# this.content2 <- fromJSON(content(raw.result, "text", encoding = "ISO-8859-1"))
# this.content2

# # order book
# https://api.cryptowat.ch/markets/gdax/btcusd/orderbook
# url  <- "https://api.cryptowat.ch"
# path1 <- "/markets/gdax/btcusd/orderbook"
# path2 <- "/markets/poloniex/btcusd/orderbook"
# 
# raw.result1 <- GET(url = url, path = path1)
# raw.result2 <- GET(url = url, path = path2)
# 
# this.raw.content1 <- rawToChar(raw.result1$content)
# this.content1 <- fromJSON(this.raw.content1)
# 
# this.raw.content2 <- rawToChar(raw.result2$content)
# this.content2 <- fromJSON(this.raw.content2)
# 
# this.content1$result$bids[1,]
# this.content1$result$asks[1,]
# this.content2$result$bids[1,]
# this.content2$result$asks[1,]
# View(this.content$result)

# Routine to parse all exchanges and find min/ max of bid/ ask*************************

# # Get active Exchanges (available on cryptowat.ch)
# path <- "/exchanges"
# 
# raw.result <- GET(url = url, path = path)
# this.raw.content <- rawToChar(raw.result$content)
# this.content <- fromJSON(this.raw.content)
# 
# exchanges.df <- this.content[[1]]
# exchanges.ids <- exchanges.df[exchanges.df$active==T,]$id
# View(exchanges.ids)

# # Get available pairs  # Comment so I don't regenerate every time, this shouldn't change much
# raw.pairs <- GET(url="https://api.cryptowat.ch/pairs")
# pairs=fromJSON(rawToChar(raw.pairs$content))
# #class(pairs) # list of list
# # Convert to dataframe
# pairs.df <- do.call(what = "cbind", args = lapply(pairs$result, as.data.frame))
# # fix column naming
# colnames(pairs.df)[1]="id"
# Querys
# pairs.df[pairs.df$base.id=='btc', ]$id # no btceth pair
# pairs.df[pairs.df$base.id=='eth', ]$id # ethbtc pair

# Initialize dataframe to hold bid/ ask with first pair
# Examples: https://api.cryptowat.ch/pairs/ethbtc or https://api.cryptowat.ch/pairs/ltcusd-weekly-futures

# Uncomment here to reload exchanges/ pairs
# raw.pair.exchanges <- GET(url = url, path = paste0("/pairs", "/", pairs.df$id[1])) # bad initialization if empty
# pair.exchanges <- fromJSON(rawToChar(raw.pair.exchanges$content))$result
# pair.exchanges <- do.call(what = "cbind", args = lapply(pair.exchanges, as.data.frame))
# colnames(pair.exchanges)[1]="id"
# colnames(pair.exchanges)[10]="route"
# 
# bid.ask <- pair.exchanges
# 
# # Add all available pairs with the exchanges (markets) where they are available to bid.ask dataframe
# 
# for (pair in pairs.df$id[2:dim(pairs.df)[1]]) {
#   tryCatch(
#     {
#       raw.pair.exchanges <- GET(url = url, path = paste0("/pairs", "/", pair))
#       pair.exchanges <- fromJSON(rawToChar(raw.pair.exchanges$content))$result
#       pair.exchanges <- do.call(what = "cbind", args = lapply(pair.exchanges, as.data.frame))
#       colnames(pair.exchanges)[1]="id"
#       colnames(pair.exchanges)[10]="route"
#       cat(pair, dim(pair.exchanges)[1], "\n") # Display number of rows added
#       # concatenate by row
#       if (length(pair.exchanges) > 0) {
#         bid.ask <- rbind(bid.ask, pair.exchanges)
#       }
#     },
#   error = function(e) {print(paste("Error: ", pair))})
# }
# 

# pairs.df$id[2:10]
# raw.pair.exchanges <- GET(url = url, path = paste0("/pairs", "/", pairs.df$id[6]))
# pair.exchanges <- fromJSON(rawToChar(raw.pair.exchanges$content))$result
# pair.exchanges
# paste0(url, "/pairs", "/", pairs.df$id[6])


# # test
# raw.pair.exchanges <- GET(url = url, path = paste0("/pairs", "/ethbtc"))
# pair.exchanges <- fromJSON(rawToChar(raw.pair.exchanges$content))$result
# #View(pair.exchanges)
# #merge
# bid.ask <- merge(bid.ask, pair.exchanges, by=c("id", "base.id", "base.name", "base.fiat", "quote.id", "quote.name", "quote.fiat"), all.x = TRUE)

# Get bid/ ask for a given pair (first rows in orderbook) for all exchanges
# https://api.cryptowat.ch/markets/gdax/btcusd/orderbook or https://api.cryptowat.ch/markets/bithumb/ethbtc/orderbook

# write.csv(bid.ask, file = "bid.ask.csv")

bid.ask = read.csv("2017-08-29 120546 bid.ask.csv")

# Remove non active
bid.ask <- bid.ask[bid.ask$markets.active==T,]

# Clean prices (to avoid mixing stale and new ones)
bid.ask$bid.price1 <- 0
bid.ask$bid.price2 <- 0
bid.ask$bid.price3 <- 0
bid.ask$bid.size1 <- 0
bid.ask$bid.size2 <- 0
bid.ask$bid.size3 <- 0
bid.ask$ask.price1 <- 0
bid.ask$ask.price2 <- 0
bid.ask$ask.price3 <- 0
bid.ask$ask.size1 <- 0
bid.ask$ask.size2 <- 0
bid.ask$ask.size3 <- 0

for (i in 1:dim(bid.ask)[1]) {
  cat("Row #: ", i, "\n")
  print(paste("Exchange/ Pair: ", bid.ask[i, "markets.exchange"], "/", bid.ask[i, "markets.pair"]))
  #cat("\n")
  if (bid.ask[i, "base.fiat"]==F & bid.ask[i, "quote.fiat"]==F) {  # Exclude FIAT currencies
    raw.orderbook <- GET(url = url, path = paste0("/markets", "/", bid.ask[i, "markets.exchange"], "/", bid.ask[i, "markets.pair"], "/orderbook"))
    orderbook <- fromJSON(rawToChar(raw.orderbook$content))$result
    tryCatch(
      {
        bid.ask[i, "bid.price1"] <- orderbook$bids[1,1];
        bid.ask[i, "bid.size1"] <- orderbook$bids[1,2];
        bid.ask[i, "ask.price1"] <- orderbook$asks[1,1];
        bid.ask[i, "ask.size1"] <- orderbook$asks[1,2];
        
        bid.ask[i, "bid.price2"] <- orderbook$bids[2,1];
        bid.ask[i, "bid.size2"] <- orderbook$bids[2,2];
        bid.ask[i, "ask.price2"] <- orderbook$asks[2,1];
        bid.ask[i, "ask.size2"] <- orderbook$asks[2,2];
        
        bid.ask[i, "bid.price3"] <- orderbook$bids[3,1];
        bid.ask[i, "bid.size3"] <- orderbook$bids[3,2];
        bid.ask[i, "ask.price3"] <- orderbook$asks[3,1];
        bid.ask[i, "ask.size3"] <- orderbook$asks[3,2];
      },
      error = function(e) {print(paste("No bids: ", bid.ask[i, "markets.exchange"], "/", bid.ask[i, "markets.pair"]))})
  } else {
    print(paste("Skipping: ", bid.ask[i, "markets.exchange"], "/", bid.ask[i, "markets.pair"]))
  }
}

# write dataframe to file
setwd("/Users/Quentin/Documents/Cryptowatch Project")
write.csv(bid.ask, file = paste0(Sys.time(), " bid.ask.csv"))

#bid.ask.loaded = read.csv("2017-08-29 151129 bid.ask.csv")

# Data Analysis ***************************************
# Remove columns
bid.ask.cleaned <- cbind(
  bid.ask[,c("id", "base.id", "base.name", "quote.id", "quote.name", "markets.exchange", "markets.pair", "markets.active")],
  bid.ask[,16:26]
)

# Remove FIAT currencies
bid.ask <- bid.ask[bid.ask$base.fiat==F & bid.ask$quote.fiat==F,]

attach(bid.ask.cleaned)
bid.ask.cleaned= na.omit(bid.ask.cleaned)

bid.ask.cleaned2 <- group_by(bid.ask.cleaned, id)

#Remove stale pairs
#cexio/ltcusd, cexio/ ltcbtc, kraken/ repusd, kraken/ btcgbp

#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='cexio' & bid.ask.cleaned2$markets.pair=='ltcusd'),]
bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='cexio' & bid.ask.cleaned2$markets.pair=='ltcbtc'),]
#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='kraken' & bid.ask.cleaned2$markets.pair=='repusd'),]
#bid.ask.cleaned2 <- bid.ask.cleaned2[!(bid.ask.cleaned2$markets.exchange=='kraken' & bid.ask.cleaned2$markets.pair=='btcgbp'),]

# Remove bitsquare (no prices loaded)
bid.ask.cleaned2 <- bid.ask.cleaned2[bid.ask.cleaned2$markets.exchange!='bitsquare',]

# Remove blank prices
bid.ask.cleaned2 <- bid.ask.cleaned2[bid.ask.cleaned2$bid.price1!='0' & bid.ask.cleaned2$ask.price1!='0',]

# List opportunities (where ask in one exchange < bid in another) - rank by decreasing order
spreads <- summarise(bid.ask.cleaned2, spread_ratio = (max(bid.price1) - min(ask.price1) ) / max(bid.price1) * 100) %>% 
  arrange(., desc(spread_ratio))
spreads

# query to analyse results
#View(bid.ask.cleaned2[bid.ask.cleaned2$id=='eosbtc',])

# TO DO
#setwd("/Users/Quentin/Documents/Cryptowatch Project")
# library(gmailr)
# use_secret_file("Remails-9fbec6731c9e.json")
# 
# test_email <- mime(
#   To = "XXX@gmail.com",
#   From = "XXX@gmail.com",
#   Subject = "this is just a gmailr test",
#   body = "Can you hear me now?")
# send_message(test_email)

