require(tidyverse)
require(viridisLite)

data.dir <- "../../trueblocks-tokenomics/other_data/"

countsByWeek <- read_tsv(paste0(data.dir, "countsByWeek.txt"))
countsPer10000 <- read_tsv(paste0(data.dir, "countsPer10000.txt"))
Traces <- readxl::read_xlsx(paste0(data.dir, "Traces.xlsx"), range = "A5:CW255") %>%
  rename(nTraces = `...1`) %>%
  gather(block.bucket, appearances, -nTraces) %>%
  mutate(block.bucket = as.integer(block.bucket))

Traces %>%
  ggplot(aes(x = block.bucket, y = nTraces, fill = appearances)) +
  geom_tile(color = "white", size=0.1) + 
  scale_fill_gradient(name = "n occurrences", trans="pseudo_log") +
  theme_minimal(base_size=8)