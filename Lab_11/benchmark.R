library(ggplot2)
library(microbenchmark)
library(Rcpp)

source("R_functions.R")
sourceCpp("cpp_functions.cpp")

interval = seq(-1, 1, length.out = 100)
ggplot(data.frame(x = interval,
                  y = prcos(interval, 0, 1)),
       aes(x, y)) +
    geom_point() +
    theme_bw()

ggplot(data.frame(x = interval,
                  y = prcos_cpp(interval, 0, 1)),
       aes(x, y)) +
    geom_point() +
    theme_bw()

prcos(inverse_prcos(c(0.5, 0.7, 0.9), 0, 1), 0, 1)
prcos_cpp(inverse_prcos_cpp(c(0.5, 0.7, 0.9), 0, 1), 0, 1)

x = seq(-1, 1, length.out = 100)
microbenchmark(r = prcos(x, 0, 1),
               cpp = prcos_cpp(x, 0, 1),
               cpp2 = prcos_cpp2(x, 0, 1))

x = seq(0, 1, length.out = 100)
microbenchmark(
    r = inverse_prcos(x, 0, 1),
    r2 = inverse_prcos2(x, 0, 1),
    cpp = inverse_prcos_cpp(x, 0, 1)
)

# cppFunction("double prcos_single_inline(double x, double mu, double s) {
#     return(0.5 * (1 + (x - mu) / s + (1 / M_PI) * sin(M_PI * ((x - mu) / s))));
# }")
# prcos_single_inline(0, 0, 1)
