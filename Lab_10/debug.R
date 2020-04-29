# Kiedy kod zwraca błąd.
# 1. Przeczytać komunikat
# 2. Jeżeli jest w nim nazwa funkcji, linijka w kodzie itd - zobaczyć
# 3. Jeżeli nie - duckduckgo.com (w ostateczności google.com)
#

xd2 = function() {
    x = 1
    y = 2
    stop("Wywaliło się")
}
xd2()

xd3 = function() {
    xd2()
    "Ojej"
}
xd3()

xd = function() {
    x = 1
    browser()
    "xD"
}
xd()


