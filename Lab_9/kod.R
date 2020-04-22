# S3
# Klasa: MyGreatGreatLinearModel
fit_gglm = function(X, y) {
    model = lm(y ~ X)
    # structure(model, class = "MyGreatGreatLinearModel")
    class(model) <- c("MyGreatGreatLinearModel", class(model))
    model
}

X = MASS::mvrnorm(n = 100, mu = rep(0, 10), Sigma = diag(1, 10))
y = X%*%rep(4, 10) + rnorm(100)

o_model = fit_gglm(X, y)
class(o_model)

summary.MyGreatGreatLinearModel = function(x, ...) {
    paste("The biggest coefficient is", max(coef(x)), "WOW")
}

library(ggplot2)

plot.MyGreatGreatLinearModel = function(x, ...) {
    ggplot(data.frame(x = paste("coef_", 1:10), y = coef(x)[2:11]), aes(x, y)) +
        geom_point() +
        coord_flip() +
        theme_bw()
}

plot(o_model)

summary(o_model)
summary(unclass(o_model))

# S4
library(methods)

setClass("MyGreatGreatLinearModel",
         slots = list(model = "lm"))
# setClass("MyGreatGreatLinearModel", contains = "lm")
os4_model = new("MyGreatGreatLinearModel", model = lm(y ~ X))

os4_model

setGeneric("our_plot", function(x, ...) {
    standardGeneric("our_plot")
})

# os4_model$model

setMethod("our_plot", signature("MyGreatGreatLinearModel"),
          function(x, ...) {
              ggplot(data.frame(x = paste("coef_", 1:10),
                                y = coef(x@model)[2:11]),
                     aes(x, y)) +
                  geom_point() +
                  coord_flip() +
                  theme_bw()
          })
our_plot(os4_model)

setMethod("our_plot", signature("data.frame"),
          function(x, ...) {
              plot(x[, 1], x[, 2])
          })

our_plot(as.data.frame(X))

# Przeczytać Hadleya - rozdział OOP
# Rozszerzyć konstruktor klasy S3 o metodę imputacji w dwóch wersjach:
#   - z parametrem imputation_method = "napis",
#   - z parametrem imputer dla którego istnieje metoda our_impute / impute
#   - w wyniku zwrócić np. listę modelu i informacji nt. metody imputacji i liczby braków
# Napisać metodę plot i metodę summary (z info nt. braków i współczynników)
# Powtórzyć to dla S4
# Dla S4 napisać gettery dla modelu i informacji nt. braków danych
# getModel(our_s4_model), getMissignessInfo(our_model_s4)
# ew. powtórzyć dla R6
# ew. zobaczyć, co jest najszybsze
# Koniecznie: skomentować, które rozwiązanie uważacie za najlepsze
#

# R6
library(R6)
# Mt uzupełni
