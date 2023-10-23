[![DOI](https://zenodo.org/badge/694532533.svg)](https://zenodo.org/badge/latestdoi/694532533)

Mª Ángeles Varo Martínez y Rafael Mª Navarro Cerrillo

# Capitulo7-Sensores_Teledeteccion
## 1. DESCARGAR R Y RSTUDIO

RStudio Cloud es una versión en la nube del entorno de desarollo integrado para R y RStudio que no necesita instalación. RStudio Cloud se creó con el objetivo de facilitar a los profesionales y estudiantes la práctica, el intercambio y el aprendizaje de la ciencia de datos.  

![](./Auxiliares/R_Studio_Cloud.png)

RStudio Desktop es una aplicación de escritorio independiente de código abierto, que incluye una consola, un editor de sintaxis de lenguaje R, que admite ejecución directa de código, así como herramientas para gráficos y gestión del espacio del trabajo. Trabaja con la versión de R que tengas instalada en tu estación de trabajo local de Windows, Mac OS X o Linux.  

![](./Auxiliares/RStudio.png) 

En los últimos tiempos, las nubes públicas han experimentado un rápido crecimiento a medida que las empresas se esfuerzan por virtualizar la mayor cantidad posible de sus operaciones, incluido el almacenamiento y análisis de datos. Lo más probable es que esta tendencia continue.

### 1.1. Instalar R y RStudio Desktop en local

#### 1.1.1. Instalar R

Para poder ejecutar códigos de R, primero es necesario instalar el software R que el sistema operativo de tu máquina necesite.

![](./Auxiliares/Rdownload.png) 

[Enlace de descarga](https://cran.r-project.org/bin/windows/base/)

Siempre es recomendable instalar la última versión disponible de R. Se pueden tener instaladas varias versiones de R en el mismo PC. Por tanto, no es necesario desinstalar una versión anterior antes de instalar una nueva.

#### 1.1.2. Instalar RStudio Desktop

RStudio Desktop es una aplicación como  puede serlo también Microsoft Word, excepto que en lugar de ayudar a escribir textos en español, RStudio ayuda a escribir en R. 

[Se puede descargar RStudio gratis](https://www.rstudio.com/products/rstudio/download/#download). Simplemente selecciona la descarga según tu sistema operativo y sigue las instrucciones de instalación. Una vez que se haya instalado RStudio, se puede abrir como cualquier otro programa en su PC, generalmente haciendo clic en un ícono en el escritorio. 

## 2. ACCESO Y DESCARGA DE IMÁGENES

En el presente ejercicio se va a aprender a gestionar la búsqueda y descarga de datos de imágenes satelitales empleando el lenguaje de R, lo que nos facilitará un posterior procesado de los datos, gracias a su potencia estadística y analítica.  
Por otro lado, existen numerosas fuentes de datos públicos que nos permiten obtener imágenes de satélites de forma gratuitas. Sin embargo, este ejercicio se va a centrar en el portal de datos Earth Explorer del USGS Servicio Geológico de Estados Unidos. 
Como base del ejercicio se estudiará el incendio acaecido entre los días 7 y 10 de agosto de 1993 en la provincia de Granada, afectando a unas 7.000 ha, de las cuales unas 250 ha estaban localizadas en el interior del Parque Natural de la Sierra de Huétor. En ella se quemaron repoblaciones de Pinus pinaster, Pinus halepensis, Pinus laricio y en menor medida con Pinus sylvestris y Populus realizadas en la década de los años 40 del siglo pasado. Tras el incendio, han sido escasas las labores de reforestación desarrolladas en la zona. La más significativa se ejecutó a finales de 1996 y consistió en una siembra aérea de 16 especies de pinos y matorral con muy bajos resultados.  

### 2.1. Registro en la plataforma Earth Explorer del USGS
Un requisito indispensable para la descarga de datos remotes en el registro en el portal de [Earth Explorer](https://earthexplorer.usgs.gov). Aunque en [este video](https://www.youtube.com/watch?v=eAmTxsg6ZYE) se explica cómo hacerlo, os dejamos unas indicaciones que esperamos os sirvan de ayuda. 

Al abrir el portal, la página tendrá un aspecto parecido a éste:  

![](./Auxiliares/Earth_Explorer_.JPG)  

Presionando en **login** en la esquina superir derecha, se accede a la pantalla del sistema de registro EROS, donde es necesario indicar que queremos crear una nueva cuenta (**Create New Account**).  

### 2.2. Búsqueda y selección de las imágenes
 
Se va a emplear la plataforma online de [RStudio Cloud](https://rstudio.cloud/), no es necesaria la descarga de ningún programa. Se trata de una solución ligera basada en la nube que permite a cualquier persona hacer, compartir, enseñar y aprender ciencia de datos en línea. No hay nada que configurar y no se requiere la instalación de ningún hardware. Lo único necesario es un navegador de internet. Para una introducción a la plataforma podeis ver [este video](https://www.youtube.com/watch?v=uK1Va_UWQFc).  

Para hacer un estudio completo del incendio mediante teledetección es recomendable disponer de una imagen de antes de que ocurriera el incendio y otra imagen posterior. De esta manera, comparando las diferencias entre ambas, es posible extraer el perímetro de la zona quemada, así como evaluar la severidad y otras características del mismo. Por ello, el proceso de búsqueda y selección de imágenes se va a repetir para 2 periodos distintos.   

#### 2.2.1 Antes del incendio

Primero, es preciso subir a la nube la capa con los límites de la zona de estudio que se han facilitado a través de la plataforma con el nombre de Limites_AOI. Aunque el archivo está comprimido en formato zip, se deben subir los 4 archivos individuales que describen la capa, los archivos tienen las siguientes extensiones .dbf, .prj, .shp, .shx. Ésto se realiza a través del botón **upload** de la pestaña **Files** en el cuadro inferior derecho. Una vez realizado, se verá así:  
![](.Auxiliares/Upload.JPG) 

Seguidamente, se configura la plataforma para las funciones que se van a emplear.  

```r 
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
```

getSpatialData se encuentra en una etapa inicial de desarrollo. Tiene como objetivo permitir flujos de trabajo homogéneos y reproducibles para consultar, obtener una vista previa, analizar, seleccionar, ordenar y descargar varios tipos de conjuntos de datos espaciales de fuentes abiertas. Permite el acceso genérico a múltiples distribuidores de datos con una sintasis común para 159 productos. Entre otros, getSpatialData admite estos productos: Sentinel-1, Sentinel-2, Sentinel-3, Sentinel-5P, Landsat 8 OLI, Landsat ETM, Landsat TM, Landsat MSS, MODIS (Terra & Aqua) y SRTM DEM. Para ello, getSpatialData facilita el acceso a múltiples servicios implementando clientes a API públicas de ESA Copernicus Open Access Hub, USGS EarthExplorer, USGS EROS ESPA, Amazon Web Services (AWS), NASA DAAC LAADS y NASA CMR search. 
A continuación, se introduce la zona de estudio, se define como los límites de la zona de interés para la búsqueda de imágenes y, finalmente, se visualiza sobre un mapa interactivo:  


```r
#Leer los límites de la zona de estudio donde se produjo el incendio
library(sf)
Limites.AOI<-st_read("C:/DESCARGA/Limites_AOI.shp") #Adaptar a la ruta donde se han descargado los archivos shapefile Limites_AOI

# Definir los límites como nuestra zona de interés o area of interest (AOI):
library(getSpatialData)
set_aoi(Limites.AOI$geometry)

# Visualizar la zona
view_aoi()
```

![](./Auxiliares/AOI.png)

A partir de este punto, es necesario logarse dentro de la plataforma EarthExplorer con las credenciales obtenidas en el paso anterior para poder realizar la búsqueda de imágenes. El valor **"xxxxxx"** es necesario sustituirlo por nuestro usuario.

```r
# Login en la plataforma USGS
login_USGS(username = "xxxxxx")
```

Posteriormente, se introducirá la contraseña asociada en la ventana emergente. 

![](./Auxiliares/Password_.JPG) 

```r
# Productos de imágenes satelitales disponibles a través de getSpatialData
get_products()
```

```r annotate
##   [1] "sentinel-1"            "sentinel-2"            "sentinel-3"           
##   [4] "sentinel-5p"           "sentinel-1_gnss"       "sentinel-2_gnss"      
##   [7] "sentinel-3_gnss"       "landsat_8_c1"          "lsr_landsat_8_c1"     
##  [10] "landsat_ot_c2_l1"      "landsat_ot_c2_l2"      "landsat_etm_c1"       
##  [13] "lsr_landsat_etm_c1"    "landsat_etm_c2_l1"     "landsat_etm_c2_l2"    
##  [16] "landsat_tm_c1"         "lsr_landsat_tm_c1"     "landsat_tm_c2_l1"     
##  [19] "landsat_tm_c2_l2"      "landsat_mss_c1"        "landsat_mss_c2_l1"    
##  [22] "modis_mcd64a1_v6"      "modis_mod09a1_v6"      "modis_mod09cmg_v6"    
##  [25] "modis_mod14_v6"        "modis_mod09ga_v6"      "modis_mod14a1_v6"     
##  [28] "modis_mod09gq_v6"      "modis_mod14a2_v6"      "emodis_global_lst_v6" 
##  [31] "modis_mod09q1_v6"      "modis_modocga_v6"      "modis_myd14_v6"       
##  [34] "emodis"                "modis_modtbga_v6"      "modis_myd14a1_v6"     
##  [37] "emodis_ndvi_v6"        "modis_myd09a1_v6"      "modis_myd14a2_v6"     
##  [40] "emodis_phen_metrics"   "modis_myd09cmg_v6"     "modis_myd09ga_v6"     
##  [43] "modis_myd09gq_v6"      "modis_myd09q1_v6"      "modis_mydocga_v6"     
##  [46] "modis_mydtbga_v6"      "lpcs_modis_mcd12q1"    "lpcs_modis_mcd43a3"   
##  [49] "lpcs_modis_mod09a1"    "lpcs_modis_mod09ga"    "lpcs_modis_mod09gq"   
##  [52] "lpcs_modis_mod09q1"    "lpcs_modis_mod11a1"    "lpcs_modis_mod13a1"   
##  [55] "lpcs_modis_mod13a2"    "lpcs_modis_mod13a3"    "lpcs_modis_mod13q1"   
##  [58] "lpcs_modis_myd09a1"    "lpcs_modis_myd09ga"    "lpcs_modis_myd09gq"   
##  [61] "lpcs_modis_myd09q1"    "lpcs_modis_myd11a1"    "lpcs_modis_myd13a1"   
##  [64] "lpcs_modis_myd13a2"    "lpcs_modis_myd13a3"    "lpcs_modis_myd13q1"   
##  [67] "modis_mcd12c1_v6"      "modis_mcd12q1_v6"      "modis_mcd12q2_v6"     
##  [70] "modis_mcd15a2h_v6"     "modis_mcd15a3h_v6"     "modis_mcd19a1_v6"     
##  [73] "modis_mcd19a2_v6"      "modis_mcd19a3_v6"      "modis_mcd43a1_v6"     
##  [76] "modis_mcd43a2_v6"      "modis_mcd43a3_v6"      "modis_mcd43a4_v6"     
##  [79] "modis_mcd43c1_v6"      "modis_mcd43c2_v6"      "modis_mcd43c3_v6"     
##  [82] "modis_mcd43c4_v6"      "modis_mcd43d01_v6"     "modis_mcd43d02_v6"    
##  [85] "modis_mcd43d03_v6"     "modis_mcd43d04_v6"     "modis_mcd43d05_v6"    
##  [88] "modis_mcd43d06_v6"     "modis_mcd43d07_v6"     "modis_mcd43d08_v6"    
##  [91] "modis_mcd43d09_v6"     "modis_mcd43d10_v6"     "modis_mcd43d11_v6"    
##  [94] "modis_mcd43d12_v6"     "modis_mcd43d13_v6"     "modis_mcd43d14_v6"    
##  [97] "modis_mcd43d15_v6"     "modis_mcd43d16_v6"     "modis_mcd43d17_v6"    
## [100] "modis_mcd43d18_v6"     "modis_mcd43d19_v6"     "modis_mcd43d20_v6"    
## [103] "modis_mcd43d21_v6"     "modis_mcd43d22_v6"     "modis_mcd43d23_v6"    
## [106] "modis_mcd43d24_v6"     "modis_mcd43d25_v6"     "modis_mcd43d26_v6"    
## [109] "modis_mcd43d27_v6"     "modis_mcd43d28_v6"     "modis_mcd43d29_v6"    
## [112] "modis_mcd43d30_v6"     "modis_mcd43d31_v6"     "modis_mcd43d32_v6"    
## [115] "modis_mcd43d33_v6"     "modis_mcd43d34_v6"     "modis_mcd43d35_v6"    
## [118] "modis_mcd43d36_v6"     "modis_mcd43d37_v6"     "modis_mcd43d38_v6"    
## [121] "modis_mcd43d39_v6"     "modis_mcd43d40_v6"     "modis_mcd43d41_v6"    
## [124] "modis_mcd43d42_v6"     "modis_mcd43d43_v6"     "modis_mcd43d44_v6"    
## [127] "modis_mcd43d45_v6"     "modis_mcd43d46_v6"     "modis_mcd43d47_v6"    
## [130] "modis_mcd43d48_v6"     "modis_mcd43d49_v6"     "modis_mcd43d50_v6"    
## [133] "modis_mcd43d51_v6"     "modis_mcd43d52_v6"     "modis_mcd43d53_v6"    
## [136] "modis_mcd43d54_v6"     "modis_mcd43d55_v6"     "modis_mcd43d56_v6"    
## [139] "modis_mcd43d57_v6"     "modis_mcd43d58_v6"     "modis_mcd43d59_v6"    
## [142] "modis_mcd43d60_v6"     "modis_mcd43d61_v6"     "modis_mcd43d62_v6"    
## [145] "modis_mcd43d63_v6"     "modis_mcd43d64_v6"     "modis_mcd43d65_v6"    
## [148] "modis_mcd43d66_v6"     "modis_mcd43d67_v6"     "modis_mcd43d68_v6"    
## [151] "modis_mod11a1_v6"      "modis_mod11a2_v6"      "modis_mod11b1_v6"     
## [154] "modis_mod11b2_v6"      "modis_mod11b3_v6"      "modis_mod11c1_v6"     
## [157] "modis_mod11c2_v6"      "modis_mod11c3_v6"      "modis_mod11_l2_v6"    
## [160] "modis_mod13a1_v6"      "modis_mod13a2_v6"      "modis_mod13a3_v6"     
## [163] "modis_mod13c1_v6"      "modis_mod13c2_v6"      "modis_mod13q1_v6"     
## [166] "modis_mod15a2h_v6"     "modis_mod16a2_v6"      "modis_mod17a2h_v6"    
## [169] "modis_mod44b_v6"       "modis_mod44w_v6"       "modis_myd11a1_v6"     
## [172] "modis_myd11a2_v6"      "modis_myd11b1_v6"      "modis_myd11b2_v6"     
## [175] "modis_myd11b3_v6"      "modis_myd11c1_v6"      "modis_myd11c2_v6"     
## [178] "modis_myd11c3_v6"      "modis_myd11_l2_v6"     "modis_myd13a1_v6"     
## [181] "modis_myd13a2_v6"      "modis_myd13a3_v6"      "modis_myd13c1_v6"     
## [184] "modis_myd13c2_v6"      "modis_myd13q1_v6"      "modis_myd15a2h_v6"    
## [187] "modis_myd16a2_v6"      "modis_myd17a2h_v6"     "modis_myd21a1d_v6"    
## [190] "modis_myd21a1n_v6"     "modis_myd21a2_v6"      "modis_myd21_v6"       
## [193] "srtm_global_3arc_v003" "srtm_global_1arc_v001"
```

```r
# Centrándonos en los productos de Landsat
getLandsat_products()
```

```r annotate
##  [1] "landsat_8_c1"              "lsr_landsat_8_c1"         
##  [3] "landsat_ot_c2_l1"          "landsat_ot_c2_l2"         
##  [5] "landsat_etm_c1"            "lsr_landsat_etm_c1"       
##  [7] "landsat_etm_c2_l1"         "landsat_etm_c2_l2"        
##  [9] "landsat_tm_c1"             "lsr_landsat_tm_c1"        
## [11] "landsat_tm_c2_l1"          "landsat_tm_c2_l2"         
## [13] "landsat_mss_c1"            "landsat_mss_c2_l1"        
## [15] "landsat_ard_tile_c2"       "landsat_ard_tile_files_c2"
```

Se puede comprobar que a través de este sistema se puede acceder a diversos productos de satélites como Sentinel-1, Sentinel-2, Sentinel-3, Sentinel-5P, Landsat 8 OLI, Landsat ETM, Landsat TM, Landsat MSS, MODIS (Terra & Aqua) y SRTM DEM.  

Para entender a qué conjunto de datos se refiere cada producto:  

![](./Auxiliares/Landsat_datasets.JPG) 

[Fuente](https://grass.osgeo.org/grass78/manuals/addons/i.landsat.download.html) 

Ahora se procede a la búsqueda concreta de las imágenes. Se va a emplear el producto **landsat_tm_c2_l2** que se refiere a los datos procedentes de Landsat 5 TM, satélite operativo en el periodo en el que ocurrió el incendio, con nivel de procesamiento 2. Puesto que el siniestro ocurrió en el mes de agosto, es razonable pensar que una imagen de primavera del mismo año podría generar el contraste necesario para el análisis del suceso.  Es por ello que se va a emplear el mes de marzo como rango de búsqueda temporal.

```r
# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-03-01", "1993-04-01"), 
                               products = "landsat_tm_c2_l2")
```

```r annotate
## Searching records for product name 'landsat_tm_c2_l2'...
## Found a total of 20 records.
```

En la esquina superior derecha del proyecto de RStudio, en la pestaña **Environment** se habrá generado una veriable de datos llamada **busqueda** con 18 observaciones y 20 variables. Se puede visualizar con el siguiente comando:  

```r
# Visualizar resultados de la búsqueda
View(imagenes)
```

La tabla con los resultados de la búsqueda continene en nombre de las imágenes (**record_id**), el identificador de esa imagen dentro del repositorio (**entity_id**), la hora de comienzo y fin del escaneado del sensor (**start_time** y **stop_time**), si se trata de un imagen diurna o nocturna (**day_or_night**), fecha de la publicación de los datos (**data_publish**), la huella que cubre la imagen (**footprint**), el path y row del paso del satélite al que corresponde la imagen (**tile_number_horizontal**,  **tile_number_certical** y **tile_id**), dirección web en la que se encuentra alojada la previsualización de la imagen (**preview_url**), tipo de sensor (**sensor_id**), porcentaje de cobertura de nubes de la imagen (**cloudcov_land** y **cloudcov**), nivel de procesado (**level**), colección y categoría(**collection** y **Collection_category**), tipo de productos (**product** y **Product_group**) y fecha de adquisición de los datos (**data_acquisition**).  

Seguidamente, se van a filtrar los resultados por los que se refieren a nivel **l1**.

```r
# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)
```

Tan sólo encontramos 2 imágenes con dichas características con fecha de adquisición del 13 de marzo y de 29 de marzo de 1993.  

Para decidir cuál representa mejor el momento anterior al incendio, es aconsejable  visualizar las vistas previas:  

```r
# Establacer el direcorio de descarga
set_archive("C:/DESCARGA")  #Adaptar

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])
```
![](./Auxiliares/Preview1.png) 

```r
# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])
```

![](./Auxiliares/Preview2.png) 

Al comparar ambas previsualizaciones, queda claro que la segunda imagen es la que contiene los datos más claros de la zona de estudio.  

Finalmente, se pasa a obtener el enlace de descarga de la imagen seleccionada y se adquiere la imagen.

```r
# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/",
             (imagenes$record_id[2]),".tar")

# ADVERTENCIA: ANTES DE EJECUTAR EL SIGUIENTE PASO SE DEBE HABER INICIADO SESIÓN EN LA PLATAFORMA EARTHEXPLORER DENTRO DEL NAVEGADOR DE INTERNET. 
# Descarga
browseURL(url_)  
```

#### 2.2.2 Después del incendio

Se repite el proceso buscando ahora la descarga de la imagen Landsat posterior al incendio más adecuada para el análisis de los datos. Se va a utilizar una extensión temporal mayor en la búsqueda puesto que la estación otoñal podría causar un aumento en la nubosidad de la zona de estudio.

```r
# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-09-01", "1993-10-30"), 
                               products = "landsat_tm_c2_l2")
```

```r
# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)
```

```r
# Establacer el direcorio de descarga
set_archive("C:/DESCARGA") #Adaptar

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])
```
![](./Auxiliares/Preview_despues1.png) 

```r
# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])
```
![](./Auxiliares/Preview_despues2.png) 

```r
# Visualizar la vista previa de la tercera imagen
plot_previews(imagenes[3,])
```
![](./Auxiliares/Preview_despues3.png) 

```r
# Visualizar la vista previa de la cuarta imagen
plot_previews(imagenes[4,])
```
![](./Auxiliares/Preview_despues4.png) 

```r
# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/",
             (imagenes$record_id[4]),".tar")

# Descarga
browseURL(url_)  
```

