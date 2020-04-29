# https://www.kaggle.com/tunguz/big-five-personality-test

library(dplyr)
library(readr)
library(profvis)
library(microbenchmark)
library(data.table)
library(pryr)

codebook = fread("./codebook.txt", header = FALSE, fill = FALSE, skip = 7)

head(test)
head(codebook)

# read.csv / read.csv2 / read.delim / read.tsv
# read_csv, read_csv2, read_delim, read_tsv

# system.time(
#     read.csv("./data-final.csv")
# )
# system.time(
#     read_csv("./data-final.csv")
# )
# system.time(
#     fread("./data-final.csv")
# )
microbenchmark(
    built_in = read.csv("./test_100000.csv"),
    readr = read_csv("./test_100000.csv"),
    data_table = fread("./test_100000.csv"),
    times = 10
)
profvis(read.csv("./test_100000.csv"))
profvis(read_csv("./test_100000.csv"))

test$id = 1:nrow(test)

test_five = test_100000
head(test_five)

test_long = melt(test, measure.vars = colnames(test)[1:100],
                 id.vars = colnames(test)[101:111])
head(test_long)

pryr::object_size(test_long)
pryr::object_size(test)

test_100000 = test[1:100000, ]
fwrite(test_100000, "test_100000.csv")
saveRDS(test_10000, "test_10000.RDS")
object_size(test_1000)
test_long[]

object_size(test_100000)
object_size(test_long[id < 100000, ])


pryr::object_size(test_five)
head(test_five)
class(test_five$dateload)

# stack / unstack
# gather / spread - tidyverse
# gather(five, "question", "answer", ...)

five = melt(test_five, measure.vars = colnames(test_five)[1:100][!grepl("_E", colnames(test_five)[1:100])],
            id.vars = colnames(test_five)[101:111],
            variable.name = "question", value.name = "answer")
head(five)
pryr::object_size(five)
class(five$question)
pryr::object_size(five$question)
pryr::object_size(as.character(five$question))
class(five$answer)

unique(five$question)
five
# merge - base
# inner_join, left_join, itd - tidyverse
# merge, dt[dt2]
five = merge(five, codebook, all.x = TRUE, by.x = "question", by.y = "V1")
five[, answer := as.numeric(answer)]
# aggregate - base
profvis(aggregate(answer ~ question, data = five, mean))
# group_by() %>% summarize()
class(five$answer)
by_question = five[, .(mean_aggreagement = mean(answer, na.rm = TRUE),
                       q25 = quantile(answer, 0.25, na.rm = TRUE),
                       median = quantile(answer, 0.5, na.rm = TRUE),
                       q75 = quantile(answer, 0.75, na.rm = TRUE)), by = .(question, country)]
by_question

five[country == "PL", .(mean_aggreagement = mean(answer, na.rm = TRUE),
                        q25 = quantile(answer, 0.25, na.rm = TRUE),
                        median = quantile(answer, 0.5, na.rm = TRUE),
                        q75 = quantile(answer, 0.75, na.rm = TRUE)), by = .(question)]
unique(five$country)

# .SD
# .SDcols
class(five$introelapse)
total_time = function(times) {
    unique(as.numeric(times$introelapse) + as.numeric(times$testelapse) + as.numeric(times$endelapse))
}
five[country == "PL", .(time = total_time(.SD)), by = id,
     .SDcols = c("introelapse", "testelapse", "endelapse")]

# Zadanie domowe:
# 1. Nauczyć się dcast
# 2. Przeczytać FAQ i intro - winietki data.table
# 3. Użyć profvis() i microbenchmark() do porównania czasów wykonania typowych operacji
# w base, dplyr/tidyr i data.table na tych danych - wybór kolumn, filtrowanie,
# grupowanie i podsumowanie, join.
#
