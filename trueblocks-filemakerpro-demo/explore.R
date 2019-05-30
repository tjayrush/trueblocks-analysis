require(tidyverse)

eth.tweet.me <- read_csv("data/EthTweetMe-0x48d9eac690ba14e055af890cc33e17e2cbc0a37a.csv")
giveth.vault <- read_csv("data/Giveth_Vault-0x5adf43dd006c6c36506e2b2dfa352e60002d22dc.csv")
the.button   <- read_csv("data/TheButton-0x2b0ec0993a00b2ea625e3b37fcc74742f43a72fe.csv")

eth.tweet.me %>% View()

eth.tweet.me %>% 
  ggplot(aes(x=BlockNumber, fill=`Abis::Name`)) +
  geom_histogram()