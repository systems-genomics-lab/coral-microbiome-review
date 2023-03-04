library(tidyverse)
library(tidylog)
library(randomcoloR)



t1 = read_tsv("in-the-tree.tsv")
head(t1)

t2 = read_tsv("coral-microbiome-range-color2.tsv")
head(t2)

t3 = t2 %>% inner_join(t1) %>% arrange(name)
head(t3)

phyla = t3 %>% select (name) %>% distinct() %>% arrange(name)
phyla

phyla2 = phyla %>% mutate (color = randomColor(nrow(phyla)))
phyla2


t4 = t3 %>% select (-color) %>% inner_join(phyla2) %>% select (node, type, color, name)
head(t4)

write_tsv(t4, "coral-microbiome-range-color3.tsv")

