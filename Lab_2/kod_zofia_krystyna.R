#  install.packages(c("stringr","rvest","httr", "readxl", "readr", "jsonlite", "tidyr))

library(readr)
library(stringr)
library(dplyr)

lf = c(list.files(), "gowno.R")

glassoTxt = try(lapply(lf, read_lines))

glassoTxt = lapply(lf, function(x) try(read_lines(x)))

lapply(glassoTxt, class)

isNotError = function(obj) {
  !inherits(obj, "try-error")
}

glassoTxt[sapply(glassoTxt, isNotError)]


read_one_file = function(file_name) {
  data.frame(line = read_lines(file_name),
             file = file_name)
}

df = bind_rows(lapply(lf, function(x) tryCatch(read_one_file(x),
                                               error = function(e) {
                                                 cat(paste("Reading file ", x, "failed"))
                                                 data.frame(line = NULL, file = NULL)
                                               })))

dfGlasso = lapply(glassoTxt, function(x) data.frame(line = x))

#names(dfGlasso)

dfGlassoFile = lapply(1:2, function(i) mutate(dfGlasso[[i]], file = lf[i]))
dfGlassoBind = bind_rows(dfGlassoFile)
# 
# noEmptyLines = filter(L2, line != "")


dfGlassoBind %>% 
  filter(line != "") %>% 
  mutate(isDocumentation = str_detect(line, "#'"), 
         isFunction = str_detect(line, "function")) %>% 
  group_by(file) %>% 
  summarise(nDocLines = sum(isDocumentation), nFun = sum(isFunction), nTotal = n()) %>% 
  mutate(propDoc = nDocLines* 100/nTotal)
