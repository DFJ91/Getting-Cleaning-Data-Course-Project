#Instalo el paquete downloader para descargar y descomprimir el archivo zip

install.packages("downloader")

#Descargo y descomprimo el archivo

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download(fileURL, dest="/Users/DavidFernandez/CleaningDataProject/Project.zip", mode="wb")

unzip("Project.zip", exdir ="/Users/DavidFernandez/CleaningDataProject" )

#Cambio el directorio de trabajo para unir los datos de test

setwd("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/test")

#Cargo los datos en distintas tablas para despues unirlas

library(dplyr)

X_test<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/test/X_test.txt")

y_test<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/test/y_test.txt")

#y_test<-rename(y_test,Activity_Label = V1)

subject_test<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/test/subject_test.txt")

#subject_test<-rename(subject_test,Subject_Number = V1)

#Paso a unir las tres tablas: 1)subject_test, 2)y_test, 3)X_test

Test_results_Test<-cbind(subject_test,y_test,X_test)

#Repito los mismos pasos para los datos correspondientes a train

X_train<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/train/X_train.txt")

y_train<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/train/y_train.txt")

#y_train<-rename(y_test,Activity_Label = V1)

subject_train<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/train/subject_train.txt")

#subject_train<-rename(subject_train,Subject_Number = V1)

#Paso a unir las tres tablas: 1)subject_train, 2)y_train, 3)X_train

Test_results_Train<-cbind(subject_train,y_train,X_train)

#Ahora uno las dos tablas Test_Result_Train y Test_result_Test

run_analysis<-rbind(Test_results_Train,Test_results_Test)

##################### SECOND PART ############################

#Del archivo features.txt identifico las columnas que tienen la palabra mean()
#y std()

features<-read.table("/Users/DavidFernandez/CleaningDataProject/UCI HAR Dataset/features.txt")

Mean_Col<-grep("mean()",features$V2)

#Incluye tambien la frecuencia media; Lo he incluido porque es también
#una medida que se ha tomado. 

Std_Col<-grep("std()",features$V2)

#Creo un vector con 79 posiciones para indicar en el las columnas
#que tengo que conservar

conservar<-rep(0,563)

for(i in 1:563){

        for(j in 1:46){
                if (is.na(match(Mean_Col[j],i))==FALSE) conservar[i]<-i
        }
        
        for(k in 1:33){
                if (is.na(match(Std_Col[k],i))==FALSE) conservar[i]<-i
        }
}

rm(i,j,k)

conservar_v2<-rep(0,79)

j<-1

#Uno en un mismo vector Mean_col y Std_col

for(i in 1:563){
        if(conservar[i]!=0){
                conservar_v2[j]<-conservar[i]
                j<-j+1
        }
}

rm(i,j)

#Al haber añadido dos columnas hay que desplazar los valores 2 veces

conservar_v3<-rep(0,81)
conservar_v3[1]<-1
conservar_v3[2]<-2
for(i in 3:81){
        conservar_v3[i]<-conservar_v2[i-2]+2
}

rm(i)
#Ahora selecciono las columnas que quiero

run_analysis_v2<-subset(run_analysis,select=conservar_v3)

################# Parte 3 ##############################

#Voy a cambiar los numeros por nombre descriptivos para
#la columna 2. Voy a utilizar los mismos nombres que en 
#el txt

for(i in 1:nrow(run_analysis_v2) ){
        if(run_analysis_v2[i,2]==1) run_analysis_v2[i,2]<-"WALKING"
        if(run_analysis_v2[i,2]==2) run_analysis_v2[i,2]<-"WALKING_UPSTAIRS"
        if(run_analysis_v2[i,2]==3) run_analysis_v2[i,2]<-"WALKING_DOWNSTAIRS"
        if(run_analysis_v2[i,2]==4) run_analysis_v2[i,2]<-"SITTING"
        if(run_analysis_v2[i,2]==5) run_analysis_v2[i,2]<-"STANDING"
        if(run_analysis_v2[i,2]==6) run_analysis_v2[i,2]<-"LAYING"
}

################## PARTE 4 ############################

run_analysis_v2<-rename(run_analysis_v2,Subject_Number=V1)

run_analysis_v2<-rename(run_analysis_v2,Activity=V1.1)

#d<-toString(features[1,2])

run_analysis_v2<-rename(run_analysis_v2,tBodyAccmeanX=V1.2)

#rm(i)

#Acondiciono las etiquetas de features.txt
features_v2<-rep(0,nrow(features))
for(i in 1:nrow(features)){
        features_v2[i]<-gsub("-","",features[i,2],fixed = TRUE)
}
for(i in 1:nrow(features)){
        features_v2[i]<-sub("()","",features_v2[i],fixed = TRUE)
}

#Uso las etiquetas del features_v2 para nombrar a las variables
rm(a)
label<-names(run_analysis_v2)
label_v2<-rep("0",79)
for(i in 1:561){
        for(j in 1:79){
                if(conservar_v2[j]==i){
                       
                        label_v2[j]<-features_v2[i]
                }
        }
}

#No se seguro si es necesario:
run_analysis_v2<-tbl_df(run_analysis_v2)

for(i in 2:79){
        a<-i+2
        f<-as.symbol(label_v2[i])
        colnames(run_analysis_v2)[a]<-label_v2[i]
}

##################### Parte 5 ######################
#Creo un nuevo dataset a partir de run_analysis_v2

mean_run_analysis<-run_analysis_v2


#Agrupo las variables sujeto y actividad

mean_run_analysis<-group_by(mean_run_analysis,Subject_Number,Activity)
## Creo 30 tablas donde recojo la información de cada sujeto ##
for(k in 1:30){
mean_run_analysis_v2_k<-filter(mean_run_analysis,Subject_Number==k)

#Walking

mean_run_analysis_k_WALKING<-filter(mean_run_analysis_v2_k,Activity=="WALKING")
mean_Walking_k<-map_dbl(mean_run_analysis_k_WALKING,mean)

#Walking_Upstairs
mean_run_analysis_k_WALKING_UPSTAIRS<-filter(mean_run_analysis_v2_k,Activity=="WALKING_UPSTAIRS")
mean_Walking_Upstairs_k<-map_dbl(mean_run_analysis_k_WALKING_UPSTAIRS,mean)

#Walking_Downstairs
mean_run_analysis_k_WALKING_DOWNSTAIRS<-filter(mean_run_analysis_v2_k,Activity=="WALKING_DOWNSTAIRS")
mean_Walking_Downstairs_k<-map_dbl(mean_run_analysis_k_WALKING_DOWNSTAIRS,mean)

#Sitting
mean_run_analysis_k_SITTING<-filter(mean_run_analysis_v2_k,Activity=="SITTING")
mean_Walking_Sitting_k<-map_dbl(mean_run_analysis_k_SITTING,mean)

#Standing
mean_run_analysis_k_STANDING<-filter(mean_run_analysis_v2_k,Activity=="STANDING")
mean_Walking_STANDING_k<-map_dbl(mean_run_analysis_k_STANDING,mean)

#Laying
mean_run_analysis_k_LAYING<-filter(mean_run_analysis_v2_k,Activity=="LAYING")
mean_Walking_Laying_k<-map_dbl(mean_run_analysis_k_LAYING,mean)

#Creo una matriz para el sujeto 2

Subject_k<-run_analysis_v2

for(i in 1:nrow(Subject_k)){
        for(j in 1:ncol(Subject_k)) Subject_k[i,j]<-0
}


Subject_k[1,2]<-"WALKING"
Subject_k[2,2]<-"WALKING_UPSTAIRS"
Subject_k[3,2]<-"WALKING_DOWNSTAIRS"
Subject_k[4,2]<-"SITTING"
Subject_k[5,2]<-"STANDING"
Subject_k[6,2]<-"LAYING"

for(i in 1:6) Subject_k[i,1]<-k

for(j in 3:81){Subject_k[1,j]<-mean_Walking_k[j]}
rm(j)
for(j in 3:81){Subject_k[2,j]<-mean_Walking_Upstairs_k[j]}
rm(j)
for(j in 3:81){Subject_k[3,j]<-mean_Walking_Downstairs_k[j]}
rm(j)
for(j in 3:81){Subject_k[4,j]<-mean_Walking_Sitting_k[j]}
rm(j)
for(j in 3:81){Subject_k[5,j]<-mean_Walking_STANDING_k[j]}
rm(j)
for(j in 3:81){Subject_k[6,j]<-mean_Walking_Laying_k[j]}

nam<-paste("Subject_",k,sep = "")

assign(nam,filter(Subject_k,Subject_Number!=0))

#Para acceder a cada tabla y comprobar que el bucle 
#evoluciona correctamente

print(nam)
print(get(paste("Subject_",k,sep = "")))
}

#Ahora uno todas las tablas en 1

Final_mean_run_analysis<-rbind(Subject_1,Subject_2)

for (i in 3:30){
        nam2<-paste("Subject_",i,sep = "")
        Final_mean_run_analysis<-rbind(Final_mean_run_analysis,get(nam2))
}

#Finalmente escribo un archivo txt

write.table(Final_mean_run_analysis,file = "Run_analysis_DFJ",row.names = FALSE)



        


