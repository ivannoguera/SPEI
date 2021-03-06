#' @title Calculation of the Evaporative Demand Drought Index (EDDI) 
#' 
#' 
#' @description
#' Provides a time series of Evaporative Demand Drought Index (EDDI) 
#' from a time series of the potential evapotranspiration (ETo) 
#' 
#' 
#' @usage 
#' eddi(data, scale, kernel = list(type = 'rectangular', shift = 0),
#' distribution = 'log-Logistic', fit = 'ub-pwm', na.rm = FALSE,
#' ref.start=NULL, ref.end=NULL, x=FALSE, params=NULL, ...)
#' 
#' 
#' @param data a vector, matrix or data frame with time ordered values 
#' of potential evapotranspiration (ETo) 
#' @param scale an integer, representing the time scale at which 
#' the EDDI will be computed.
#' @param kernel optional, a list defining the type of kernel used 
#' for computing the EDDI at scales higher than one. Defaults 
#' to unshifted rectangular kernel.
#' @param distribution optional, name of the distribution function 
#' to be used for computing the EDDI (one of 'log-Logistic',  
#' 'Normal' and 'PearsonIII'). Defaults to 'log-Logistic' 
#' @param fit optional, name of the method used for computing the 
#' distribution function parameters (one of 'ub-pwm', 'pp-pwm' and 
#' 'max-lik'). Defaults to 'ub-pwm'.
#' @param na.rm optional, a logical value indicating whether NA values 
#' should be stripped from the computations. Defaults to FALSE, i.e. 
#' no NA are allowed in the data.
#' @param ref.start optional, starting point of the reference period 
#' used for computing the index. Defaults to NULL, indicating that the 
#' first value in data will be used as starting point.
#' @param ref.end optional, ending point of the reference period used 
#' for computing the index. Defaults to NULL, indicating that the last 
#' value in data will be used as ending point.
#' @param x optional, a logical value indicating wether the data used 
#' for fitting the model should be kept. Defaults to FALSE.
#' @param params optional, an array of parameters for computing the 
#' EDDI. This option overrides computation of fitting parameters.
#' @param ... other possible parameters.
#' 
#' 
#' @details 
#' This function is based on spei funtion provided by Santiago Beguería 
#' and Sergio M. Vicente-Serrano (https://github.com/sbegueria/SPEI).
#' The function standardize a variable following a log-Logistic
#' (or Normal or PearsonIII) distribution function (i.e., they transform it to a
#' standard Gaussian variate with zero mean and standard deviation of one).
#' 
#' 
#' @section Input data:
#' The input variable is a time ordered series of potential evapotranspiration (ETo). 
#' When used with the default options, it would yield values of both indices exactly  
#' as defined in the references given below.
#' 
#' The EDDI were defined for monthly data. Since the PDFs of the
#' data are not homogenous from month to month, the data is split into twelve
#' series (one for each month) and independent PDFs are fit to each series. If 
#' \code{data} is a vector or a matrix it will be treated as a sequence of monthly 
#' values starting in January. If it is a (univariate or multivariate) time series
#' then the function \code{\link{cycle}} will be used to determine the position of 
#' each observation within the year (month), allowing the data to start in a month 
#' other than January.
#' 
#' 
#' @section Time scales:
#' The EDDI can be computed at different time scales. 
#' This way it is possible to incorporate the influence of the past values 
#' of the variable in the computation enabling the index to adapt 
#' to the memory of the system under study. The magnitude of this memory is 
#' controlled by parameter \code{scale}. For example, a value of six would imply 
#' that data from the current month and of the past five months will be used for 
#' computing the EDDI value for a given month. By default all past data will 
#' have the same weight in computing the index, as it was originally proposed in the 
#' references below. Other kernels, however, are available through parameter \code{kernel}. 
#' The parameter \code{kernel} is a list defining the shape of the kernel and a time shift. 
#' These parameters are then passed to the function \code{\link{kern}}.
#' 
#' 
#' @section Probability distributions:
#' \code{eddi} uses a log-Logistic distribution as suggested Noguera et al. 2021
#' This behaviour can be modified, however, through parameter \code{distribution}.
#' 
#' 
#' @section Fitting methods:
#' The default method for parameter fitting is based on unbiased Probability Weighted 
#' Moments ('ub-pwm'), but other methods can be used through parameter \code{fit}. 
#' A valid alternative is the plotting-position PWM ('pp-pwm') method. For the log-Logistic 
#' distribution, also the maximum likelihood method ('max-lik') is available.
#' 
#' 
#' @section User-provided parameters:
#' An option exists to override parameter fitting and provide user default parameters. 
#' This is activated with the parameter \code{params}. The exact values provided to this 
#' parameter depend on the distribution function being used. For log-Logistic and PearsonIII 
#' it should be a three-dimensional array with dimensions (3,number of series in data,12), 
#' containing twelve parameter triads (xi, alpha, kappa) for each data series, one for each
#' month. For Normal, a three-dimensional array with dimensions (2,number of series in data,12), 
#' containing twelve parameter pairs (mu, sigma). It is a good idea to look at the 
#' coefficients slot of a previously fit \code{eddi} EDDI object in order to understand the 
#' structure of the parameter array. The parameter \code{distribution} is still used under 
#' this option in order to know what distribution function should be used.
#' 
#' 
#' @section Reference period:
#' The default behaviour of the functions is using all the values provided in \code{data} 
#' for parameter fitting. However, this can be modified with help of parameters \code{ref.start} 
#' and \code{ref.end}. These parameters allow defining a subset of values that will be used 
#' for parameter fitting, i.e. a reference period. The functions, however, will compute the 
#' values of the indices for the whole data set. For these options to work it is necessary that 
#' \code{data} will be a time series object. The starting and ending points of the reference period 
#' will then be defined as pairs of year and month values, e.g. c(1900,1).
#' 
#' 
#' @section Processing large datasets:
#' It is possible to use the \code{eddi} function for processing multivariate 
#' datasets at once. If a matrix or data frame is supplied as \code{data}, with time series of 
#' potential evapotranspiration (ETo) arranged in columns, the 
#' result would be a matrix (data frame) of EDDI series. This makes processing large datasets 
#' extremely easy, since no loops need to be used.
#' 
#' 
#' @return 
#' Functions \code{eddi} and \code{spi} return an object of class \code{eddi}. The generic 
#' functions \code{print} and \code{summary} can be used to obtain summaries of the results. 
#' The generic accessor functions \code{coefficients} and \code{fitted} extract useful features 
#' of the object.
#' 
#' An object of class \code{eddi} is a list containing at least the following components:
#' 
#' \itemize{
#'   \item call: the call to \code{eddi} used to generate the object.
#'   \item fitted: time series with the values of the Evaporative Demand Drought Index (EDDI)  
#'   If data consists of several columns 
#'   the function will treat each column as independent data, and the result will be a multivariate 
#'   time series. The names of the columns in \code{data} will be used as column names in fitted.
#'   \item coefficients: an array with the values of the coefficients of the distribution function 
#'   fitted to the data. The first dimension of the array contains the three (or two) coefficients, 
#'   the second dimension will typically consist of twelve values corresponding to each month, and 
#'   the third dimension will be equal to the number of columns (series) in \code{data}. If a time 
#'   scale greater than one has been used then the first elements will have NA value since the kernel 
#'   can not be applied. The first element with valid data will be the one corresponding to the time 
#'   scale chosen.
#'   \item scale: the \code{scale} parameter used to generate the object.
#'   \item kernel: the parameters and values of the kernel used to generate the object.
#'   \item distribution: the distribution function used to generate the object.
#'   \item fit: the fitting method used to generate the object.
#'   \item na.action: the value of the na.action parameter used.
#'   \item data: if requested, the input data used.
#' }
#' 
#' 
#' @references 
#' Noguera, I.; Vicente-Serrano, S.M.; Domínguez-Castro, F.; Reig, F. 2021. Assessment of parametric approaches to calculate the Evaporative Demand 
#' Drought Index (EDDI). Int. J. Climatol. Under Review.
#' 
#' 
#' @author Iván Noguera, Sergio M. Vicente-Serrano, Fernando Domínguez-Castro and Fergus Reig. 
#' 
#' 
eddi <- function(data, scale, kernel=list(type='rectangular',shift=0),
                 distribution='log-Logistic', fit='ub-pwm', na.rm=FALSE, 
                 ref.start=NULL, ref.end=NULL, x=FALSE, params=NULL, ...) {
  
  scale <- as.numeric(scale)
  na.rm <- as.logical(na.rm)
  x <- as.logical(x)
  #if (!exists("data",inherits=F) | !exists("scale",inherits=F)) {
  #	stop('Both data and scale must be provided')
  #}
  if (anyNA(data) && na.rm==FALSE) {
    stop('Error: Data must not contain NAs')
  }
  if (!(distribution %in% c('log-Logistic', 'Normal', 'PearsonIII'))) {
    stop('Distrib must be one of "log-Logistic", "Normal" or "PearsonIII"')
  }
  if (!(fit %in% c('max-lik', 'ub-pwm', 'pp-pwm'))) {
    stop('Method must be one of "ub-pwm" (default), "pp-pwm" or "max-lik"')
  }
  if ( (!is.null(ref.start) && length(ref.start)!=2) | (!is.null(ref.end) && length(ref.end)!=2) ) {
    stop('Start and end of the reference period must be a numeric vector of length two.')
  }
  
  if (!is.ts(data)) {
    data <- ts(as.matrix(data), frequency = 12)
  } else {
    data <- ts(as.matrix(data), frequency=frequency(data), start=start(data))
  }
  m <- ncol(data)
  fr <- frequency(data)
  
  
  coef = switch(distribution,
                "Normal" = array(NA,c(2,m,fr),list(par=c('mu','sigma'),colnames(data),NULL)),
                "log-Logistic" = array(NA,c(3,m,fr),list(par=c('xi','alpha','kappa'),colnames(data),NULL)),
                "PearsonIII" = coef <- array(NA,c(3,m,fr),list(par=c('mu','sigma','gamma'),colnames(data),NULL))
  )
  
  dim_one = ifelse(distribution == "Normal", 2, 3)
  
  if (!is.null(params)) {
    if (dim(params)[1]!=dim_one | dim(params)[2]!=m | dim(params)[3]!=fr) {
      stop(paste('parameters array should have dimensions (', dim_one, ', ', m, ', fr)',sep=' '))
    }
  }
  
  # Loop through series (columns in data)
  if (!is.null(ref.start) && !is.null(ref.end)) {
    data.fit <- window(data,ref.start,ref.end)	
  } else {
    data.fit <- data
  }
  std <- data*NA
  for (s in 1:m) {
    # Cumulative series (acu)
    acu <- data.fit[,s]
    acu.pred <- data[,s]
    if (scale>1) {
      wgt <- kern(scale,kernel$type,kernel$shift)
      acu[scale:length(acu)] <- rowSums(embed(acu,scale)*wgt,na.rm=na.rm)
      acu[1:(scale-1)] <- NA
      acu.pred[scale:length(acu.pred)] <- rowSums(embed(acu.pred,scale)*wgt,na.rm=na.rm)
      acu.pred[1:(scale-1)] <- NA
    }
    
    # Loop through the months
    for (c in (1:fr)) {
      # Filter month m, excluding NAs
      f <- which(cycle(acu)==c)
      f <- f[!is.na(acu[f])]
      ff <- which(cycle(acu.pred)==c)
      ff <- ff[!is.na(acu.pred[ff])]
      
      # Monthly series, sorted
      month <- sort.default(acu[f], method="quick")
      
      if (length(month)==0) {
        std[f] <- NA
        next()
      }
      
      if(distribution != "log-Logistic"){
        pze <- sum(month==0)/length(month)
        month = month[month > 0]
      }
      
      if (is.null(params)) {
        month_sd = sd(month,na.rm=TRUE)
        if (is.na(month_sd) || (month_sd == 0)) {
          std[f] <- NA
          next
        }
        
        # Stop early and assign NAs if month's data is length < 4
        if(length(month) < 4){
          std[ff,s] = NA
          coef[,s,c] <- NA
          next
        }
        
        # Calculate probability weighted moments based on fit with lmomco or TLMoments
        pwm = switch(fit,
                     "pp-pwm" = pwm.pp(month,-0.35,0, nmom=3),
                     #pwm.ub(month, nmom=3)
                     TLMoments::PWM(month, order=0:2)
        )
        
        # Check L-moments validity
        lmom <- pwm2lmom(pwm)
        if ( !are.lmom.valid(lmom) || anyNA(lmom[[1]]) || any(is.nan(lmom[[1]])) ){
          next
        }
        
        # lmom fortran functions need specific inputs L1, L2, T3
        # this is handled by lmomco internally with lmorph
        fortran_vec = c(lmom$lambdas[1:2], lmom$ratios[3])
        
        # Calculate parameters based on distribution with lmom then lmomco
        f_params = switch(distribution,
                          "log-Logistic" = tryCatch(lmom::pelglo(fortran_vec), error = function(e){ parglo(lmom)$para }),
                          "Normal" = tryCatch(lmom::pelnor(fortran_vec), error = function(e){ parnor(lmom)$para }),
                          "PearsonIII" = tryCatch(lmom::pelpe3(fortran_vec), error = function(e){ parpe3(lmom)$para })
        )
        
        # Adjust if user chose log-Logistic and max-lik
        if(distribution == 'log-Logistic' && fit=='max-lik'){
          f_params = parglo.maxlik(month, f_params)$para
        }
      } else {
        
        f_params = as.vector(params[,s,c])
        
      }
      
      # Calculate cdf based on distribution with lmom
      cdf_res = switch(distribution,
                       "log-Logistic" = lmom::cdfglo(acu.pred[ff], f_params),
                       "Normal" = lmom::cdfnor(acu.pred[ff], f_params),
                       "PearsonIII" = lmom::cdfpe3(acu.pred[ff], f_params)				  				
      )
      
      # Fitted values, reversing the sign of EDDI values
      std[ff,s] = -qnorm(cdf_res)
      coef[,s,c] <- f_params
      
      # Adjust if user chose Normal or PearsonIII
      if(distribution != 'log-Logistic'){ 
        std[ff,s] = qnorm(pze + (1-pze)*pnorm(std[ff,s]))
      }
      
    } # next c (month)
  } # next s (series)
  colnames(std) <- colnames(data)
  
  z <- list(call=match.call(expand.dots=FALSE),
            fitted=std,coefficients=coef,scale=scale,kernel=list(type=kernel$type,
                                                                 shift=kernel$shift,values=kern(scale,kernel$type,kernel$shift)),
            distribution=distribution,fit=fit,na.action=na.rm)
  if (x) z$data <- data
  if (!is.null(ref.start)) z$ref.period <- rbind(ref.start,ref.end)
  
  class(z) <- 'eddi'
  return(z)
}
