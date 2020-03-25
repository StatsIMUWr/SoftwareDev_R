# More: https://adv-r.hadley.nz/environments.html
# Environments: connect names to values
# Similar to lists, but:
# names are unique, there is no order,
# environments have parents and are never copied
#
# l = list(x = 1)
# l[["x"]] <- NULL
# l

env_1 = as.environment(
    list(x = 1,
         y = 2)
)
env_2 = as.environment(
    list(x = 10,
         y = 20)
)
names(env_1)
env_1[["x"]]
# + rm, ls, exists, identical

x + y
eval(x + y)
eval(expression(x + y), envir = env_1)
parent.env(env_1) = .GlobalEnv
eval(expression(x + y), envir = env_1)
eval(quote(x + y), envir = env_2)
parent.env(env_2) = .GlobalEnv
eval(quote(x + y), envir = env_2)
eval(expression(x + y + 10), envir = env_1)
# Similar: lm(y ~ x1 + x2, data = df)

class(quote(x + y))
class(expression(x + y))
# quote vs expression: https://r.789695.n4.nabble.com/What-is-the-difference-between-expression-and-quote-when-used-with-eval-td1561974.html

quote(a <- "a")
# Interesting: <- and = are not always equivalent
quote(a = "a")
a
# median(x <- 1:10)
# x

# Without evaluation:
substitute(x + y, env_1)

deparse(substitute(x + y, env_1))
class(deparse(substitute(x + y, env_1)))

deparse(quote(x + y))
deparse(quote(x + y + 1:10))

# plot(x = 1:10,
#      y = 1:10)

# With evaluation:
eval(substitute(x + y, env_1))

# Non-standard evaluation
# dplyr::select(df, Col1, Col2)
# subset(df, col1 == 1)
# df[df[["col1"]] == 1, ]
# df[, c("Col1", "Col2")]
l = list(x = 1,
         y = 2,
         z = 3)
l[[x]]
names(l)
l[["x"]]
class(l) = c("my_list", class(l))
`[[.my_list` = function(l, element_name, ...) {
    eval(substitute(element_name), l)
}
l[[x]]
l[[y]]
l[[z]]
list(x = 1, y = 2, z = 3)[[x]]

z = as.name("x")
z
deparse(substitute(z)) # Again: trick to take variable's name, disregarding value
eval(z, list(x = 1))
# More practical instance of this idea:
cols = letters[1:20]
as.formula(paste("y ~", paste(cols, sep = " + ", collapse = " + ")))
# This can be passed to for example lm()
# More: https://adv-r.hadley.nz/evaluation.html

# What is the hierarchy of environments?
# Global environment
names(.GlobalEnv)
# Environments of attached packages
# Environment of the base package
# Empty environment

# Related:
# attach: places names in the global environment
# load / library: doesnt'

# Environments hierarchy when using functions:
# Good reference: https://rstudio-pubs-static.s3.amazonaws.com/278710_bb8897865caf43c6a39757278547b1f4.html
# the enclosing environment, the environment where the function was created
# binding a function to a name using <- creates a binding environment
# calling a function creates an execution environment that stores variable created during execution
# every execution environment is associated to a calling environment which tells you where the function was called

# The enclosing environment is the secret behind closures
power_again = function(exponent) {
    force(exponent)
    function(x) {
        x ^ exponent
    }
}
square_again = power_again(2)
square_again
environment(power_again)
environment(square_again)
# The same function can be binded to a different name for example in env_1,
# so it can have multiple binding environments


# Super assignment: <<-
# <<- doesn't create a variable in the current evironment, but modifies it inside a parent environment
# Now that env_1 and env_2 have parent environments, let's try it
z = 10
eval(expression(z <<- 1), envir = env_2)
z
names(env_2)
# If it doesn't find it there, it creates a variable in global environment

# Namespaces: as we've seen, what R finds as a value for a given name of a variable,
# depends on the hierarchy of environmets. To mitigate this, we use namespaces and ::
dplyr::count(data.frame(x = 1:10))
# This is especially important when writing packages
# Package environment: external interface - what we see (like above)
# Namespace environment: how functions in a package find their variables (including other functions, possibly from other packages)
# imports (namespace env) is the parent of the package env, global env is "the most parent" env here
# imports is the enclosing env

# Ciekawe przykłady: https://github.com/mini-pw/2020Z-ProgramowanieWR/blob/master/Prezentacje/P2.Rmd
