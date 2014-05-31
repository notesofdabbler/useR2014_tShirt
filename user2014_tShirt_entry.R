#
# Entry for user!12014 T-shirt
# Author: rdabbler
#

# load libraries
library(ggplot2)
library(scales)

# set working directory
setwd("~/notesofdabbler/user2014_TshirtEntry/")


# code taken from github initial commit 
R<-c(rep(1,19),rep(0,5), 
     rep(1,20),rep(0,4),
     rep(1,22),rep(0,2),
     rep(1,6),rep(0,10),rep(1,7),0,
     rep(1,6),rep(0,11),rep(1,7),
     rep(1,6),rep(0,12),rep(1,6),
     rep(1,6),rep(0,12),rep(1,6), 
     rep(1,6),rep(0,12),rep(1,6),
     rep(1,6),rep(0,12),rep(1,6),
     rep(1,6),rep(0,10),rep(1,7),0,
     rep(1,23),0,
     rep(1,22),rep(0,2),
     rep(1,21),rep(0,3),
     rep(1,19),rep(0,5),
     rep(1,6),rep(0,7),rep(1,5),rep(0,6),
     rep(1,6),rep(0,8),rep(1,4),rep(0,6),
     rep(1,6),rep(0,8),rep(1,5),rep(0,5),
     rep(1,6),rep(0,9),rep(1,4),rep(0,5),
     rep(1,6),rep(0,9),rep(1,5),rep(0,4),
     rep(1,6),rep(0,10),rep(1,4),rep(0,4),
     rep(1,6),rep(0,10),rep(1,5),rep(0,3),
     rep(1,6),rep(0,11),rep(1,5),rep(0,2),
     rep(1,6),rep(0,11),rep(1,6),rep(0,1),
     rep(1,6),rep(0,12),rep(1,6))

# Create x and y coordinates for plotting letter R
# Goal is to split the letter R into a 3x3 grid

# here the x and y coordiates are created for each panel of 3x3 grid
Rx=rep(seq(1,8),24*3)
Ry=rep(rep(seq(8,1),each=24),3)
# xpanel label and yplanel label is attached to enable faceting
Rgrpx=rep(rep(seq(1,3),each=8),24)
Rgrpy=rep(seq(1,3),each=24*8)
# data for plotting letter R is gathered into a data frame
df=data.frame(R=R,Rx=Rx,Ry=Ry,Rgrpx=Rgrpx,Rgrpy=Rgrpy)
# rows with R=0 are not part of the plot
df=subset(df,R==1)
# test of graph with just points
#ggplot(data=df,aes(x=Rx,y=Ry))+geom_point(size=4)+facet_grid(Rgrpy~Rgrpx)

#---------------Finding top downloaded CRAN packages during 3 months (Feb-Apr 2014)-----------------------
# This piece of code is from http://www.nicebread.de/finally-tracking-cran-packages-downloads/  

## ======================================================================
## Step 1: Download all log files
## ======================================================================

# Here's an easy way to get all the URLs in R
start <- as.Date('2014-02-01')
today <- as.Date('2014-04-30')

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

# delete the CRANlogs directory
unlink("CRANlogs",recursive=TRUE)

# find number of downloads of packages
library(dplyr)
pkgcount=dat%>%group_by(package)%>%summarize(downloads=n())%>%arrange(desc(downloads))
# check top 25
#head(pkgcount,25)

#---------------plot letter R with top downloaded package names instead of points-----------------

# number of points in R letter
numptsR=nrow(df)

# The current R letter plot has 342 points
# Extract top 342 downloaded packages
pkgcountTop=pkgcount[1:numptsR,]

# Add info on top packages to dataframe with R letter coordindates
df$package=pkgcountTop$package
df$pkgcount=pkgcountTop$count
df$colornum=seq(1,numptsR) # here just a rank ordering is used for coloring

ggplot(data=df,aes(x=Rx,y=Ry))+
  geom_text(aes(label=package,angle=30,color=as.numeric(colornum)),size=1.5,fontface="bold")+
  facet_grid(Rgrpy~Rgrpx)+
  theme(axis.ticks=element_blank(),axis.text=element_blank(),strip.text=element_blank(),
        strip.background=element_blank(),legend.position="none")+
  xlab("")+ylab("")+scale_color_gradient2(low="blue",mid="green",high="red",midpoint=floor(numptsR/2))+
  ggtitle("useR!2014")+theme(plot.title=element_text(face="bold.italic",size=10))

ggsave("user2014_tShirt_entry.jpg",width=4,height=4)
