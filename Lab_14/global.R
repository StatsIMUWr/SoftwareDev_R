library(shiny)
library(data.table)
library(lubridate)
library(shinydashboard)
library(DT)
library(ggplot2)

streaming_history = readRDS("./www/history.RDS")
streaming_history[, time_hour := hour(end_time)]

min_time = min(streaming_history$end_time, na.rm = TRUE)
max_time = max(streaming_history$end_time, na.rm = TRUE)
