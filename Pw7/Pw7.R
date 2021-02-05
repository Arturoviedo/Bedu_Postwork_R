#Pw7

library(mongolite)

# 1.-
# Leyendo dataset
match <- read.csv("C:/Users/cruov/OneDrive - Instituto Politecnico Nacional/Cursos/Santander/Etapa 2/Bedu_Postwork_R/Pw7/data.csv")

# Alojando dataset en mongodb
colection <- mongo(collection = "match", db = "match_games")
colection$insert(match)

#2.-
# Realizando count para conocer numero de registros
colection$count()
colection$find()

# 3.-
# Realizando consulta de goles que metio Real Madrid el 20 de diciembre de 2015
colection$find('{"date":"2015-12-20", "HomeTeam":"Real Madrid"}')
# Sin embargo, no hay partidos del anno 2015 en el dataset

# 4.-
# cerrando conexion
rm(colection)
