# https://www.kaggle.com/tunguz/big-five-personality-test

library(dplyr)
library(readr)
library(data.table)

codebook = fread("./codebook.txt", header = FALSE, fill = FALSE, skip = 7)
five = readRDS("test_10000.RDS")
five$id = 1:nrow(five)
five = melt(five, measure.vars = colnames(five)[1:100][!grepl("_E", colnames(five)[1:100])],
            id.vars = colnames(five)[101:111],
            variable.name = "question", value.name = "answer")
# merge - base
# inner_join, left_join, itd - tidyverse
# merge, dt[dt2]
five = merge(five, codebook, all.x = TRUE, by.x = "question", by.y = "V1")
five[, answer := as.numeric(answer)]


five

by_cnt_qn = split(five, list(five$country, five$V2))
by_cnt_qn[[1]]
