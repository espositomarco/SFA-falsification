# Author: Marco Esposito
library(optparse)

CommandLineOptions = function() {
  option_list = list(
    make_option(c("-i", "--maxiter"), type="integer", default="4", 
              help="Max number of iterations of the SSIFL algorithm. [default= %default]", 
              metavar="integer"),
    make_option(c("-s", "--sampling"), type="character", default="halton", 
              help="Input space sampling method. (halton, random) [default= %default]", 
              metavar="character"),
    make_option(c("-r", "--readsamples"), action="store_true", default=FALSE, 
              help="Read existing sample files. [default= %default]", 
              metavar="logical"),
    make_option(c("-c", "--readcoeff"), action="store_true", default=FALSE, 
              help="Read existing sample files. [default= %default]", 
              metavar="logical"),
    make_option(c("-t", "--threshold"), type="numeric", default=0.9, 
              help="Threshold value for the KPIs [default= %default]", metavar="cnumeric"),
    make_option(c("-e", "--epsilon"), type="numeric", default=0.3, 
              help="Epsilon value for the SSIFL algorithm. [default= %default]", metavar="numeric"),
    make_option(c("-d", "--delta"), type="numeric", default=0.3, 
              help="Delta value for the SSIFL algorithm. [default= %default]", metavar="numeric"),
    make_option(c("-p", "--problem"), type="character", default="max", 
              help="Type of MILP problem to generate (max, min) [default= %default]", metavar="character"),
    make_option(c("-M", "--pmethod"), type="character", default="backward", 
              help="Pruning method for the MARS algorithm.[default= %default]", metavar="character"),
    make_option(c("-T", "--threshmars"), type="numeric", default=0.001, 
              help="thresh parameter for the MARS algorithm. [default= %default]", metavar="numeric"),
    make_option(c("-P", "--penalty"), type="integer", default=-1, 
              help="penalty parameter for the MARS algorithm. [default= %default]", metavar="integer")

  ); 


   
  opt_parser = OptionParser(option_list=option_list);
  return(parse_args(opt_parser));
}

