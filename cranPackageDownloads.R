
#
# This code is from http://www.nicebread.de/finally-tracking-cran-packages-downloads/ 
#

## ======================================================================
## Step 1: Download all log files
## ======================================================================

# Here's an easy way to get all the URLs in R
start <- as.Date('2012-10-01')
today <- as.Date('2013-06-10')

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