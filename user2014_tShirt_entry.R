
library(ggplot2)

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

Ry=rep(seq(24,1),each=24)
Rx=rep(seq(1,24),24)

df=data.frame(R=R,Rx=Rx,Ry=Ry)
df=subset(df,R==1)
plot(df$Rx,df$Ry,pch=19)

ggplot(df)+geom_text(aes(x=Rx,y=Ry,label="ggplot2"),size=3)

Rx2=rep(seq(1,8),24*3)
Ry2=rep(rep(seq(8,1),each=24),3)
Rgrpx=rep(rep(seq(1,3),each=8),24)
Rgrpy=rep(seq(1,3),each=24*8)
df2=data.frame(R=R,Rx2=Rx2,Ry2=Ry2,Rgrpx=Rgrpx,Rgrpy=Rgrpy)
df2=subset(df2,R==1)
ggplot(data=df2,aes(x=Rx2,y=Ry2))+geom_point(size=4)+facet_grid(Rgrpy~Rgrpx)
