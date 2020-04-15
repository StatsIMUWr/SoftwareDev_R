library(usethis)

xx = data.frame(x = 1:10,
                y = letters[1:10])
save(xx, file = "./data/xx.rda")
use_data(xx)

data(package = "ActuallyFirstExamplePackage")
data()
data("xx")
head(xx)

x <- 1:10
y <- 11:20
usethis::use_data(x, y, internal = TRUE)
rm(x, y)


# old_names = c("X", "Y")
# names(old_names) = c("id_", "x")
# old_names[sample(c("id_", "x"), 100, prob = c(0.5, 0.5), replace = TRUE)]

library(ActuallyFirstExamplePackage)
data(package = "ActuallyFirstExamplePackage")
ActuallyFirstExamplePackage:::x

toBibtex(citation("glmnet"))
citation("mlr")

readr::write_csv(xx, path = "./inst/extdata/xx.csv")

readr::read_csv(system.file("extdata", "xx.csv", package = "ActuallyFirstExamplePackage"))

use_readme_md()
use_news_md()
use_vignette("example_vig", "Example vignette for this wonderful package")

use_pkgdown()
use_pkgdown_travis()

use_coverage("codecov")
use_travis()

# devtools::document()
# devtools::check()
# devtools::install()
