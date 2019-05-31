require(tidyverse)

eth.tweet.me <- read_csv("data/EthTweetMe-0x48d9eac690ba14e055af890cc33e17e2cbc0a37a.csv")
giveth.vault <- read_csv("data/Giveth_Vault-0x5adf43dd006c6c36506e2b2dfa352e60002d22dc.csv") %>% 
  mutate(Date = as.POSIXct(Date, format="%m/%d/%Y %H:%M:%S"))
the.button   <- read_csv("data/TheButton-0x2b0ec0993a00b2ea625e3b37fcc74742f43a72fe.csv") %>%
  mutate(Date = as.POSIXct(Date, format="%m/%d/%Y %H:%M:%S"))

eth.tweet.me %>% View()

eth.tweet.me %>% 
  ggplot(aes(x=BlockNumber, fill=`Abis::Name`)) +
  geom_histogram()

# eth.tweet.me %>%
#   mutate(hundred.thousands = floor((BlockNumber %% 1e6) / 1e5)*1e5,
#          millions = floor(BlockNumber / 1e6) * 1e6) %>%
#   ggplot(aes(x=millions, y=hundred.thousands)) +
#   geom_tile(color = "white", size=0) + 
#   viridis::scale_fill_viridis(name = "count", option = "A", labels=scales::comma) +
#   theme_minimal(base_size=8)

giveth.vault %>% select(Date)

giveth.vault %>%
  mutate(Type = ifelse(To == "0x5adf43dd006c6c36506e2b2dfa352e60002d22dc", "In", ifelse(From == "0x5adf43dd006c6c36506e2b2dfa352e60002d22dc", "From", "Other"))) %>%
  filter(Type %in% c("In", "Out")) %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(Amount = ifelse(Type == "Out", -Amount, Amount)) %>%
  group_by(Type, Date) %>%
  summarize(val = sum(Amount)) %>%
  mutate(cumval = cumsum(val)) %>%
  ggplot(aes(x=Date, y=cumval, color=Type)) +
  geom_line() +
  labs(title="Amount In/Out")

giveth.vault %>%
  filter(From == "0x5adf43dd006c6c36506e2b2dfa352e60002d22dc") %>%
  mutate(Date = as.Date(Date)) %>%
  group_by(Date) %>%
  summarize(val = sum(Amount)) %>%
  mutate(cumval = cumsum(val)) %>%
  ggplot(aes(x=Date, y=cumval)) +
  geom_line() +
  labs(title="Amount Out")

the.button
the.button %>% View()
