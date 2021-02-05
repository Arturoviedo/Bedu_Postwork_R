# Pw5

library(dplyr)
library(ggplot2)
library(reshape2)
library(fbRanks)

# Cargamos los datos ####
link1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data_1718 <- read.csv(file = link1718)
link1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data_1819 <- read.csv(file = link1819)
link1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
data_1920 <- read.csv(file = link1920)

# Exploracion de los datos ####
str(data_1718); head(data_1718); View(data_1718); summary(data_1718)
str(data_1819); head(data_1819); View(data_1819); summary(data_1819)
str(data_1920); head(data_1920); View(data_1920); summary(data_1920)

# 1. Creación del dataframe ####
list <- list(data_1718, data_1819, data_1920)
datasets <- lapply(list, select, Date, HomeTeam, FTHG, AwayTeam, FTAG)
datasets[[1]] <- mutate(datasets[[1]], Date = as.Date(Date, "%d/%m/%y"))
datasets[[2]] <- mutate(datasets[[2]], Date = as.Date(Date, "%d/%m/%Y"))
datasets[[3]] <- mutate(datasets[[3]], Date = as.Date(Date, "%d/%m/%Y"))
SmallData <- do.call(rbind, datasets)
SmallData <- SmallData %>% rename(date = Date, home.team = HomeTeam, home.score = FTHG, away.team = AwayTeam, away.score = FTAG )
str(SmallData)

# Cambio de directorio
setwd("C:/Users/cruov/OneDrive - Instituto Politecnico Nacional/Cursos/Santander/Etapa 2/Bedu_Postwork_R/Pw5")
# Guardar el archivo
write.csv(SmallData,'soccer.csv',row.names = FALSE)

# 2. Variables anotaciones y equipos.####
listasoccer <- create.fbRanks.dataframes ('soccer.csv')
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

# 3. Rank Teams ####
fecha <- unique(listasoccer$scores$date)
(n <- length(fecha))
ranking <- rank.teams(anotaciones,equipos,max.date=fecha[n-1], min.date=fecha[1]) 

# 4. ####
#El equipo de casa gana, el equipo visitante gana o el resultado es un empate 
?predict.fbRanks
predict(ranking, date = fecha[n])

