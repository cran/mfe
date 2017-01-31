## ------------------------------------------------------------------------
library(mfe)

## Extract all measures using formula
iris.info <- metafeatures(Species ~ ., iris, groups="all")

## Extract all measures using data frame
iris.info <- metafeatures(iris[,1:4], iris[,5], groups="all")

## Extract general, statistical and information-theoretic measures
iris.info <- metafeatures(Species ~ ., iris, 
                          groups=c("general", "statistical", "infotheo"))


## ------------------------------------------------------------------------
## Compute all measures using min, median and max 
iris.info <- metafeatures(Species ~ ., iris, summary=c("min", "median", "max"))
                          
## Compute all measures using quantile
iris.info <- metafeatures(Species ~ ., iris, summary="quantile")

## ------------------------------------------------------------------------
## Extract two statistical measures
stat.iris <- mf.statistical(Species ~ ., iris, 
                            features=c("correlation", "variance"))

## Extract two discriminant measures
disc.iris <- mf.discriminant(Species ~ ., iris, 
                             features=c("cancor", "cancor.fract"))

## Extract the histogram for the correlation measure
hist.iris <- mf.statistical(Species ~ ., iris, 
                            features="correlation", summary="hist")

## ------------------------------------------------------------------------
## Show the the available groups
ls.metafeatures()

## ------------------------------------------------------------------------
## Show the the available general measures
ls.general()

## Extract all general measures
general.iris <- mf.general(Species ~ ., iris, features="all")

## Extract two general measures
mf.general(Species ~ ., iris, features=c("nattribute", "nclasse"))

## ------------------------------------------------------------------------
## Show the the available statistical measures
ls.statistical()

## Extract all statistical measures
stat.iris <- mf.statistical(Species ~ ., iris, features="all")

## Extract two statistical measures
mf.statistical(Species ~ ., iris, features=c("correlation", "skewness"))


## ------------------------------------------------------------------------
## Extract correlation using all instances together
mf.statistical(Species ~ ., iris, features="correlation", by.class=FALSE)

## ------------------------------------------------------------------------
## Show the the available general measures
ls.discriminant()

## Extract all discriminant measures
disc.iris <- mf.discriminant(Species ~ ., iris, features="all")

## Extract two discriminant measures
mf.discriminant(Species ~ ., iris, features=c("cancor", "discfct"))

## ------------------------------------------------------------------------
## Show the the available infotheo measures
ls.infotheo()

## Extract all infotheo measures
inf.iris <- mf.infotheo(Species ~ ., iris, features="all")

## Extract two infotheo measures
mf.infotheo(Species ~ ., iris, 
            features=c("class.entropy", "mutual.information"))


## ------------------------------------------------------------------------
## Show the the available model.based measures
ls.model.based()

## Extract all model.based measures
land.iris <- mf.model.based(Species ~ ., iris, features="all")

## Extract three model.based measures
mf.model.based(Species ~ ., iris, features=c("nleave", "max.depth"))

## ------------------------------------------------------------------------
## Show the the available landmarking measures
ls.landmarking()

## Extract all landmarking measures
land.iris <- mf.landmarking(Species ~ ., iris, features="all")

## Extract two landmarking measures
mf.landmarking(Species ~ ., iris, features=c("naive.bayes", "nearest.neighbor"))

## ------------------------------------------------------------------------
## Extract one landmarking measures with folds=2
mf.landmarking(Species ~ ., iris, features="naive.bayes", folds=2)

## ------------------------------------------------------------------------
## Extract one landmarking measures using one.vs.all strategy
mf.landmarking(Species ~ ., iris, features="linear.discriminant", 
               map="one.vs.all")

## Extract one landmarking measures using one.vs.one strategy
mf.landmarking(Species ~ ., iris, features="linear.discriminant", 
               map="one.vs.one")

## ------------------------------------------------------------------------
## Apply several statistical measures as post processing
mf.statistical(Species ~ ., iris, "correlation", 
               summary=c("kurtosis", "max", "mean", "median", "min", "sd", 
                         "skewness", "var"))

## Apply quantile as post processing method
mf.statistical(Species ~ ., iris, "correlation", summary="quantile")

## ------------------------------------------------------------------------
## Apply histogram as post processing method
mf.statistical(Species ~ ., iris, "correlation", summary="hist")

## Apply histogram as post processing method and customize it
mf.statistical(Species ~ ., iris, "correlation", 
               summary="hist", bins=5, min=0, max=1)

## Extract all correlation values
mf.statistical(Species ~ ., iris, "correlation", summary="non.aggregated", 
               by.class=FALSE)

## ------------------------------------------------------------------------
## Compute the absolute difference between the mean and the median 
my.method <- function(x, ...) abs(mean(x) - median(x))

## Using the user defined post processing method
mf.statistical(Species ~ ., iris, "correlation", summary="my.method")

