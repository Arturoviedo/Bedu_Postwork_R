#PostWork 3

library(dplyr)
library(reshape2)
library(ggplot2)

# 1.- Obtenemos el DataFrame de Pw2

url1 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url2 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url3 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
data1 <- read.csv(file = url1) 
data2 <- read.csv(file = url2)
data3 <- read.csv(file = url3)

lista <- list(data1, data2, data3)
nlista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
lapply(nlista, str)

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

#1.- Obtenemos las probabilidades
# La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
(gh <- round(table(data$FTHG)/dim(data)[1], 3)) 
#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
(ga <- round(table(data$FTAG)/dim(data)[1], 3)) 
#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)
(gboth <- round(table(data$FTHG, data$FTAG)/dim(data)[1], 3)) 


#2. Gráficas
gh <- as.data.frame(gh)
str(gh)

gh <- gh %>% rename(goles = Var1, FRel = Freq)

p <- ggplot(gh, aes(x = goles, y = FRel)) + 
  geom_bar (stat="identity", fill = 'green') +
  ggtitle('Home team')
p


ga <- as.data.frame(ga)
ga <- rename(ga, goles = Var1, FRel = Freq)


p <- ggplot(ga, aes(x = goles, y = FRel)) + 
  geom_bar (stat="identity", fill = 'blue') +
  ggtitle('Away team')
p

gboth <- melt(gboth) 
gboth <- rename(gboth, gcasa = Var1, gvisita = Var2, ProbEst = value)
gboth %>% ggplot(aes(gcasa, gvisita)) + 
  geom_tile(aes(fill = ProbEst)) + 
  ggtitle('Both teams scoring') +
  scale_fill_gradient(low = 'white', high = 'red') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0))

