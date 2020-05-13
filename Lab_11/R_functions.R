
prcos = function(x, mu, s) {
    0.5 * (1 + (x - mu) / s + (1 / pi) * sin(pi * ((x - mu) / s)))
}

prcos(c(0.1, 0.5, 1), 0, 1)

inverse_single = function(y, mu, s) {
    uniroot(function(x) prcos(x, mu, s) - y, lower = mu - s, upper = mu + s,
            tol = 1e-10)$root
}

inverse_prcos = function(x, mu, s) {
    sapply(x, function(single_x) inverse_single(single_x, mu, s))
}

inverse_prcos2 = function(x, mu, s) {
    result = vector("numeric", length(x))
    for (i in 1:length(x)) {
        result[i] = inverse_single(x[i], mu, s)
    }
}
