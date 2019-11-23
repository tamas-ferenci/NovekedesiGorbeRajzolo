####### FUNCTIONS
# TWO FUNCTIONS

# calcZ(id="id", age="agemons", y=c("height", "weight", "bmi"), sex="sex"=, SD23, data) calculates Z and percentile for weight, height, and bmi using the 2014 WHO charts for Canada. Depending on whether y = "weight", "height", or "bmi", an appropriate Z score will be returned.  SD23=TRUE requests the "WHO adjustment" for extreme Z (skewed weight and bmi only). Columns height, weight, bmi *cannot* be re-named. LMS parameters interpolated across age.

# makeZs(data) takes a dataset data= with columns id, sex, and age and returns the original dataset + bmi +  3 z-scores (SD=TRUE for weight and bmi). Missing anthropometric measures will return NA. At a minimum, you must have id, age, sex, and one anthropometric measure


makeZs<-function(data){
  # to avoid errors from calling calcZ() with missing columns
  if (is.null(data$height)) data$height<-rep(NA, nrow(data))
  if (is.null(data$weight)) data$weight<-rep(NA, nrow(data))
  data$bmi<- round(10000*data$weight/data$height^2,2)
  
  
  
  tmp1<-calcZ(y="weight", SD23=TRUE, data=data)
  tmp11<-tmp1[,c("id","zscore","percentile")];names(tmp11)<-c("id","WZ","Wt%")
  tmp2<-calcZ(y="height", SD23=FALSE, data=data)
  tmp21<-tmp2[,c("id","zscore","percentile")];names(tmp21)<-c("id","HZ","Ht%")
  tmp3<-calcZ(y="bmi", data=data, SD23=FALSE)
  tmp31<-tmp3[,c("id","zscore","percentile")];names(tmp31)<-c("id","BMIZ","BMI%")
  tmp4<-merge(data, tmp11, by="id")
  tmp5<-merge(tmp4, tmp21, by="id")
  tmp6<-merge(tmp5, tmp31, by="id")
  return(tmp6)
}



# calcZ
calcZ<-function(id="id", age="agemons", y, sex="sex", SD23=TRUE, data){
  data1<-data[,c(id, age, sex, y)]; 
  names(data1)<-c("id", "age","sex", "y")
  
  # load LMS tables
  load("lms_bfa_girls.Rdata")
  load("lms_wfa_girls.Rdata"); 
  load("lms_hfa_girls.Rdata"); 
  load("lms_bfa_boys.Rdata")
  load("lms_wfa_boys.Rdata"); 
  load("lms_hfa_boys.Rdata"); 
  
  # switch works only if weight, height, bmi named correctly
  lmsM<-switch(y, "weight"=lms_wfa_boys, "height"=lms_hfa_boys, "bmi"=lms_bfa_boys)
  lmsF<-switch(y, "weight" = lms_wfa_girls, "height"=lms_hfa_girls, "bmi"=lms_bfa_girls)
  
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


############## use FUNCTIONS  #########