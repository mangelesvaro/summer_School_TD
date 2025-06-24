#Se carga la imagen guardada en los pasos anteriores
img_preincendio<-stack('C:/DESCARGA/img_preincendio.tif') #Adaptar la ruta donde se ha guardado la imagen

#Semilla que permite la repetibilidad de la muestra seleccionada al azar
set.seed(1)

#Selección de muestra aleatoria con un tamaño de 10.000 píxeles de la imagen
sr <- sampleRandom(img_preincendio, 10000)

#Visualización de la relación entre la banda verde y la banda azul de la imagen a partir de la muestra seleccionada
plot(sr[,c(1,2)], main = "Relaciones entre bandas")
mtext("Azul vs Verde", side = 3, line = 0.5)

#Coeficiente de correlación entre las bandas verde y azul a partir de la muestra seleccionada
cor(sr[,1],sr[,2])

#Visualización de la relación entre la banda rojo y la banda infrarrojo cercano de la imagen a partir de la muestra seleccionada
plot(sr[,c(5,3)], main = "Relaciones entre bandas")
mtext("NIR vs Rojo", side = 3, line = 0.5)

#Coeficiente de correlación entre las bandas rojo e infrarrojo a partir de la muestra seleccionada
cor(sr[,5],sr[,3])

#Cálculo del índice NDVI a partir de las bandas
NDVI_pre<-(b4-b3)/(b4+b3)

#Impresión de resultado
NDVI_pre

#Histograma de valores de la imagen del índice NDVI
hist(NDVI_pre)

#Visualización del índice NDVI
plot(NDVI_pre)

#Umbralización del índice NDVI
tipos.veg <- reclassify(NDVI_pre, 
                        c(-Inf,0.2,1, 0.2,0.4,2, 0.4,0.5,3, 0.5,Inf,4))

#Visualización de los resultados de la umbralización
plot(tipos.veg,col = rev(terrain.colors(4)),
     main = 'NDVI umbralizado')

#Gráfico de distribución de tipos de vegetación
barplot(tipos.veg,
        main = "Distribución de tipos de vegetación según NDVI",
        col = rev(terrain.colors(4)), cex.names=0.7,
        names.arg = c("Sin vegetación", 
                      "Vegetación \n escasa \n o enferma", 
                      "Vegetación \n moderada", 
                      "Vegetación \n densa \n o sana"))

#Crear una función para calcular un índice de vegetación
VI <- function(img, i, j) {
  bi <- img[[i]]
  bj <- img[[j]]
  vi <- (bi - bj) / (bi + bj)
  return(vi)
}

#Crear un índice de vegetación a través de una función
NBR_pre <- VI(img_preincendio, 6, 4)

#Visualización del resultado
plot(NBR_pre,
     main = "NBR Pre-Incendio",
     axes = FALSE, box = FALSE)

writeRaster(NDVI_pre,
            filename="C:/DESCARGA/Indices_vegetacion/NDVI_pre.tif", #Adaptar la ruta donde se va a guardar el índice
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

writeRaster(NBR_pre,
            filename="C:/DESCARGA/Indices_vegetacion/NBR_pre.tif", #Adaptar la ruta donde se va a guardar el índice
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales


#Se carga la imagen guardada en los pasos anteriores
img_postincendio<-stack('C:/DESCARGA/img_postincendio.tif') #Adaptar la ruta donde se ha guardado la imagen

#Crear un índice de vegetación a través de una función
NBR_post <- VI(img_postincendio, 6, 4)

#Guardar índice NBR postincendio
writeRaster(NBR_post,
            filename="C:/DESCARGA/Indices_vegetacion/NBR_post.tif", #Adaptar la ruta donde se va a guardar el índice
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales