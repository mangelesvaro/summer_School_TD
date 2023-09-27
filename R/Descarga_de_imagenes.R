# Instalación del paquete sf (simple features) que permite el acceso a datos geograficos
#install.packages("sf")
# Activación del paquete una vez descargado
library(sf)

# Instalación del paquete devtools que permite la descarga del paquete en desarrollo siguiente
#install.packages("devtools")
# Activación del paquete anterior
library(devtools)

# Instalación del paquete getSpatialData que permite la descarga de imágenes espaciales
#devtools::install_github("16EAGLE/getSpatialData")
# Activación del paquete anterior
library(getSpatialData)

#Leer los límites de la zona de estudio donde se produjo el incendio
library(sf)
Limites.AOI<-st_read("C:/DESCARGA/Limites_AOI.shp") #Adaptar a la ruta donde se han descargado los archivos shapefile Limites_AOI

# Definir los límites como nuestra zona de interés o area of interest (AOI):
library(getSpatialData)
set_aoi(Limites.AOI$geometry)

# Visualizar la zona
view_aoi()

# Login en la plataforma USGS
login_USGS(username = "xxxxxx")

# Productos de imágenes satelitales disponibles a través de getSpatialData
get_products()

# Centrándonos en los productos de Landsat
getLandsat_products()

# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-03-01", "1993-04-01"), 
                               products = "landsat_tm_c2_l2")

# Visualizar resultados de la búsqueda
View(imagenes)

# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)

# Establacer el direcorio de descarga
set_archive("C:/DESCARGA")  #Adaptar

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])

# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])

# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/",
             (imagenes$record_id[2]),".tar")

# ADVERTENCIA: ANTES DE EJECUTAR EL SIGUIENTE PASO SE DEBE HABER INICIADO SESIÓN EN LA PLATAFORMA EARTHEXPLORER DENTRO DEL NAVEGADOR DE INTERNET. 
# Descarga
browseURL(url_)  

# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-09-01", "1993-10-30"), 
                               products = "landsat_tm_c2_l2")

# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)

# Establacer el direcorio de descarga
set_archive("C:/DESCARGA") #Adaptar

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])

# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])

# Visualizar la vista previa de la tercera imagen
plot_previews(imagenes[3,])

# Visualizar la vista previa de la cuarta imagen
plot_previews(imagenes[4,])

# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/",
             (imagenes$record_id[4]),".tar")

# Descarga
browseURL(url_) 

