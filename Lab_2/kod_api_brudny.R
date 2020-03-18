library(httr)
library(dplyr)
library(lubridate)

as_datetime(1572651390, tz = "UTC")

# try()
# tryCatch()

start = seconds(ymd_hms("2020-01-01 00:00:00"))
end = seconds(ymd_hms("2020-03-16 00:00:00"))
symbol = "BINANCE:BTCUSD"

url = paste0("https://finnhub.io/api/v1/crypto/candle?resolution=1", "&symbol=",
             symbol, "&from=", as.character(start), "&to=", as.character(end))
url

btcusd = GET(url)
cont = content(btcusd) %>%
    lapply(function(x) unlist(x, FALSE, FALSE)) %>%
    as.data.frame()
btcusd
str(btcusd)


resp_symbol = GET("https://finnhub.io/api/v1/crypto/symbol?exchange=binance")
str(resp_symbol)
cont = content(resp_symbol) %>%
    lapply(function(x) unlist(x, FALSE, FALSE)) %>%
    as.data.frame()

length(content(resp_symbol))

sort(sapply(content(resp_symbol), function(x) x$symbol))

content(resp_symbol)

resp = GET("https://finnhub.io/api/v1/stock/candle?symbol=AAPL&resolution=1&from=1572651390&to=1572910590")
str(resp)
cont = content(resp) %>%
    lapply(function(x) unlist(x, FALSE, FALSE)) %>%
    as.data.frame() %>%
    mutate(t_str = as_datetime(t, tz = "UTC"))
head(cont)
