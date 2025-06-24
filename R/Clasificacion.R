#Abrir archivo con los datos de referencia
library(sf)
library(mapview)

Referencia<-st_read("C:/DESCARGA/clasificacion.shp") #Adaptar a la ruta donde se ha descargado el fichero

mapview(Referencia,zcol="CLASE")

#Generar semilla para asegurar la repetitividad del ejercicio
set.seed(1)

#Generar puntos al azar de los polígonos de 100 puntos
puntos.ref <- st_sample(Referencia, c(25,25,25,25), type='random',exact=TRUE)

puntos.ref<-st_sf(puntos.ref)

puntos.ref<-st_join(puntos.ref,Referencia)

mapview(Referencia,zcol="CLASE")+mapview(puntos.ref,alpha=0)

#Se carga la imagen guardada en los pasos anteriores
img_preincendio<-stack('C:/DESCARGA/img_preincendio.tif') #Adaptar la ruta donde se ha guardado la imagen

#Extraer las coordenadas de la muestra de puntos seleccionada al azar
xy <- st_coordinates(puntos.ref)

#Extraer los valores de los pixeles
valores.pixeles <- extract(img_preincendio, xy)

#Convertirlo en una tabla
valores.pixeles<-as.data.frame(valores.pixeles)

names(valores.pixeles)

#Cambiar el nombre de los campos para que hagan referencia clara a la banda a la que pertenecen
names(valores.pixeles)<-c("B1","B2","B3","B4","B5","B7")

head(valores.pixeles)

#Añadir el valor del campo CLASE de los poligonos de referencia
for(i in seq(nrow(puntos.ref))){
  valores.pixeles$clase[i]<-puntos.ref$CLASE[i]
}

#Numero de pixeles pertenecientes a cada clase
table(valores.pixeles$clase)

#Calculo de reflectancia media por clase
perfiles<-aggregate(valores.pixeles[,c(1:6)],list(valores.pixeles$clase),mean)

miscolores <- c("blue","red", "darkgreen","yellow3","black")

perfiles<-as.matrix(perfiles)
rownames(perfiles)<-perfiles[,1]

perfiles<-perfiles[,-1]

#Grafico
plot(0, ylim=c(0,0.3), xlim = c(1,6), type='n', xlab="Bands", 
     ylab = "Reflectance",xaxt="n")
axis(1,at=1:6, labels=c("B1","B2","B3","B4","B5","B7"))
for (i in 1:nrow(perfiles)){
  lines(perfiles[i,], type = "l", lwd = 3, lty = 1, col = miscolores[i])
}
#Titulo del grafico
title(main="Perfiles espectrales Landsat")
#Leyenda
legend("topleft", legend=rownames(perfiles),
       cex=0.75, y.intersp = 0.75, col=miscolores, lty = 1, lwd =3, bty = "n",)

#Histograma de predictores

#install.packages("sm")
library(sm)
par(mfrow=c(2,3))
sm.density.compare(valores.pixeles$B1,valores.pixeles$clase,xlab="B1",
                   col=miscolores)
sm.density.compare(valores.pixeles$B2,valores.pixeles$clase,xlab="B2",
                   col=miscolores)
sm.density.compare(valores.pixeles$B3,valores.pixeles$clase,xlab="B3",
                   col=miscolores)
sm.density.compare(valores.pixeles$B4,valores.pixeles$clase,xlab="B4",
                   col=miscolores)
sm.density.compare(valores.pixeles$B5,valores.pixeles$clase,xlab="B5",
                   col=miscolores)
sm.density.compare(valores.pixeles$B7,valores.pixeles$clase,xlab="B7",
                   col=miscolores)
par(mfrow=c(1,1))

#Clasificacion por el modelo de maxima probabilidad
library(RStoolbox)
puntos.ref<-as_Spatial(puntos.ref)

Clas.Max.Prob<- superClass(img_preincendio, trainData = puntos.ref, 
                           trainPartition =0.70, responseCol = "CLASE",
                           model = "mlc", tuneLength = 1)

miscolores2 <- viridis::viridis(4)

plot(Clas.Max.Prob$map,col=miscolores2,legend = FALSE)
legend("topright",cex=0.65, y.intersp = 0.55,x.intersp = 0.5,
       legend = levels(as.factor(puntos.ref$CLASE)), 
       fill = miscolores2 ,title = "",
       inset=c(0,0))

#Clasificacion por Random Forest
library(randomForest)
Clas.RF<- superClass(img_preincendio, trainData = puntos.ref, 
                     trainPartition =0.70, responseCol = "CLASE",
                     model = "rf", tuneLength = 1)

plot(Clas.RF$map,col=miscolores2,legend = FALSE)
legend("topright",cex=0.65, y.intersp = 0.55,x.intersp = 0.5,
       legend = levels(as.factor(puntos.ref$CLASE)), 
       fill = miscolores2 ,title = "",
       inset=c(0,0))

#Guarda la imagen de la clasificación supervisada por máxima probabilidad
writeRaster(Clas.Max.Prob$map,
            filename="C:/DESCARGA/Clas_Max_Prob.tif",            #Adaptar la ruta donde se va a guardar la clasificación
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

#Guarda la imagen de la clasificación supervisada por Random Forest
writeRaster(Clas.RF$map,
            filename="C:/DESCARGA/Clas_RF.tif",                  #Adaptar la ruta donde se va a guardar la clasificación
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

#Guardar objetos de R
save(Clas.Max.Prob,Clas.RF,file="C:/DESCARGA/Clasificaciones_supervisadas.RData")  #Adaptar la ruta donde se va a guardar la clasificación

#Se carga los datos de las clasificaciones
load("C:/DESCARGA/Clasificaciones_supervisadas.RData")  #Adaptar la ruta donde se ha guardado la clasificación

#Resultados de precisión de la clasificación por máxima probabilidad en la muestra de entrenamiento
#[[1]] contiene la media de las medidas de precisión
#[[2]] contiene la matriz de confusión media de las iteraciones
Clas.Max.Prob$modelFit

#Detalle de los resultados con valores medios y desviaciones estandar de las medidas de precisión
Clas.Max.Prob$model$results

#Detalle de los resultados con las medidas de precisión de cada iteración
Clas.Max.Prob$model$resample

#Resultados generales de precisión de la clasificación por máxima probabilidad en la muestra de evaluación
Clas.Max.Prob$validation$performance$overall

#Matriz de confusión en la muestra de evaluación
Clas.Max.Prob$validation$performance$table

#Resultados de precisión de la clasificación por el método de Random Forest
#[[1]] contiene la media de las medidas de precisión
#[[2]] contiene la matriz de confusión media de las iteraciones
Clas.RF$modelFit

#Detalle de los resultados con valores medios y desviaciones estandar de las medidas de precisión
Clas.RF$model$results

#Detalle de los resultados con las medidas de precisión de cada iteración
Clas.RF$model$resample

#Resultados generales de precisión de la clasificación por el método de Random Fforest en la muestra de evaluación
Clas.RF$validation$performance$overall

#Matriz de confusión en la muestra de evaluación
Clas.RF$validation$performance$table

