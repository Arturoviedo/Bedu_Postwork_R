# 1.- Importar los datos
url <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
datos <- read.csv(file = url)
dim(datos)
# 2.- Extración de número de goles
datos$FTHG
datos$FTAG
# 3.- Probabilidades
?table
(table(datos$FTHG)/dim(datos)[1])*100 

(table(datos$FTAG)/dim(datos)[1])*100 

(table(datos$FTHG, data$FTAG)/dim(datos)[1])*100
