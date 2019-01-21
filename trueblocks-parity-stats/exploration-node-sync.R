require(tidyverse)
require(scales)
require(magrittr)

dir.size <- read_tsv('data/directory-size.log', col_names = c("timestamp", "size", "dir")) %>%
  filter(str_detect(dir, "/archive")) %>%
  filter(timestamp != 1544481541)

dir.size %>%
  mutate(size = size / 1e+6) %>%
  ggplot(aes(x = timestamp, y = size)) +
  geom_line()

parity <- read_lines('data/archive-sync.log') %>%
  str_subset(pattern = 'Syncing') %>%
  substr(1, 37) %>%
  str_split("  ", n = 2, simplify = TRUE) %>%
  as_data_frame() %>%
  rename("date" = V1, "block" = V2) %>%
  mutate(block = str_split(block, "#", simplify=T)[,2] %>% as.integer()) %>%
  mutate(date = as.POSIXct(date))

parity %>%
  ggplot(aes(x=date, y=block)) +
  geom_line() +
  scale_y_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 500000))}) +
  labs(title = "Parity Archive Node w/ Tracing sync progress")

acctscrape <- read_tsv('data/acct-scrape-0.log') %>% bind_rows(read_tsv('data/acct-scrape.log'))
blockscrape <- read_tsv('data/block-scrape-data-0.log', col_names = c(
  "block-date",
  "run-date",
  "duration",
  "blockNum",
  "txs",
  "trcs",
  "depth",
  "addrs",
  "status",
  "blooms"
)) %>% bind_rows(read_tsv('data/block-scrape-data.log')) %>% arrange(`block-date`)
# miniblock <- read_tsv('data/mini-block-data-0.log') %>% bind_rows(read_tsv('data/mini-block-data.log'))

blockscrape %>%
  filter(status=="final-b") %>% 
  ggplot(aes(x=`run-date`, y=blockNum)) +
  geom_line() +
  scale_y_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 500000))})


blockscrape.min.date <- min(blockscrape$`run-date`)
parity.min.date <- min(parity$date)

blockscrape %>%
  filter(status=="final-b") %>%
  sample_n(100000) %>%
  mutate(time.since.start = `run-date` - blockscrape.min.date) %>%
  select(time.since.start, blockNum) %>%
  mutate(type = "blockscrape") %>%
  bind_rows(
    parity %>%
      mutate(time.since.start = date - parity.min.date) %>%
      rename(blockNum = block) %>%
      select(-date) %>%
      mutate(type = "parity")
  ) %>%
  mutate(time.since.start = time.since.start/60/60/24) %>%
  ggplot(aes(x=time.since.start, y=blockNum, color = type)) +
  scale_y_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 500000))}) +
  scale_x_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 1))}) + 
  geom_line() +
  labs(x = "days since start", y = "block number", color = "which program?")
  
blockscrape %>%
  filter(status=="final-b") %>%
  sample_n(100000) %>%
  mutate(time.since.start = `run-date` - blockscrape.min.date) %>%
  select(time.since.start, blockNum) %>%
  mutate(type = "blockscrape") %>%
  bind_rows(
    parity %>%
      mutate(time.since.start = date - parity.min.date) %>%
      rename(blockNum = block) %>%
      select(-date) %>%
      mutate(type = "parity")
  ) %>%
  mutate(time.since.start = time.since.start/60/60/24) %>%
  ggplot(aes(x=time.since.start, y=blockNum, color = type)) +
  scale_y_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 500000))}) +
  scale_x_continuous(labels = comma, breaks = function(lims) {return(seq(0, lims[2], by = 1))}) + 
  geom_line() +
  labs(x = "days since start", y = "block number", color = "which program?")


acctscrape

acctscrape %>%
  group_by(name) %>%
  arrange(date) %>%
  mutate(time.delta = date - lag(date)) %>%
  ggplot(aes(x=time.delta)) +
  geom_histogram() +
  facet_wrap(facets = "name")
