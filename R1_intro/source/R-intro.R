params <-
list(is_virtual = TRUE)

## ----calculator---------------------------------------------------------------
1 + 1
2 * 2
2 ^ 3


## ----calculator2--------------------------------------------------------------
10 - 1
8 / 2
sqrt(9)


## ----vector_demo, echo=4------------------------------------------------------
.opts.width <- getOption('width')
options(width = 30)
2
1:10
options(width = .opts.width)


## ----vectors_1, results='hide'------------------------------------------------
sum( c(1, 2, 3, 4, 5) )
1:10 + 2
1:5 * 5:1


## ----vectors_2, results='hide', fig.keep='none'-------------------------------
plot( rnorm(1000) )
hist( rnorm(1000) )


## ----data_types, results='hide'-----------------------------------------------
class(1.23)
class('hello')
class("1.23")
class(FALSE)

typeof(1.23)
typeof(1:10)

as.character(c(1,2,NA,4))


## ----assignment, results='hide'-----------------------------------------------
A <- 10
B <- 10 * 10
A_log <- log(A)
B.seq <- 1:B

assign('x', 3)


## -----------------------------------------------------------------------------
A
A_log


## -----------------------------------------------------------------------------
B
x


## -----------------------------------------------------------------------------
get("B.seq")


## -----------------------------------------------------------------------------
pi


## ---- eval=FALSE--------------------------------------------------------------
## version

## ---- echo=FALSE--------------------------------------------------------------
cat("... information about \nthis version of R ...")


## -----------------------------------------------------------------------------
letters
LETTERS


## -----------------------------------------------------------------------------
A +5


## -----------------------------------------------------------------------------
B/A


## ----calc_var, fig.keep='none'------------------------------------------------
Weight <- c(60 , 72 , 57 , 90 , 95 , 72 )
Height <- c(1.7, 1.8, 1.6, 1.9, 1.7, 1.9)
BMI <- Weight / Height^2
BMI
plot(Height, Weight)


## ---- echo=FALSE--------------------------------------------------------------
## run this command, which is in a non-executable block in the table.
rm(list=ls())

## ----bad_pie, results='hide'--------------------------------------------------
pi
pi <- "pie"
pi
rm(pi)
pi


## ----comparisons1-------------------------------------------------------------
1 == 2
1 <= 2
1 < "a"


## ----comparisons2-------------------------------------------------------------
1 < 2
1 != "foo"
0 == FALSE


## ----comparing_decimals-------------------------------------------------------
a <- sqrt(2)
a * a == 2  # should be TRUE
a * a - 2


## ----comparing_round----------------------------------------------------------
round(a * a, 8) == 2  #(1)
all.equal(a * a, 2)   #(2)


## ----function_call, echo=3----------------------------------------------------
.opts.width <- getOption('width')
options(width = 30)
ls()


## ----function_not_call, echo=1------------------------------------------------
ls
options(width = .opts.width)


## ----complex_expr_fun, results='hide'-----------------------------------------
Var <- sum( ((x <- 1:20) - mean(x))^2 / (length(x) -1) )


## ----complex_simple_fun-------------------------------------------------------
var(1:20)


## ----errors1_code, eval=FALSE, echo=TRUE--------------------------------------
## Fail <- 1 + "2"

## ----errors1_out, eval=TRUE, echo=FALSE---------------------------------------
try( Fail <- 1 + "2" )

## ----errors2_code, eval=FALSE, echo=TRUE--------------------------------------
## Fail

## ----errors2_out, eval=TRUE, echo=FALSE---------------------------------------
try( Fail )


## ----warnings-----------------------------------------------------------------
oops <- log(-1)


## ----help, eval=FALSE---------------------------------------------------------
## help.start()


## ----help_sort, results='hide'------------------------------------------------
unsorted_vector <- c(1, 6, -2, 9.5, 4)
help.search("sort")


## ----data.frame_str, echo=2---------------------------------------------------
data(CO2)  # previous slide doesn't have *executable* code chunks, so ensure it is loaded for future examples.
str(CO2)


## ---- eval=FALSE--------------------------------------------------------------
## CO2[1:6, 3]
## CO2$Treatment


## ---- eval=FALSE--------------------------------------------------------------
## ?recode
## recode(CO2$Type, "'Quebec'='QC'; else='MS'")

## ---- echo=FALSE--------------------------------------------------------------
try( recode(CO2$Type, "'Quebec'='QC'; else='MS'") )


## ----echo=TRUE, eval=FALSE----------------------------------------------------
## library(car)

## ----echo=FALSE, eval=TRUE----------------------------------------------------
try( library(car) )


## ----install_car, echo=FALSE, results='hide', message=FALSE-------------------
## execute the code
install.packages("car")
library(car)


## ----use_recode---------------------------------------------------------------
?recode
recode(CO2$Type, "'Quebec'='QC'; else='MS'")


## ---- results='hide'----------------------------------------------------------
x <- 0


## ----command-r-examples, results='hide'---------------------------------------
x <- x + 1
x <- x * (x+10)
x <- log(x)
x <- exp(x)
x <- 1:x
x <- seq(from=x[1], to=100, 
         by=2)
x <- rnorm(x)
x <- x[1:3]
x <- x[2]
x <- data.frame(
  foo = rnorm(length(x)),
  x
)


## ----help.start, eval=FALSE---------------------------------------------------
## help.start()

