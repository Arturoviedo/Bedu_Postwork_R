PW2
#1.- Importamos datos
url1 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url2 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url3 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
data1 <- read.csv(file = url1) 
data2 <- read.csv(file = url2)
data3 <- read.csv(file = url3)
#2.- Características de los data frames
str(data1); str(data2); str(data3)
head(data1); head(data2); head(data3)
View(data1); View(data2); View(data3)
summary(data1); summary(data2); summary(data3)
#3.-Seleccionamos las columnas correctas
lista <- list(data1, data2, data3)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
lapply(nlista, str)
#4.- Formato de fecha

nlista[[1]] <- mutate(nlista[[1]], Date = as.Date(Date, "%d/%m/%y"))
nlista[[2]] <- mutate(nlista[[2]], Date = as.Date(Date, "%d/%m/%Y"))
nlista[[3]] <- mutate(nlista[[3]], Date = as.Date(Date, "%d/%m/%Y"))
lapply(nlista, str)

data <- do.call(rbind, nlista)
dim(data)

str(data)
tail(data)
View(data)
summary(data)
