# calcZ
calcZ<-function(id="id", age="agemons", y, sex="sex", SD23=TRUE, data, lmsdat ){
  data1<-data[,c(id, age, sex, y)]; 
  names(data1)<-c("id", "age","sex", "y")
  
  # load LMS tables
  # load("lms_bfa_girls.Rdata")
  # load("lms_wfa_girls.Rdata"); 
  # load("lms_hfa_girls.Rdata"); 
  # load("lms_bfa_boys.Rdata")
  # load("lms_wfa_boys.Rdata"); 
  # load("lms_hfa_boys.Rdata"); 
  
  # switch works only if weight, height, bmi named correctly
  lmsM<-switch(y, "weight"=lmsdat$lms_weightfa_boys, "height"=lmsdat$lms_heightfa_boys, "bmi"=lmsdat$lms_bmifa_boys)
  lmsF<-switch(y, "weight" = lmsdat$lms_weightfa_girls, "height"=lmsdat$lms_heightfa_girls, "bmi"=lmsdat$lms_bmifa_girls)
  
  data1$zscore<-NULL # create place holders
  data1$percentile<-NULL # create place holders
  
  #### generic function as usual ########### 
  
  for(i in 1:dim(data1)[1]){
    obsi<-data1[i,];obsi
    if( is.na(obsi$y) | is.na(obsi$age) | is.na(obsi$sex)){data1$zscore[i]<-NA;data1$percentile[i]<-NA;next}
    
    if(obsi$sex %in% c("M","m",1)){lms<-lmsM}  
    if(obsi$sex %in% c("F","f",2)){lms<-lmsF} 
    
    lms_index<-which(lms$Months >  obsi$age)[1];lms_index # > implies min = 2
    
    #interpolation
    lms1<-lms[lms_index-1,];lms1 # < actual age (min index is 1->age = 0 mo)
    l1<-lms1$L;m1<-lms1$M;s1<-lms1$S; c(l1,m1,s1)
    
    lms2<-lms[lms_index,];lms2 # >= actual age
    l2<-lms2$L;m2<-lms2$M;s2<-lms2$S; c(l2,m2,s2)
    
    delta_age<- lms[lms_index,"Months" ] - lms[lms_index-1,"Months" ] # for slope
    diff_age<-obsi$age-lms[lms_index-1,"Months" ] # to adjust with slope
    
    l<- l1 + diff_age*(l2-l1)/delta_age
    m<- m1 + diff_age*(m2-m1)/delta_age
    s<- s1 + diff_age*(s2-s1)/delta_age
    
    zind<-((data1$y[i]/m)^l-1)/(s*l);zind
    sd3pos<-m*(1+s*l*3)^(1/l);sd3pos
    sd3neg<-m*(1+s*l*(-3))^(1/l);sd3neg
    sd2pos<-m*(1+s*l*2)^(1/l);sd2pos
    sd2neg<-m*(1+s*l*(-2))^(1/l);sd2neg
    sd23pos<-sd3pos-sd2pos;sd23pos
    sd23neg<-sd2neg-sd3neg;sd23neg
    
    #check zind for NA, set zalpha, %ile accordintgly
    #check zind for in bounds and 'fudge' accordingly
    zalpha<-round(zind,2);zalpha # if -3 < z < 3
    if(is.na(zind)){
      zalpha<-NA;
      data1$zscore[i]<-NA;
      data1$percentile[i]<-NA
    } else {
      if(zind > 3 & SD23){zalpha<-3+(data1$y[i]-sd3pos)/sd23pos};zalpha
      if(zind < -3 & SD23){zalpha<--3+(data1$y[i]-sd3neg)/sd23neg};zalpha
      data1$zscore[i]<-round(zalpha, 2);data1$zscore[i]
      percentile<-pnorm(zalpha);percentile
      data1$percentile[i]<-100*round(percentile,3);data1$percentile[i]
    } # end if-else fudge
  } #end i loop
  data1} # end calcZ