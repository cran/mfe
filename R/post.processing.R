#' Post processing meta-features values
#'
#' Post-processing alternatives to deal with multiples meta-features values.
#' This method is used by the meta-features characterization methods to
#' summarize the obtained values.
#'
#' @param measure A list with the meta-features values.
#' @param summary The functions to post processing the data. See the details
#'   to more information. Default: \code{c("mean", "sd")}
#' @param multiple A logical value defining if the measure should return
#'   multiple values. (Default: \code{TRUE})
#' @param ... Extra values used to the functions of summarization.
#' @details
#'  The post processing functions are used to summarize the meta-features.
#'  They are organized into three groups: non-aggregated, descriptive
#'  statistic and distribution. Currently, the hypothesis testing post
#'  processing are not supported.
#'
#'  In practice, there are no difference among the types, so that more than one
#'  type and functions can be combined. Usually, these function are used to
#'  summarize a set of values for each meta-features. For instance, a measure
#'  computed for each attribute can be summarized using the \code{"mean"} and/or
#'  \code{"sd"}. Necessarily, a single value always use the
#'  \code{"non.aggregated"} function.
#'
#'  In addition to the native functions available in R, the following functions
#'  can be used:
#'  \describe{
#'    \item{"histogram"}{Computes a histogram of the given data value. The extra
#'       parameters '\code{bins}' can be used to define the number of values to
#'       be returned. The parameters '\code{max}' and '\code{min}' are used to
#'       define the range of the data. The default value for these parameters
#'       are respectively \code{10, min(x)} and \code{max(x)}.}
#'    \item{"kurtosis"}{See \code{\link[e1071]{kurtosis}}}
#'    \item{"max"}{See \code{\link{max}}}
#'    \item{"mean"}{See \code{\link{mean}}}
#'    \item{"median"}{See \code{\link{median}}}
#'    \item{"min"}{See \code{\link{min}}}
#'    \item{"quantiles"}{See \code{\link{quantile}}}
#'    \item{"sd"}{See \code{\link{sd}}}
#'    \item{"skewness"}{See \code{\link[e1071]{skewness}}}
#'    \item{"var"}{See \code{\link{var}}}
#'    \item{"non.aggregated"}{Returns the original value(s) of the
#'       meta-feature.}
#'  }
#'  These functions are not restrictive, thus another functions can be applied
#'  as post-processing summarization function.
#'
#' @return A list with the post-processed meta-features
#'
#' @references
#'  Fabio Pinto, Carlos Soares, and Joao Mendes-Moreira. Towards Automatic
#'  Generation of Metafeatures. In 20th Pacific-Asia Conference on Knowledge 
#'  Discovery and Data Mining  (PAKDD), pages 215 - 226, 2016.
#'
#' @examples
#' post.processing(runif(15))
#' post.processing(runif(15), c("min", "max"))
#' post.processing(runif(15), c("quantiles", "skewness"))
#' post.processing(runif(15), "histogram", bins=5, min=0, max=1)
#' @export
post.processing <- function(measure, summary=c("mean", "sd"), multiple=TRUE,
                            ...) {
  measure[!is.finite(measure) | is.null(measure) | is.nan(measure)] <- NA
  if(length(measure) == 0) {
    measure <- as.numeric(NA)
  }

  if(!multiple) {
    if(length(measure) > 1) {
      warning("More than one value was obtained for a single measure")
    }
    return(measure[1])
  }

  skewness <- function(x, na.rm=FALSE, type=3, ...) {
    e1071::skewness(x, na.rm, type)
  }

  kurtosis <- function(x, na.rm=FALSE, type=3, ...) {
    e1071::kurtosis(x, na.rm, type)
  }

  quantiles <- function(x, type=1, ...) {
    tryCatch(
      stats::quantile(x, type=type, ...),
      error=function(e) stats::quantile(NA, na.rm=TRUE, ...)
    )
  }

  iqr <- function(x, na.rm=FALSE, ...) {
     if (!na.rm & any(is.na(x))) NA
     else stats::IQR(x, na.rm = na.rm)
  }

  res <- sapply(summary, function(s) {
    do.call(s, list(measure, ...))
  }, simplify=FALSE)

  unlist(res)
}

non.aggregated <- function (x, ...) {
  x
}

histogram <- function(x, bins=10, min=base::min(x, na.rm=TRUE),
                 max=base::max(x, na.rm=TRUE), ...) {
  breaks <- seq(ifelse(is.finite(min), min, 0),
                ifelse(is.finite(max), max, bins), length.out=bins + 1)
  graphics::hist(as.numeric(x), breaks=breaks, plot=FALSE)$counts / length(x)
}
