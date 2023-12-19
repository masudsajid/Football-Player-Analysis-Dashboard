library(readxl)
library(writexl)
library(dplyr)
setwd("C:\\Users\\GNG\\Desktop\\BEST11\\finals")
stat2022A2023 <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\players2022_23.xlsx")
load(file = "stat2022A2023.RData")
load(file = "AllPlayersWTrophies.RData")
load(file = "PlayerMainInfo.RData")
write_xlsx(AllPlayersWTrophies, "AllPlayersWTrophies.xlsx")
temp <- stat2022A2023

#deleting all last rows for each player
outRows <- c(0)
players <- unique(stat2022A2023$Name)
i <- 1
j <- 1
for (j in 1:39400){
  name <- players[i]
  current_name <- temp[j,1]
  if(name != current_name){
    outRows <- append(outRows, j-1)
    i <- i + 1
  }
}
temp <- temp[-outRows,]
temp <- temp[-39157,]
stat2022A2023 <- temp
save(stat2022A2023, file ="stat2022A2023.RData")

#combining stats in row/4 
df_all <- data.frame()
for(i in 1:248){
  df <- subset(stat2022A2023, Name == players[i])
  rowCount <- nrow(df)
  attack <- c(1: (rowCount/4))
  mid <- c(((rowCount/4) + 1): ((rowCount/4)*2))
  defence <- c(((rowCount/4)*2 + 1): ((rowCount/4)*3))
  errors <- c(((rowCount/4)*3 + 1): (rowCount))
  df_attack <- df[attack, 10:15]
  df_mid <- df[mid, 16:21]
  df_defence <- df[defence, 22:31]
  df_errors <- df[errors, 32:34]
  df[1:(rowCount/4), 10:15] <- df_attack
  df[1:(rowCount/4), 16:21] <- df_mid
  df[1:(rowCount/4), 22:31] <- df_defence
  df[1:(rowCount/4), 32:34] <- df_errors
  df <- df[1:(rowCount/4),]
  df_all <- rbind(df_all, df)
}
playerStats <- df_all
save(playerStats, file ="playerStats.RData")

#combining the trophies won by each player
WCStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\WorldCupWinnersExcel.xlsx")
UCLStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\UEFA Champions League Winners List Excel.xlsx")
EuropaStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\UEFA Europa League Winners List Excel.xlsx") 
EuroStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\Winners List of the UEFA Euro Excel.xlsx")
LeagueStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\Football League Winners Lists Excel.xlsx")
CopaAmericaStats <- read_excel("C:\\Users\\GNG\\Desktop\\BEST11\\finals\\Copa América Winners List Excel.xlsx")


#just checking whether any other string than season has slash or not
vector <- tempDF$event[grepl("/", tempDF$event)]

#making a mix Col to match trophies file's columns
tempDF <- mutate(playerStats, mixCol = " ")
season <- "2022/2023"
for (i in 1: 9789){
  if(grepl("/", tempDF[i,6]) == TRUE){
    season <- tempDF[i,6]
    tempDF[i,35] <- season
  }
  else {
    tempDF[i,35] <- paste(season, tempDF[i,6])
  }
}


tempDF <- mutate(tempDF, WC = "", UCL = "", Europa = "", Euro = "", "Copa America" = "", League = "")
for (i in 1: 9789){
  if((tempDF[i,35] %in% UCLStats$mix) == TRUE){
    tempDF[i,37] <- "Yes"
  }
  if((tempDF[i,35] %in% CopaAmericaStats$mix) == TRUE){
    tempDF[i,40] <- "Yes"
  }
  if((tempDF[i,35] %in% EuropaStats$mix) == TRUE){
    tempDF[i,38] <- "Yes"
  }
  if((tempDF[i,35] %in% EuroStats$mix) == TRUE){
    tempDF[i,39] <- "Yes"
  }
  if((tempDF[i,35] %in% LeagueStats$mix) == TRUE){
    tempDF[i,41] <- "Yes"
  }
  if((tempDF[i,35] %in% WCStats$mix) == TRUE){
    tempDF[i,36] <- "Yes"
  }
}

#manually glimpsing the trophies data
check <- subset(tempDF, WC == "Yes")

#Rudiger was coming up in WC won players, but was not a part of the squad, so Had to delete it
for (i in 1:9789){
  if(tempDF[i,1] == "Antonio Rüdiger" && tempDF[i,36] == "Yes"){
    print(i)
  }
}
tempDF[4196,36] <- ""
AllPlayersWTrophies <- tempDF
save(AllPlayersWTrophies, file ="AllPlayersWTrophies.RData")

#extracting images for each player
tempVec <- unique(AllPlayersWTrophies$Name)
playerNames <- data.frame( Names = tempVec, Image ="")
write_xlsx(playerNames, "playerNames.xlsx")

playerImages <- read_excel("playersImages.xlsx")
for (i in 1:248){
  if(playerNames[i,1] %in% playerImages$Name){
  playerNames[i,2] <- subset(playerImages, Name == playerNames[i,1])$Image
  }
}
playerImages2 <- read_excel("playersImages2.xlsx")
for (i in 1:248){
  if(playerNames[i,1] %in% playerImages2$Name){
    playerNames[i,2] <- subset(playerImages2, Name == playerNames[i,1])$Image
  }
}
write_xlsx(playerNames, "playerNames.xlsx")


#after manually entering image URL for 13 players
playerNames <- read_excel("playerNames.xlsx")

AllPlayersWTrophies <- mutate(AllPlayersWTrophies, Image = "")

AllPlayersWTrophies <- AllPlayersWTrophies[,-42]

#making new table to categorize by position
positions = data.frame(position = "", category = "")
x <- unique(AllPlayersWTrophies$position)
split_vec <- unlist(strsplit(x, ","))
y <- unique(split_vec)
for(i in 1:57){
  positions[i,1] <- y[i]
  
}
positions$position <- trimws(positions$position)
positionVec <- positions$position
write_xlsx(positions, "positions.xlsx")
for(i in 1:57){
  if(startsWith(positions[i,1], "F")){
    positions[i,2] <- "Attacker"
  }
  if(startsWith(positions[i,1], "AM")){
    positions[i,2] <- "Attacker/ Midfielder"
  }
  if(startsWith(positions[i,1], "M")){
    positions[i,2] <- "Midfielder"
  }
  if(startsWith(positions[i,1], "D")){
    positions[i,2] <- "Defender"
  }
  if(startsWith(positions[i,1], "DM")){
    positions[i,2] <- "Defender/ Midfielder"
  }
  if(startsWith(positions[i,1], "G")){
    positions[i,2] <- "GoalKeeper"
  }
}

playerCategory <- data.frame(name = "", category = "")
x <- unique(AllPlayersWTrophies$Name)
for(i in 1:248){
  playerCategory[i,1] <- x[i]
}
playerCategory <- mutate(playerCategory, x = "")
new_df <- AllPlayersWTrophies[, c("Name", "position")]
new_df <- new_df[!duplicated(new_df), ]
new_df <- mutate(new_df, category = "")
for(i in 1:248){
  if(grepl("AM", new_df[i,2])){
    new_df[i,3] <- "Attacker/ Midfielder"
  }
  else {
    if(grepl("DM", new_df[i,2])){
      new_df[i,3] <- "Defender/ Midfielder"
    }
    else{
      if(grepl("M", new_df[i,2])){
        new_df[i,3] <- "Midfielder"
      }
      else{
        if(grepl("D", new_df[i,2])){
          new_df[i,3] <- "Defender"
        }
        else {
          if(grepl("F", new_df[i,2])){
            new_df[i,3] <- "Attacker"
          }
          else {
            new_df[i,3] <- "GoalKeeper"
          }
        }
      }
    }
  }
}

playerCategory <- new_df
save(playerCategory, file = "playerCategory.RData")
playerCategory <- mutate(playerCategory, country = "", continent = "")
x <- unique(AllPlayersWTrophies$nationality)
for(i in 1:42){
  countries[i,1] <- x[i]
}
countries <-data.frame(countries = "")
write_xlsx(playerCategory, "playerCategories.xlsx")
playerCategory <- mutate(playerCategory, age = "", countryCode = "")
temp <- AllPlayersWTrophies[, c("Name", "nationality", "age")]
temp <- temp[!duplicated(temp[, c("Name", "nationality", "age")]), ]
temp$age <- substr(temp$age, start = 1, stop = 2)
playerCategory <- temp
uniqueCountry <- data.frame(country = unique(playerCategory$nationality))
write_xlsx(uniqueCountry, "temp.xlsx")
countries <- Countries[,1:3]
continents <-rename(continents, "nationality" = "country" )
cdf_merged <- merge(temp, continents, by = "nationality", all.x = TRUE)
playerCategory1 <- subset(cdf_merged, select = -c(country, continent))


###################################################################
continents <- read_xlsx("temp.xlsx")
continents <- continents[,1:3]
cdf_merged <- merge(playerCategory, countries, by = "nationality", all.x = TRUE)
cdf_merged <- merge(cdf_merged, playerCategory, by = "Name", all.x = TRUE)
cdf_merged <- cdf_merged[,1:7]
cdf_merged <-rename(cdf_merged, "name" = "Name", "nationality(abv)" = "nationality", "nationality(full)" = "full_form", "age" = "age.x", "continent" = "Continent")
PlayerMainInfo <- cdf_merged
save(PlayerMainInfo, file = "PlayerMainInfo.RData")

playerImages <- read_xlsx("playerNames.xlsx")
x <- merge(AllPlayersWTrophies, playerImages, by.x = "Name", by.y = "Name")
AllPlayersWTrophies <- x
save(AllPlayersWTrophies, file = "AllPlayersWTrophies.RData")
AllPlayersWTrophies$matches_played <- sub("\\(.*", "", AllPlayersWTrophies$matches_played)
AllPlayersWTrophies$substituted_matches <- gsub("\\(|\\)", "", AllPlayersWTrophies$substituted_matches)
AllPlayersWTrophies$shots <- sub("\\(.*", "", AllPlayersWTrophies$shots)
AllPlayersWTrophies$shots_on_target <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$shots_on_target)
AllPlayersWTrophies$shots_on_target <- AllPlayersWTrophies$shots_on_target * 100
AllPlayersWTrophies$shots_on_target <- AllPlayersWTrophies$shots_on_target * AllPlayersWTrophies$shots
AllPlayersWTrophies$penalties <- sub("\\(.*", "", AllPlayersWTrophies$penalties)
AllPlayersWTrophies$penalties_scored <- gsub("\\(|\\)", "", AllPlayersWTrophies$penalties_scored)
AllPlayersWTrophies$passes <- sub("\\(.*", "", AllPlayersWTrophies$passes)
AllPlayersWTrophies$accurate_passes <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$accurate_passes)
AllPlayersWTrophies$accurate_passes <- as.numeric(AllPlayersWTrophies$accurate_passes)
AllPlayersWTrophies$accurate_passes <- AllPlayersWTrophies$accurate_passes / 100
AllPlayersWTrophies$accurate_passes <- AllPlayersWTrophies$accurate_passes * AllPlayersWTrophies$passes
AllPlayersWTrophies$crosses <- sub("\\(.*", "", AllPlayersWTrophies$crosses)
AllPlayersWTrophies$accurate_crosses <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$accurate_crosses)
AllPlayersWTrophies$accurate_crosses <- as.numeric(AllPlayersWTrophies$accurate_crosses)
AllPlayersWTrophies$accurate_crosses <- AllPlayersWTrophies$accurate_crosses / 100
AllPlayersWTrophies$accurate_crosses <- AllPlayersWTrophies$accurate_crosses * AllPlayersWTrophies$crosses

AllPlayersWTrophies$challenges <- sub("\\(.*", "", AllPlayersWTrophies$challenges)
AllPlayersWTrophies$challenges_won <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$challenges_won)
AllPlayersWTrophies$challenges_won <- as.numeric(AllPlayersWTrophies$challenges_won)
AllPlayersWTrophies$challenges_won <- AllPlayersWTrophies$challenges_won / 100
AllPlayersWTrophies$challenges_won <- AllPlayersWTrophies$challenges_won * AllPlayersWTrophies$challenges

AllPlayersWTrophies$air_challenges <- sub("\\(.*", "", AllPlayersWTrophies$air_challenges)
AllPlayersWTrophies$air_challenges_won <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$air_challenges_won)
AllPlayersWTrophies$air_challenges_won <- as.numeric(AllPlayersWTrophies$air_challenges_won)
AllPlayersWTrophies$air_challenges_won <- AllPlayersWTrophies$air_challenges_won / 100
AllPlayersWTrophies$air_challenges_won <- AllPlayersWTrophies$air_challenges_won * AllPlayersWTrophies$air_challenges

AllPlayersWTrophies$tackles <- sub("\\(.*", "", AllPlayersWTrophies$tackles)
AllPlayersWTrophies$tackles_won <- gsub("\\(|\\)|\\%", "", AllPlayersWTrophies$tackles_won)
AllPlayersWTrophies$tackles_won <- as.numeric(AllPlayersWTrophies$tackles_won)
AllPlayersWTrophies$tackles_won <- AllPlayersWTrophies$tackles_won / 100
AllPlayersWTrophies$tackles_won <- AllPlayersWTrophies$tackles_won * AllPlayersWTrophies$tackles

for(i in 7:34){
  AllPlayersWTrophies[,i] <- as.numeric(AllPlayersWTrophies[,i])
}

write_xlsx(AllPlayersWTrophies, "AllPlayersWTrophies.xlsx")
save(AllPlayersWTrophies, file = "AllPlayersWTrophies.RData")

playerAttributes <- data.frame(name = "", minutes = "", matches = "", substituded = "", attacking = "", playmaking= "", defending = "", error = "", overall = "")
playerBySeason <- read_xlsx("AllPlayersWTrophies.xlsx", sheet = "Attributes")
for(i in 1:248){
  playerAttributes[i,1] <- playerBySeason[i,1]
  playerAttributes[i,2] <- playerBySeason[i,2]
  playerAttributes[i,3] <- playerBySeason[i,3]
  playerAttributes[i,4] <- playerBySeason[i,5]
  playerAttributes[i,5] <-(playerBySeason[i,6]/ playerBySeason[i,5])*0.20 + (playerBySeason[i,8]/ playerBySeason[i,7])*0.20 + playerBySeason[i,9]*0.40 + (playerBySeason[i,10]/ playerBySeason[i,2])*0.20
  playerAttributes[i,6] <- (playerBySeason[i,12]/ playerBySeason[i,11])*0.20 + playerBySeason[i,13]*0.40 + (playerBySeason[i,15]/ playerBySeason[i,14])*0.30 + playerBySeason[i,16]*0.10
  playerAttributes[i,7] <- playerBySeason[i,18]*0.50 + playerBySeason[i,19]*0.50 + (playerBySeason[i,21]/ playerBySeason[i,20])*0.20 + (playerBySeason[i,23]/ playerBySeason[i,22])*0.20 + (playerBySeason[i,25]/ playerBySeason[i,24])*0.40 + playerBySeason[i,26]*0.10
  playerAttributes[i,8] <- playerBySeason[i,27]*0.20 + playerBySeason[i,28]*0.30 + playerBySeason[i,29]*0.50
  playerAttributes[i,9] <- (as.numeric(playerAttributes[i,5])*(0.20)) + (as.numeric(playerAttributes[i,6])*(0.20)) + (as.numeric(playerAttributes[i,7])*(0.20)) + (as.numeric(playerAttributes[i,8])*(0.20))
}

save(playerAttributes, file = "playerAttributes.RData")
write_xlsx(playerAttributes, "playerAttributes.xlsx")


###################################################################

unique_values <- table(AllPlayersWTrophies$Name)
write_xlsx(AllPlayersWTrophies, "AllPlayersWTrophies.xlsx")
#after manually entering image URL for 13 players
playerImages <- read_excel("playerImages.xlsx")
x <- merge(AllPlayersWTrophies, playerNames, by.x = "Name", by.y = "Names")
AllPlayersWTrophies <- x
write_xlsx(AllPlayersWTrophies, "AllPlayersWTrophies.xlsx")
AllPlayersWTrophies <- read_xlsx("AllPlayersWTrophies.xlsx")
#making new table to categorize by position
positions = data.frame(position = "", category = "")
x <- unique(AllPlayersWTrophies$position)
split_vec <- unlist(strsplit(x, ","))
y <- unique(split_vec)
for(i in 1:57){
  positions[i,1] <- y[i]
  
}
positions$position <- trimws(positions$position)
positionVec <- positions$position
write_xlsx(positions, "positions.xlsx")
for(i in 1:57){
  if(startsWith(positions[i,1], "F")){
    positions[i,2] <- "Attacker"
  }
  if(startsWith(positions[i,1], "AM")){
    positions[i,2] <- "Attacker/ Midfielder"
  }
  if(startsWith(positions[i,1], "M")){
    positions[i,2] <- "Midfielder"
  }
  if(startsWith(positions[i,1], "D")){
    positions[i,2] <- "Defender"
  }
  if(startsWith(positions[i,1], "DM")){
    positions[i,2] <- "Defender/ Midfielder"
  }
  if(startsWith(positions[i,1], "G")){
    positions[i,2] <- "GoalKeeper"
  }
}

playerCategory <- data.frame(name = "", category = "")
x <- unique(AllPlayersWTrophies$Name)
for(i in 1:248){
  playerCategory[i,1] <- x[i]
}
playerCategory <- mutate(playerCategory, x = "")
new_df <- AllPlayersWTrophies[, c("Name", "position")]
new_df <- new_df[!duplicated(new_df), ]
new_df <- mutate(new_df, category = "")
for(i in 1:248){
  if(grepl("AM", new_df[i,2])){
    new_df[i,3] <- "Attacker/ Midfielder"
  }
  else {
    if(grepl("DM", new_df[i,2])){
      new_df[i,3] <- "Defender/ Midfielder"
    }
    else{
      if(grepl("M", new_df[i,2])){
        new_df[i,3] <- "Midfielder"
      }
      else{
        if(grepl("D", new_df[i,2])){
          new_df[i,3] <- "Defender"
        }
        else {
          if(grepl("F", new_df[i,2])){
            new_df[i,3] <- "Attacker"
          }
          else {
            new_df[i,3] <- "GoalKeeper"
          }
        }
      }
    }
  }
}

playerCategory <- new_df
save(playerCategory, file = "playerCategory.RData")
playerCategory <- mutate(playerCategory, country = "", continent = "")
x <- unique(AllPlayersWTrophies$nationality)
PlayerMainInfo <- mutate(PlayerMainInfo, club = "")
for (i in 1:248){
  for(j in 1:9789){
    if (AllPlayersWTrophies[j,1] == PlayerMainInfo[i,1]){
      PlayerMainInfo[i,8] <- AllPlayersWTrophies[j,3]
    }
  }
}
write_xlsx(PlayerMainInfo, "PlayerMainInfo.xlsx")
df <- left_join(PlayerMainInfo, playerImages, by = c("name" = "Names"))
PlayerMainInfo <- df
write_xlsx(PlayerMainInfo, "PlayerMainInfo.xlsx")
AllPlayersWTrophies <- read_xlsx("AllPlayersWTrophies.xlsx")

AllPlayersWTrophies$matches_played <- gsub("\\(.*", "", AllPlayersWTrophies$matches_played)
AllPlayersWTrophies$matches_played <- as.integer(AllPlayersWTrophies$matches_played)

AllPlayersWTrophies$substituted_matches <- gsub("\\(|\\)", "", AllPlayersWTrophies$substituted_matches)
AllPlayersWTrophies$substituted_matches <- as.integer(AllPlayersWTrophies$substituted_matches)

AllPlayersWTrophies$minutes_played <- gsub("\\.", "", AllPlayersWTrophies$minutes_played)
AllPlayersWTrophies$minutes_played <- as.integer(AllPlayersWTrophies$minutes_played)

AllPlayersWTrophies$shots <- gsub("\\(.*", "", AllPlayersWTrophies$shots)
AllPlayersWTrophies$shots <- as.integer(AllPlayersWTrophies$shots)

AllPlayersWTrophies$shots_on_target <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$shots_on_target)
AllPlayersWTrophies$shots_on_target <- as.integer(AllPlayersWTrophies$shots_on_target)
AllPlayersWTrophies$shots_on_target <- AllPlayersWTrophies$shots_on_target / 100
AllPlayersWTrophies$shots_on_target <- AllPlayersWTrophies$shots_on_target * AllPlayersWTrophies$shots

AllPlayersWTrophies$penalties <- gsub("\\(.*", "", AllPlayersWTrophies$penalties)
AllPlayersWTrophies$penalties <- as.integer(AllPlayersWTrophies$penalties)

AllPlayersWTrophies$penalties_scored <- gsub("\\(|\\)", "", AllPlayersWTrophies$penalties_scored)
AllPlayersWTrophies$penalties_scored <- as.integer(AllPlayersWTrophies$penalties_scored)

AllPlayersWTrophies$expected_goals <- as.integer(AllPlayersWTrophies$expected_goals)

AllPlayersWTrophies$attacking_challenges <- as.integer(AllPlayersWTrophies$attacking_challenges)

AllPlayersWTrophies$passes <- gsub("\\(.*", "", AllPlayersWTrophies$passes)
AllPlayersWTrophies$passes <- as.integer(AllPlayersWTrophies$passes)

AllPlayersWTrophies$accurate_passes <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$accurate_passes)
AllPlayersWTrophies$accurate_passes <- as.integer(AllPlayersWTrophies$accurate_passes)
AllPlayersWTrophies$accurate_passes <- AllPlayersWTrophies$accurate_passes / 100
AllPlayersWTrophies$accurate_passes <- AllPlayersWTrophies$accurate_passes * AllPlayersWTrophies$passes

AllPlayersWTrophies$key_passes <- as.integer(AllPlayersWTrophies$key_passes)

AllPlayersWTrophies$crosses <- gsub("\\(.*", "", AllPlayersWTrophies$crosses)
AllPlayersWTrophies$crosses <- as.integer(AllPlayersWTrophies$crosses)

AllPlayersWTrophies$accurate_crosses <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$accurate_crosses)
AllPlayersWTrophies$accurate_crosses <- as.integer(AllPlayersWTrophies$accurate_crosses)
AllPlayersWTrophies$accurate_crosses <- AllPlayersWTrophies$accurate_crosses / 100
AllPlayersWTrophies$accurate_crosses <- AllPlayersWTrophies$accurate_crosses * AllPlayersWTrophies$crosses

AllPlayersWTrophies$dribbles <- as.integer(AllPlayersWTrophies$dribbles)

AllPlayersWTrophies$offsides <- as.integer(AllPlayersWTrophies$offsides)

AllPlayersWTrophies$ball_recoveries <- as.integer(AllPlayersWTrophies$ball_recoveries)

AllPlayersWTrophies$ball_recoveries_opponent_half <- as.integer(AllPlayersWTrophies$ball_recoveries_opponent_half)

AllPlayersWTrophies$challenges <- gsub("\\(.*", "", AllPlayersWTrophies$challenges)
AllPlayersWTrophies$challenges <- as.integer(AllPlayersWTrophies$challenges)

AllPlayersWTrophies$challenges_won <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$challenges_won)
AllPlayersWTrophies$challenges_won <- as.integer(AllPlayersWTrophies$challenges_won)
AllPlayersWTrophies$challenges_won <- AllPlayersWTrophies$challenges_won / 100
AllPlayersWTrophies$challenges_won <- AllPlayersWTrophies$challenges_won * AllPlayersWTrophies$challenges

AllPlayersWTrophies$air_challenges <- gsub("\\(.*", "", AllPlayersWTrophies$air_challenges)
AllPlayersWTrophies$air_challenges <- as.integer(AllPlayersWTrophies$air_challenges)

AllPlayersWTrophies$air_challenges_won <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$air_challenges_won)
AllPlayersWTrophies$air_challenges_won <- as.integer(AllPlayersWTrophies$air_challenges_won)
AllPlayersWTrophies$air_challenges_won <- AllPlayersWTrophies$air_challenges_won / 100
AllPlayersWTrophies$air_challenges_won <- AllPlayersWTrophies$air_challenges_won * AllPlayersWTrophies$air_challenges

AllPlayersWTrophies$tackles <- gsub("\\(.*", "", AllPlayersWTrophies$tackles)
AllPlayersWTrophies$tackles <- as.integer(AllPlayersWTrophies$tackles)

AllPlayersWTrophies$tackles_won <- gsub("\\(|\\)|%", "", AllPlayersWTrophies$tackles_won)
AllPlayersWTrophies$tackles_won <- as.integer(AllPlayersWTrophies$tackles_won)
AllPlayersWTrophies$tackles_won <- AllPlayersWTrophies$tackles_won / 100
AllPlayersWTrophies$tackles_won <- AllPlayersWTrophies$tackles_won * AllPlayersWTrophies$tackles

AllPlayersWTrophies$interceptions <- as.integer(AllPlayersWTrophies$interceptions)

AllPlayersWTrophies$lost_balls <- as.integer(AllPlayersWTrophies$lost_balls)

AllPlayersWTrophies$lost_balls_own_half <- as.integer(AllPlayersWTrophies$lost_balls_own_half)

AllPlayersWTrophies$errors_leading_to_goal <- as.integer(AllPlayersWTrophies$errors_leading_to_goal)

AllPlayersWTrophies <- AllPlayersWTrophies[,-42]

save(AllPlayersWTrophies, file = "AllPlayersWTrophies.RData")
write_xlsx(AllPlayersWTrophies, "playerDetails.xlsx")