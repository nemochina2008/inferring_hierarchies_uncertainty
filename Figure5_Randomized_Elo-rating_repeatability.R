
# Authors: 
#         Alfredo Sanchez-Tojar, MPIO (Seewiesen) and ICL (Silwood Park), alfredo.tojar@gmail.com
#         Damien Farine, MPIO (Radolfzell) and EGI (Oxford), dfarine@orn.mpg.de

# Script first created on the 27th of October, 2016

###############################################################################
# Description of script and Instructions
###############################################################################

# This script aims to generate a figure that shows how Elo-rating repeatability
# changes depending on the steepness of the hierarchy. Figure 4 for:

# Sanchez-Tojar, A., Schroeder, J., Farine, D.R. (In preparation) A practical 
# guide for inferring reliable dominance hierarchies and estimating their 
# uncertainty

# more info at the Open Science Framework: http://doi.org/10.17605/OSF.IO/9GYEK


###############################################################################
# Packages needed
###############################################################################

# packages needed for this script

library(aniDom)
library(doBy)
library(RColorBrewer)


# Clear memory
rm(list=ls())


###############################################################################
# Functions needed
###############################################################################

plot_winner_prob <- function(diff.rank, a, b,coline) {
  
  diff.rank.norm <- diff.rank/max(diff.rank)
  
  lines(diff.rank, 0.5+0.5/(1+exp(-diff.rank.norm*a+b)),col=coline)
  
}


# ###############################################################################
# # Estimating repeatability
# ###############################################################################
# 
# ptm <- proc.time()
# 
# 
# db <- data.frame(Ninds=integer(),
#                  Nobs=integer(),
#                  poiss=logical(),
#                  dombias=logical(),
#                  alevel=integer(),
#                  blevel=integer(),
#                  rep=numeric(),
#                  stringsAsFactors=FALSE)
# 
# 
# avalues <- c(10,15,10,5)
# bvalues <- c(-5,5,5,5)
# #N.inds.values <- c(10)
# N.inds.values <- c(25)
# #N.inds.values <- c(50)
# N.obs.values <- c(1,4,7,10,15,20,30,40,50,100)
# poiss <- c(FALSE,TRUE)
# dombias <- c(FALSE,FALSE)
# 
# 
# for (typ in 1:length(poiss)){
# 
#   for (j in 1:length(avalues)){
# 
#     for (p in 1:length(N.inds.values)){
# 
#       for (o in 1:length(N.obs.values)){
# 
#         for (sim in 1:100){
# 
#           output <- generate_interactions(N.inds.values[p],
#                                           N.inds.values[p]*N.obs.values[o],
#                                           a=avalues[j],
#                                           b=bvalues[j],
#                                           id.biased=poiss[typ],
#                                           rank.biased=dombias[typ])
# 
# 
#           winner <- output$interactions$Winner
#           loser <- output$interactions$Loser
# 
#           rept <- estimate_uncertainty_by_repeatability(winner,
#                                                         loser,
#                                                         identities=c(1:N.inds.values[p]),
#                                                         init.score=1000,
#                                                         n.rands = 1000)
# 
# 
#           db<-rbind(db,c(N.inds.values[p],N.obs.values[o],
#                          poiss[typ],
#                          dombias[typ],
#                          avalues[j],
#                          bvalues[j],
#                          rept))
# 
#           write.csv(db,
#                     "databases_package/final_data_for_Figures_backup/Fig5_db_repeatabilityANOVA_100_simulations_fixed_biases_50ind_100int_t.csv",row.names=FALSE)
# 
# 
#         }
#       }
#     }
#   }
# }
# 
# 
# names(db) <- c("Ninds","Nobs",
#                "poiss","dombias",
#                "alevel","blevel",
#                "rep")
# 
# 
# proc.time() - ptm
# 
# 
# # write.csv(db,
# #           "databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_10ind.csv",row.names=FALSE)
# 
# write.csv(db,
#           "databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_25ind.csv",row.names=FALSE)
# 
# # write.csv(db,
# #           "databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_50ind.csv",row.names=FALSE)


###############################################################################
# Plotting repeatability and adding 95% CI intervals 
###############################################################################

#db_rep <- read.table("databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_10ind.csv",header=TRUE,sep=",")
db_rep <- read.table("databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_25ind.csv",header=TRUE,sep=",")
#db_rep <- read.table("databases_package/final_data_for_Figures_backup/Fig5_db_repeatability_100_simulations_fixed_biases_newaniDom_50ind.csv",header=TRUE,sep=",")

#db_rep.100 <- read.table("databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_10ind_100int.csv",header=TRUE,sep=",")
db_rep.100 <- read.table("databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_25ind_100int.csv",header=TRUE,sep=",")
#db_rep.100 <- read.table("databases_package/final_data_for_Figures_backup/Fig6_db_repeatability_100_simulations_fixed_biases_newaniDom_50ind_100int.csv",header=TRUE,sep=",")

db_rep <- rbind(db_rep,db_rep.100)

avalues <- c(15,15,15,10,10,10,5,5,5)
bvalues <- c(5,5,5,5,5,5,5,5,5)
#N.inds.values <- c(10)
N.inds.values <- c(25)
#N.inds.values <- c(50)
N.obs.values <- c(1,4,7,10,15,20,30,40,50,100)


db<-db_rep[db_rep$poiss==1 & db_rep$dombias==0,]
#db<-db_rep[db_rep$poiss==0 & db_rep$dombias==0,]


a <- c("(a)","x","x","(b)","x","x","(c)","x","x")


tiff("plots/after_revision/Figure6_randomized_Elo-rating_repeatability_100int_25ind_Poisson.tiff",
     #"plots/supplements/after_revision/FigureS3_Elo-rating_repeatability_100int_25ind_uniform.tiff", 
     #"plots/supplements/after_revision/FigureS05_Elo-rating_repeatability_100int_10ind_Poisson.tiff", 
     #"plots/supplements/after_revision/FigureS12_Elo-rating_repeatability_100int_50ind_Poisson.tiff", 
     height=29.7, width=21,
     units='cm', compression="lzw", res=600)


for (p in 1:length(N.inds.values)){
  
  m <- rbind(c(1,1,1,2),c(1,1,1,3),
             c(4,4,4,5),c(4,4,4,6),
             c(7,7,7,8),c(7,7,7,9))
  
  layout(m)
  
  op <- par(oma = c(6,3,1,1) + 0.1,
            mar = c(0.5,5,1,0) + 0.1,
            cex.lab=2.5)
  
  db.2 <- db[db$Ninds==N.inds.values[p],]
  
  for (i in 1:length(avalues)){
    
    if(i %in% c(1,4,7)){
    
    db.3 <- db.2[db.2$alevel==avalues[i]
                 & db.2$blevel==bvalues[i]
                 ,]
    
    db.4 <-summaryBy(rep ~ Nobs, 
                     data = db.3, 
                     FUN = function(x) { c(m = mean(x),
                                           q = quantile(x,probs=c(0.025,0.975))) })
    
    names(db.4) <- c("Nobs",
                     "rep.m","lower","upper")
    
    print(summary(db.4))
    
    plot(db.4$rep.m~db.4$Nobs,0.5,type="n",
         ylab="",
         xlab="",
         xaxt="n",
         yaxt="n",
         #ylim=c(0.3,1)
         ylim=c(0.2,1))
    
    if(i<7){
      
      axis(1,at=N.obs.values,
           cex.axis=1,tck=0.015,
           labels=FALSE)
      
      
    } else {
      
      axis(1,at=N.obs.values,
           labels=as.character(N.obs.values),
           cex.axis=0.75,tck=0.015)
      
      mtext("    ratio of interactions to individuals",
            side=1, adj=0, line=4, cex=1.8); 
      
    }
    
    axis(2,
         #at=seq(0.3,1,0.1),
         at=seq(0.2,1,0.1),
         cex.axis=0.9,las=2)
    
    
    #adding points for the means and shadowed areas for the 95% CI
    points(db.4$Nobs,db.4$rep.m,type="b",col="blue",pch=19)
    polygon(c(db.4$Nobs,rev(db.4$Nobs)),
            c(db.4$lower,rev(db.4$upper)),
            border=NA,col=rgb(0,0,1, 0.15))
    
    #lines(c(0,101),c(0.7,0.7),col="red",lty=3,lwd=1.5)

    text(98,0.23,a[i],adj = 0 ,cex=1.5)

    
    }else {
      
      if(i %in% c(2,5,8)){
        
        plot(#c(1,50),
             #c(1,10),
             c(1,25),
             c(0.5,1),type="n",
             ylab="", 
             xlab="",
             xaxt="n",
             yaxt="n",
             cex=1.5)
        
        axis(1,
             #at=seq(1,50,6),
             #at=seq(1,10,1),
             at=seq(1,25,4),
             cex.axis=0.75,tck=0.015)
        
        axis(2,at=seq(0.5,1,0.1),cex.axis=0.75,las=2,tck=0.015) 
        
        #plot_winner_prob(1:50,a=avalues[i],b=bvalues[i],"black")
        #plot_winner_prob(1:10,a=avalues[i],b=bvalues[i],"black")
        plot_winner_prob(1:25,a=avalues[i],b=bvalues[i],"black")
        
        mtext("   P (dominant wins)",
              side=2, adj=0, line=3, cex=0.95) 
        
      } else {
        
        plot(c(1,50),c(0,1),type="n",
             ylab="", 
             xlab="",
             xaxt="n",
             yaxt="n",
             frame.plot=FALSE)    
        
        
        atext <- paste("\na = ",avalues[i])
        btext <- paste("\nb = ",bvalues[i])
        ttext <- paste0(atext,btext,sep="\n")
        text(5,0.45,ttext,adj = 0,cex=2.25)
        
                
        mtext("Difference in rank",
              side=3, adj=1, line=-2, cex=0.95); 
        
      }
      
    }
    
  }
  
  
  title(ylab = "Elo-rating repeatability",
        outer = TRUE, line = -1)
  
  par(mfrow=c(1,1))
  
}

dev.off()


# Code for preprint (i.e. previous version of the manuscript)
# ###############################################################################
# # Plotting: SUPPLEMENTARY MATERIAL: steep and flat scenarios
# ###############################################################################
# 
# db_rep <- read.table("databases_package/final_data_for_Figures_backup/Fig5_db_repeatability_100_simulations_fixed_biases_newaniDom.csv",header=TRUE,sep=",")
# #db_rep <- read.table("databases_package/final_data_for_Figures_backup/Fig5_db_repeatability_100_simulations_fixed_biases_newaniDom_10ind.csv",header=TRUE,sep=",")
# 
# 
# avalues <- c(10,10,10,15,15,15,30,30,30,0,0,0)
# bvalues <- c(-5,-5,-5,0,0,0,5,5,5,5,5,5)
# N.inds.values <- c(50)
# #N.inds.values <- c(10)
# N.obs.values <- c(1,4,7,10,15,20,30,40,50)
# 
# 
# #db<-db_rep[db_rep$poiss==1 & db_rep$dombias==0,]
# #db<-db_rep[db_rep$poiss==0 & db_rep$dombias==0,]
# #db<-db_rep[db_rep$poiss==0 & db_rep$dombias==1,]
# db<-db_rep[db_rep$poiss==1 & db_rep$dombias==1,]
# 
# a <- c("(a)","x","x","(b)","x","x","(c)","x","x","(d)","x","x")
# 
# 
# tiff(#"plots/supplements/FigureS2_randomized_Elo-rating_repeatability_steep_and_flat_poisson.tiff",
#      #"plots/supplements/FigureS5_randomized_Elo-rating_repeatability_steep_and_flat_uniform.tiff", 
#      #"plots/supplements/FigureS12_randomized_Elo-rating_repeatability_steep_and_flat_dombias.tiff",
#      "plots/supplements/FigureS19_randomized_Elo-rating_repeatability_steep_and_flat_poiss+dombias.tiff",
#      #"plots/supplements/FigureS9_randomized_Elo-rating_repeatability_steep_and_flat_poisson_10ind.tiff",
#      #"plots/supplements/FigureS11_randomized_Elo-rating_repeatability_steep_and_flat_uniform_10ind.tiff",
#      height=29.7, width=21,
#      units='cm', compression="lzw", res=600)
# 
# 
# for (p in 1:length(N.inds.values)){
#   
#   m <- rbind(c(1,1,2),c(1,1,3),
#              c(4,4,5),c(4,4,6),
#              c(7,7,8),c(7,7,9),
#              c(10,10,11),c(10,10,12))
#   
#   layout(m)
#   
#   op <- par(oma = c(6,3,1,1) + 0.1,
#             mar = c(0.5,5,1,0) + 0.1,
#             cex.lab=2.5)
#   
#   db.2 <- db[db$Ninds==N.inds.values[p],]
#   
#   for (i in 1:length(avalues)){
#     
#     if(i %in% c(1,4,7,10)){
#       
#       db.3 <- db.2[db.2$alevel==avalues[i]
#                    & db.2$blevel==bvalues[i]
#                    ,]
#       
#       db.4 <-summaryBy(rep ~ Nobs, 
#                        data = db.3, 
#                        FUN = function(x) { c(m = mean(x),
#                                              q = quantile(x,probs=c(0.025,0.975))) })
#       
#       names(db.4) <- c("Nobs",
#                        "rep.m","lower","upper")
#       
#       plot(db.4$rep.m~db.4$Nobs,0.5,type="n",
#            ylab="",
#            xlab="",
#            xaxt="n",
#            yaxt="n",
#            ylim=c(0.1,1))
#            #ylim=c(0,1))
#       
#       if(i<10){
#         
#         axis(1,at=N.obs.values,
#              cex.axis=1,tck=0.015,
#              labels=FALSE)
#         
#         
#       } else {
#         
#         axis(1,at=N.obs.values,
#              labels=as.character(N.obs.values),
#              cex.axis=1,tck=0.015)
#         
#         mtext("ratio of interactions to individuals",
#               side=1, adj=0, line=4, cex=1.8); 
#         
#       }
#       
#       axis(2,
#            at=seq(0.1,1,0.1),
#            #at=seq(0,1,0.1),
#            cex.axis=1.2,las=2)
#       
#       
#       #adding points for the means and shadowed areas for the 95% CI
#       points(db.4$Nobs,db.4$rep.m,type="b",col="blue",pch=19)
#       polygon(c(db.4$Nobs,rev(db.4$Nobs)),
#               c(db.4$lower,rev(db.4$upper)),
#               border=NA,col=rgb(0,0,1, 0.15))
#       
#       lines(c(0,51),c(0.7,0.7),col="red",lty=3,lwd=1.5)
#       
#       
#       text(48,0.13,a[i],adj = 0 ,cex=1.5)
#       #text(48,0.03,a[i],adj = 0 ,cex=1.5)
#       
#       
#     }else {
#       
#       if(i %in% c(2,5,8,11)){
#         
#         plot(c(1,50),
#              #c(1,10),
#              c(0.5,1),type="n",
#              ylab="", 
#              xlab="",
#              xaxt="n",
#              yaxt="n",
#              cex=1.5)
#         
#         axis(1,
#              at=seq(0,50,10),
#              #at=seq(0,10,1),
#              cex.axis=1,tck=0.015)
#         
#         axis(2,at=seq(0.5,1,0.1),cex.axis=1.2,las=2,tck=0.015) 
#         
#         plot_winner_prob(1:50,a=avalues[i],b=bvalues[i],"black")
#         #plot_winner_prob(1:10,a=avalues[i],b=bvalues[i],"black")
#         
#         mtext("P (dominant wins)",
#               side=2, adj=0, line=3, cex=0.85); 
#         
#       } else {
#         
#         plot(c(1,50),c(0,1),type="n",
#              ylab="", 
#              xlab="",
#              xaxt="n",
#              yaxt="n",
#              frame.plot=FALSE)    
#         
#         
#         atext <- paste("\na = ",avalues[i])
#         btext <- paste("\nb = ",bvalues[i])
#         ttext <- paste0(atext,btext,sep="\n")
#         text(15,0.35,ttext,adj = 0,cex=2.25)
#         
#         
#         mtext("Difference in rank     ",
#               side=3, adj=1, line=-2, cex=1); 
#         
#       }
#       
#     }
#     
#   }
#   
#   
#   title(ylab = "Elo-rating repeatability",
#         outer = TRUE, line = 0)
#   
#   par(mfrow=c(1,1))
#   
# }
# 
# dev.off()
# 
# 
# # #TESTINGS
# # db.2 <- db[db$Ninds==50,]
# # 
# # db.3 <- db.2[db.2$alevel==10
# #              & db.2$blevel==5
# #              ,]
# # 
# # db.4 <-summaryBy(rep ~ Nobs, 
# #                  data = db.3, 
# #                  FUN = function(x) { c(m = mean(x),
# #                                        q = quantile(x,probs=c(0.025,0.975))) })
# # 
# # names(db.4) <- c("Nobs",
# #                  "rep.m","lower","upper")