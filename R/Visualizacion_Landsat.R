# Leer cada una de las bandas de la imagen 
# Azul
b1<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B1.TIF') #Adaptar a la ruta de descarga utilizada
# Verde
b2<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B2.TIF') #Adaptar a la ruta de descarga utilizada
# Rojo
b3<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B3.TIF') #Adaptar a la ruta de descarga utilizada
# Infrarrojo cercano 1
b4<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B4.TIF') #Adaptar a la ruta de descarga utilizada
# Infrarrojo cercano 2
b5<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B5.TIF') #Adaptar a la ruta de descarga utilizada
# Infrarrojo lejano
b7<-raster('C:/DESCARGA/LANDSAT_PREFIRE/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B7.TIF') #Adaptar a la ruta de descarga utilizada

# Impresión de variables 
b1

#Leer la zona de estudio donde se produjo el incendio
library(sf)
Limites.AOI<-st_read("C:/DESCARGA/Limites_AOI.shp") #Adaptar a la ruta donde se han descargado los archivos shapefile Limites_AOI

#Extensión de los límites de la zona de estudio.
#Notese que el sistema de coordenadas es geográfico
extent(Limites.AOI)

#Transformación al sistema de coordenadas proyectadas WGS84 UTM 30N de la zona de estudio
Limites.AOI<-st_transform(Limites.AOI,crs = 32630)

#Comprobación de que los límites de la zona de estudio tienen el sistema de coordenadas nuevo
extent(Limites.AOI)

#Recorte de la imagen Landsat por la extensión de la zona de estudio
b1<-crop(b1,extent(Limites.AOI))
b2<-crop(b2,extent(Limites.AOI))
b3<-crop(b3,extent(Limites.AOI))
b4<-crop(b4,extent(Limites.AOI))
b5<-crop(b5,extent(Limites.AOI))
b7<-crop(b7,extent(Limites.AOI))

#Transformacion con factor de escala
b1<-(b1*0.0000275)- 0.2
b2<-(b2*0.0000275)- 0.2
b3<-(b3*0.0000275)- 0.2
b4<-(b4*0.0000275)- 0.2
b5<-(b5*0.0000275)- 0.2
b7<-(b7*0.0000275)- 0.2

# Histograma de valores
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

# Visualización
par(mfrow=c(1,1))
plot(b1, main = "Azul",col = grey.colors(255, start=0, end=1))
plot(b2, main = "Verde",col = grey.colors(255, start=0, end=1))
plot(b3, main = "Rojo", col = grey.colors(255, start=0, end=1))
plot(b4, main = "Infrarrojo cercano 1",col = grey.colors(255, start=0, end=1))
plot(b5, main = "Infrarrojo cercano 2", col = grey.colors(255, start=0, end=1))
plot(b7, main = "Infrarrojo lejano",col = grey.colors(255, start=0, end=1))

#Limitar los valores digitales de los píxeles de la imagen a 1
b1[b1>1]=1
b2[b2>1]=1
b3[b3>1]=1
b4[b4>1]=1
b5[b5>1]=1
b7[b7>1]=1

# Histograma de valores
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

#Unión de bandas rojo-verde-azul en una sola imagen
Color_real<-stack(b3,b2,b1)

#Impresión de resultado
Color_real

#Cambio de nombre a las bandas para manipularlas mejor en procesos posteriores
names(Color_real)<-c("B3","B2","B1")

#Visualización de la imagen
par(mfrow=c(1,1))
plotRGB(Color_real,scale=1)

#Visualización con ajuste del histograma lineal
plotRGB(Color_real,scale=1,stretch='lin')

#Visualización con ajuste del histograma siguiendo una ecualización
plotRGB(Color_real,scale=1,stretch='hist')

#Unión de bandas infrarrojo-rojo-verde en una sola imagen
Falso_color<-stack(b4,b3,b2)

#Visualización de la imagen en falso color
plotRGB(Falso_color,scale=1)

#Visualización de la imagen en falso color con ajuste del histograma lineal
plotRGB(Falso_color,scale=1,stretch='lin')

#Visualización de la imagen en falso color con ajuste del histograma siguiendo una ecualización
plotRGB(Falso_color,scale=1,stretch='hist')

#Unión de bandas espectrales de Landsat en una sola imagen
img_preincendio<-stack(b1,b2,b3,b4,b5,b7)

#Nombres de las bandas
names(img_preincendio)

#Cambiar nombres de las bandas
names(img_preincendio)<-c("B1","B2","B3","B4","B5","B7")

#Comprobación del cambio en los nombres de las bandas
names(img_preincendio)

#Visualización de la imagen con la combinación de bandas 6-5-3
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin')

#Visualización de la imagen con la combinación de bandas 6-5-3 con zoom
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin',
        ext=extent(c(483500,490000,4125000,4130000)))

writeRaster(img_preincendio,
            filename="C:/DESCARGA/Indices_vegetacion/img_preincendio.tif",  #Adaptar la ruta donde se va a guardar la imagen
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales