
#
# This code is from http://www.nicebread.de/finally-tracking-cran-packages-downloads/ 
#

# set working directory
setwd("~/notesofdabbler/user2014_TshirtEntry/")

## ======================================================================
## Step 1: Download all log files
## ======================================================================

# Here's an easy way to get all the URLs in R
start <- as.Date('2014-05-01')
today <- as.Date('2014-05-30')

all_days <- seq(start, today, by = 'day')

year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

# only download the files you don't have:
missing_days <- setdiff(as.character(all_days), tools::file_path_sans_ext(dir("CRANlogs"), TRUE))

dir.create("CRANlogs")
for (i in 1:length(missing_days)) {
  print(paste0(i, "/", length(missing_days)))
  download.file(urls[i], paste0('CRANlogs/', missing_days[i], '.csv.gz'))
}

## ======================================================================
## Step 2: Load single data files into one big data.table
## ======================================================================

file_list <- list.files("CRANlogs", full.names=TRUE)

logs <- list()
for (file in file_list) {
  print(paste("Reading", file, "..."))
  logs[[file]] <- read.table(file, header = TRUE, sep = ",", quote = "\"",
                             dec = ".", fill = TRUE, comment.char = "", as.is=TRUE)
}

# rbind together all files
library(data.table)
dat <- rbindlist(logs)

# add some keys and define variable types
dat[, date:=as.Date(date)]
dat[, package:=factor(package)]
dat[, country:=factor(country)]
dat[, weekday:=weekdays(date)]
dat[, week:=strftime(as.POSIXlt(date),format="%Y-%W")]

setkey(dat, package, date, week, country)

save(dat, file="CRANlogs/CRANlogs.RData")

load("CRANlogs/CRANlogs.RData")

library(dplyr)
pkggrp=group_by(dat,package)
pkgcnt=summarize(pkggrp,count=n())
pkgcnt=arrange(pkgcnt,desc(count))
