# postwork-04

library(dplyr)
library(ggplot2)
library(boot)

setwd("C:/.../Postwork/Sesion4/data")

#Obteniendo el dataframe del postwork-02
#{

  # Obteniendo los data sets de https://www.football-data.co.uk/spainm.php
  url.19.20 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
  url.18.19 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
  url.17.18 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
  # Descargando los documentos
  download.file(url=url.19.20, destfile="season19-20.csv", mode="wb")
  download.file(url=url.18.19, destfile="season18-19.csv", mode="wb")
  download.file(url=url.17.18, destfile="season17-18.csv", mode="wb")
  # Haciendo una lista que contiene a todos los csv descargados en la carpeta actual.
  data.list <- lapply(dir(), read.csv)
  # Conservando solo las columnas indicadas en los df de la lista.
  data.list <- lapply(data.list, select, Date:FTR)
  # Eliminamos la columna de Time del 3er dataframe, ya que es el unico que contiene dicho dato.
  data.list[[3]]$Time <- NULL
  # Transformando las fechas en Date de srings a objetos Date
  for(i in 1:length(data.list)){
    data.list[[i]] <- mutate(data.list[[i]], Date=as.Date(Date, format="%d/%m/%y"))
  }
  # Uniendo todos los dataframes de la lista en uno sÃ³lo
  data <- do.call(rbind, data.list)
#}
  

### 1 ###

# total de partidos jugados en toda la temporada
n <- dim(data)[1]
# Calculo de probabilidad (marginal) de que un equipo jugando en casa anote x=0,1,...8 goles  
m.prob.home <- table(data$FTHG)/n
# Calculo de probabilidad (marginal) de que un equipo jugando como visitante anote x=0,1,...6 goles  
m.prob.away <- table(data$FTAG)/n
# Calculo de probabilidad (conjunto) de que un equipo visitante anote x=0,1,...6 goles y un equipo anfitrin anote x=0,1,...8 goles
c.prob <- table(data$FTHG, data$FTAG)/n
# Creando la tabla de cocientes:probabilidades conjuntas entre producto de probabilidades margiales.
cocientes <- c.prob/outer(m.prob.home, m.prob.away, '*')
cocientes
heatmap(cocientes)

### 2 ###

# Realizando proceso bootstrap
# Simulamos un año de partidos escogiendo aleatoriamente 380 partidos (380 es lo que tenemos en un anno)
set.seed(1) # Se especifica una semilla para poder repetir los resultados

# Usamos la funcion boot() para obtener varias medias de cocientes
medias <- boot(as.vector(cocientes), function(d,i){mean(d[i])}, 10000)$t

ggplot() +
  geom_histogram(aes(medias), bins = 50) +
  geom_vline(aes(xintercept = mean(medias))) +
  ggtitle("Histograma de distribuci?n de medias muestrales")

mean(medias)#media del histograma

### Conclusion ###
# Se observa que la media es diferente a 1. 
# Por lo tanto, la anotacion de goles de los equipos anfitriones y visitantes no son independientes entre s?.
# Es decir, el numero de goles del anfitrion depende del numero de goles del visitante y viceversa.