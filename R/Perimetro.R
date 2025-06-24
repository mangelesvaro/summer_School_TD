#Introducir los indices NBR guardados anteriormente
NBR_pre<-raster("C:/DESCARGA/Indices_vegetacion/NBR_pre.tif")   #Adaptar la ruta donde se ha guardado el índice
NBR_post<-raster("C:/DESCARGA/Indices_vegetacion/NBR_post.tif") #Adaptar la ruta donde se ha guardado el índice

dNBR <- (NBR_pre) - (NBR_post)

plot(dNBR, main="dNBR")

# En RStudio Cloud cargamos los datos de la tabla anterior. Así se establece el rango de valores para umbralizar la información contenida en dNBR

NBR_rangos <- c(-Inf, -.50, 1, #Severidad alta
                -.50, -.25, 2, #Severidad moderada
                -.25, -.10, 3, #Severidad baja 
                -.10,  .10, 4, #No quemado
                .10,  .27, 5, #Bajo rebrote posterior al fuego 
                .27,  .66, 6, #Alto rebrote posterior al fuego
                .66, +Inf, 7) #Muy alto rebrote posterior al fuego

# Convierte los valores de rangos en matriz
class.matrix <- matrix(NBR_rangos, ncol = 3, byrow = TRUE)


# Umbralización 
dNBR_umb <- reclassify(dNBR, NBR_rangos,  right=NA)

# Crea el texto que se introducirá en la leyenda
leyenda=c("Severidad alta",
          "Severidad moderada",
          "Severidad baja",
          "No quemado",
          "Bajo rebrote posterior al fuego",
          "Alto rebrote posterior al fuego",
          "Muy alto rebrote posterior al fuego")

# Establecer los colores del mapa de severidad
mis_colores=c("purple",        #Severidad alta
              "red",           #Severidad moderada
              "orange2",       #Severidad baja 
              "yellow2",       #No quemado
              "limegreen",     #Bajo rebrote posterior al fuego 
              "green",         #Alto rebrote posterior al fuego
              "darkolivegreen")#Muy alto rebrote posterior al fuego

# Visualizar el mapa con ejes
plot(dNBR_umb, col = mis_colores,
     main = 'dNBR umbralizado')

# Visualizar el mapa sin ejes y con la leyenda creada
plot(dNBR_umb, col = mis_colores,legend=FALSE,box=FALSE,axes=FALSE,
     main = 'Severidad del incendio')
legend("topright", inset=0.05, legend =rev(leyenda), fill = rev(mis_colores), cex=0.5) 

#Reclasificar NDVI para generar máscara
mascara.NDVI <- reclassify(NDVI_pre,
                           c(-Inf,0.2,NA, 0.21,Inf,1))

#Visualizar el resultado
plot(mascara.NDVI,col="red",legend=FALSE, main="Máscara vegetación activa")

#Aplicar la máscara al índice dNBR umbralizado
dNBR.mascara.1<-mask(dNBR_umb,mascara.NDVI)

#Visualizar el resultado
plot(dNBR.mascara.1,col = mis_colores, main = 'Severidad del incendio en zonas con vegetación', legend=FALSE)
legend("topright", inset=0.05, legend =rev(leyenda), fill = rev(mis_colores), cex=0.5) 

Clas_RF<-raster('C:/DESCARGA/Clas_RF.tif')       #Adaptar la ruta donde se ha guardado la imagen de la clasificación

leyenda.clas=c("1. Forestal",
               "2. Matorral",
               "3. Cultivos",
               "4. Otros")

mis_colores2 <- viridis::viridis(4)

plot(Clas.RF$map,col=mis_colores2,legend=FALSE, main="Clasificación supervisada RF")
legend("topright",inset=0.03, cex=0.65, y.intersp = 1.2, x.intersp = 1.2,
       legend=leyenda.clas, fill=mis_colores2, title="Leyenda")

#Reclasificar clasificación para generar máscara
mascara.Clas.RF <- reclassify(Clas.RF$map,
                              c(-Inf,2,1, 2.1,Inf,NA))

#Visualizar el resultado
plot(mascara.Clas.RF,col="red",legend=FALSE, main="Máscara por tipos de vegetación")

#Aplicar la máscara al índice dNBR umbralizado y ya enmascarado por vegetación activa
dNBR.mascara.2<-mask(dNBR.mascara.1,mascara.Clas.RF)

#Visualizar el resultado
plot(dNBR.mascara.2,col = mis_colores, legend=FALSE, main="Severidad del incendio en el área forestal")
legend("topright", inset=0.05, legend =rev(leyenda), fill = rev(mis_colores), cex=0.5) 

writeRaster(dNBR.mascara.2,
            filename="C:/DESCARGA/dNBR.mascara.2.tif",        #Adaptar la ruta donde se va a guardar el archivo
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S', # guarda en valores decimales
            overwrite=TRUE) 

#Selección de píxeles con valores 1, 2 y 3
dNBR.mascara.2[dNBR.mascara.2>3]<-NA

#Poligonización
library(stars)
perimetro <- as_Spatial(st_as_sf(st_as_stars(dNBR.mascara.2),
                                 as_points = FALSE, merge = TRUE)) 

#Comprobación de la validez de las geometrías resultantes
rgeos::gIsValid(perimetro)

#Eliminación de cruces y auto-intersecciones
perimetro <- rgeos::gBuffer(perimetro, byid = TRUE, width = 0)

#Comprobación de la validez de las geometrías resultantes
rgeos::gIsValid(perimetro)

library(sf)

#Convierte el objeto en un sf (Simple Feature) que puede identificar la librería
perimetro<-st_as_sf(perimetro)

#Disuelve todas las geometrías en una sola
perimetro<-st_union(perimetro)

#Separa cada polígono según su geometría
perimetro<-st_cast(perimetro,"POLYGON",do_split=TRUE)

#Convierte el objeto en un sf que puede identificar la librería
perimetro<-st_as_sf(perimetro)

#Calcula la superficie de cada geometría. Al dividirse entre 10.000, las unidades empleadas son hectáreas
perimetro$supf_ha<-as.numeric(st_area(perimetro)/10000)

#Seleccionar los polígonos de mayor superficie
perimetro_<-perimetro[which(perimetro$supf_ha>1000),]

#Buffer de 50 m los polígonos de mayor superficie
perimetro.buffer<-st_buffer(perimetro_,50)

#Lista de polígonos que intersectan
interseccion<-st_intersects(perimetro.buffer,perimetro)

#Convertir a vector la lista de polígonos que intersectan
interseccion<-unlist(interseccion,recursive =FALSE)

#Seleccionar los valores únicos de los polígonos que intersectan
interseccion<-unique(interseccion)

#Selección de polígonos que intersectan
perimetro.def<-perimetro[interseccion,]

#Guardar capa del perímetro del incendio
st_write(perimetro.def, "C:/DESCARGA/perimetro.shp") #Adaptar la ruta donde se va a guardar el archivo

#Enmascara la imagen por la extensión del shapefile
dNBR_umb_peri <- mask(dNBR_umb,perimetro.def)

#Recorta la imagen por la extensión del shapefile
dNBR_umb_recort <- crop(dNBR_umb_peri,perimetro.def)
dNBR_umb_recort

#Selección de píxeles con valores 1, 2 y 3
dNBR_umb_recort[dNBR_umb_recort>3]<-NA

#Seleccionamos los colores de las clases quemadas
mis_colores3=c("orange2","red","purple")

#Se llama a la librería para la creación de mapas interactivos
library(mapview)

#Caracterización del ráster como de valores discretos
dNBR_umb_recort <- ratify(dNBR_umb_recort)

#Mapa
mapview(dNBR_umb_recort,col.regions=rev(mis_colores3))

#Gráfico de distribución de grados de severidad del incendio
barplot(dNBR_umb_recort,
        main = "Distribución de valores dNBR",
        col = rev(mis_colores3),
        names.arg = c("A","B","C"),las=0)
legend("topright",
       legend=c("A = Severidad alta","B = Sev moderada","C = Severidad baja"),
       fill=rev(mis_colores3), cex=0.65, y.intersp = 1.2, x.intersp = 1.2)

#Extrae los valores del ráster del polígono
valores<-getValues(dNBR_umb_recort)

#Ahora añadimos la superficie que supone cada nivel de severidad

#Tabla con el número de píxeles de cada uno de los valores
table(valores)

#Se selecciona cada valor para construir un vector que los contenga
pix_3 <- length(subset(valores, valores == 3))
pix_2 <- length(subset(valores, valores == 2))
pix_1 <- length(subset(valores, valores == 1))

valores_pixel <- c(pix_3,pix_2,pix_1)

#Se puede comprobar que la resolución espacial del ráster corresponde a 30x30m,
#lo que equivale a 900m2 o 0.09 hectareas
#Comprobación de la resolución espacial del raster
res(dNBR_umb_recort)

#Transformación del número de píxeles en superficie redondeado a 3 dígitos
valores_area<-round(valores_pixel*30*30/10000,digit=3)

#Gráfico de distribución de grados de severidad del incendio
bp<-barplot(dNBR_umb_recort,
            main = "Distribución de valores dNBR y su superficie en Ha",
            col = rev(mis_colores3),
            names.arg = c("A","B","C"),las=0)
legend("topright",
       legend=c("A = Severidad alta","B = Sev moderada","C = Severidad baja"),
       fill=rev(mis_colores3),cex=0.65,y.intersp = 1.2,x.intersp = 1.2)
text(bp, y=2500, labels=rev(valores_area))
