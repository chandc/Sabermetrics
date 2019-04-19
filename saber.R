win_estimators <- read.csv('win_estimators.csv')

summary(win_estimators)

mean(win_estimators$WPct)

sd(win_estimators$WPct)

avgRuns <- mean(win_estimators$R)


x <- avgRuns - sqrt(avgRuns*avgRuns/(1/(.500-1/162)-1))

estimators <- win_estimators[c('RperG', 'RAperG', 'WPct','Cook_WPct',  'Soolman_WPct',  'Kross_WPct', 'Smyth_WPct', 'BJames_Pythag_WPct', 'BJames_Pythag_WPctII')]

require('lattice')

splom(estimators, xlab='Win Estimators')


wpct_95th_pct = quantile(win_estimators$WPct, .95)

top_winners = win_estimators[win_estimators$WPct >= wpct_95th_pct, ]

summary(top_winners)

# AL_EAST teams:
#Baltimore Orioles, Boston Red Sox, New York Yankees, Tampa Bay Rays, Toronto Blue Jays
#BAL, BOS, NYA, TBA, TOR


# teams from the NL West:
#Arizona Diamondbacks, Colorado Rockies, Los Angeles Dodgers, San Diego Padres, and San #Francisco Giants
#ARI, COL, LAN, SDN, SFN

AL_East <- c("BAL", "BOS", "NYA", "TBA", "TOR")

NL_West <- c("ARI", "COL", "LAN", "SDN", "SFN")

AL_East_estimator <- subset(win_estimators,teamID %in% AL_East)
NL_West_estimator <- subset(win_estimators,teamID %in% NL_West)


histogram(AL_East_estimator$WPct,nint=9)
histogram(AL_East_estimator$Soolman_WPct,nint=9)
histogram(AL_East_estimator$Kross_WPct,nint=9)

sd(AL_East_estimator$WPct)
sd(AL_East_estimator$Soolman_WPct)
sd(AL_East_estimator$Kross_WPct)

sd(NL_West_estimator$WPct)
sd(NL_West_estimator$Soolman_WPct)
sd(NL_West_estimator$Kross_WPct)


avgRuns <- mean(AL_East_estimator$R)
avgRA   <- mean(AL_East_estimator$RA)
Avg_WPct <- mean(AL_East_estimator$WPct)
avgRuns - sqrt(avgRA*avgRA/(1/(Avg_WPct-1/162)-1))

avgRuns <- mean(NL_West_estimator$R)
avgRA   <- mean(NL_West_estimator$RA)
Avg_WPct <- mean(NL_West_estimator$WPct)
avgRuns - sqrt(avgRA*avgRA/(1/(Avg_WPct-1/162)-1))


game_statistics <- read.csv('game_statistics.csv')
attach(game_statistics)
game_statistics$total_runs <- with(game_statistics, home_score + visitor_score)

# or equivalently
# total_runs <- with(game_statistics, home_score + visitor_score)
# game_statistics["total_runs"] <- total_runs

total_time_data <- game_statistics[c('game_minutes', 'total_runs', 'outs')]

require('lattice')
splom(total_time_data)
cor(game_minutes, outs)
plot(game_statistics$total_runs, game_statistics$outs)

attach(game_statistics)
projected_minutes <- lm(game_minutes ~ total_runs + outs)

game_statistics$RedSox_playing <- with(game_statistics, ifelse(home == 'BOS' | visitor == 'BOS', 1, 0))  
RedSox_games <- game_statistics[game_statistics$RedSox_playing == 1,]

summary(RedSox_games)

mean(RedSox_games$total_runs)
mean(game_statistics$total_runs)

mean(RedSox_games$home_score+RedSox_games$visitor_score)

histogram(RedSox_games$total_runs,nint=31)

#Please copy this code, and then repeat it for the other 3 umpires. Now, create 4 new #data frames which consist of the games umpired by Brian Gorman, Jim Joyce, Dale Scott, #and Tim Welke. Below is the code for Brian Gorman:
  
game_statistics$BrianGorman <- with(game_statistics, ifelse(hp_ump_name == 'Brian Gorman', 1, 0))
BrianGorman_games <- game_statistics[game_statistics$BrianGorman == 1,]

game_statistics$JimJoyce <- with(game_statistics, ifelse(hp_ump_name == 'Jim Joyce', 1, 0))
JimJoyce_games <- game_statistics[game_statistics$JimJoyce == 1,]

game_statistics$DaleScott <- with(game_statistics, ifelse(hp_ump_name == 'Dale Scott', 1, 0))
DaleScott_games <- game_statistics[game_statistics$DaleScott == 1,]

game_statistics$TimWelke <- with(game_statistics, ifelse(hp_ump_name == 'Tim Welke', 1, 0))
TimWelke_games <- game_statistics[game_statistics$TimWelke == 1,]

mean(game_statistics$total_runs)
mean(BrianGorman_games$total_runs)
mean(JimJoyce_games$total_runs)
mean(DaleScott_games$total_runs)
mean(TimWelke_games$total_runs)

attach(game_statistics)
projected_runs <- lm(total_runs ~ RedSox_playing + BrianGorman + JimJoyce + DaleScott + TimWelke )

projected_runs

confint(projected_runs, level = 0.95)


rox <- read.csv('coors_park_factors.csv')

# After this, we need to create home and away data frames as such:
  
park <- subset(rox, home == "COL")

away <- subset(rox, visitor == "COL")

# find the ratios for home and away home runs at Coors:
  
park_ratio <- sum(park$home_hr + park$visitor_hr) / sum(park$home_ab + park$visitor_ab)

away_ratio <- sum(away$home_hr + away$visitor_hr) / sum(away$home_ab + away$visitor_ab)

100*park_ratio/away_ratio



library(plyr)
pf_all <- read.csv('park_factors.csv')
pf_all <- within(pf_all, levels(home)[levels(home)=='FLO'] <- 'MIA')
pf_all <- within(pf_all, levels(visitor)[levels(visitor)=='FLO'] <- 'MIA')

#function pf_stat_teams, which takes in a statistic, a data frame, and a year and #returns a data frame with all of the teams' park factor for the specified statistic for #the specified year:

pf_stat_teams <- function(stat, data, season_year=2013) {
#To start, we will filter our data frame by the correct year.
data <- subset(data, year == season_year)
#We next build strings for accessing proper PF stat, 
#followed by filtering out unnecessary columns.

home_stat = paste("home", stat, sep="_")

visitor_stat = paste("visitor", stat, sep="_")

pf_stat = paste(stat, "pf", season_year, sep="_")

cols = c(home_stat, visitor_stat, "home_ab", "visitor_ab")

#We continue by separating by home/away as 
#we did in the Rockies HR Park Factor for 2013, 
#but now we group by team as well. 
#Additionally, we calculate sums of desired stat and AB in this step.

park_sums <- ddply(data, .(home), colwise(sum, cols))

away_sums <- ddply(data, .(visitor), colwise(sum, cols))

#We now calculate stat/AB frequency ratios.

park_sums$park_ratio <- (park_sums[[home_stat]] + park_sums[[visitor_stat]]) / (park_sums[["home_ab"]] + park_sums[["visitor_ab"]])

away_sums$away_ratio <- (away_sums[[home_stat]] + away_sums[[visitor_stat]]) / (away_sums[["home_ab"]] + away_sums[["visitor_ab"]])

#We proceed by merging together park and visitor ratios. 
#Notice how the merge() function and the by statement inside of it 
#as a parameter behave like a JOIN and ON in SQL.

pf <- merge(park_sums, away_sums, by.x="home", by.y="visitor")

#Now, we calculate the ratio of ratios to get the final PF.

pf[[pf_stat]] <- with(pf, pf$park_ratio / pf$away_ratio)

#Finally, we clean up the dataframe, and return this version.

pf <- rename(pf, replace=c("home" = "team"))

pf <- subset(pf, select = c("team", pf_stat))

return(pf)

}

#With this function, we can see the entire league's park factors for any statistic for #any year. We provide below example code to find the 2013 home run park factors:

db <- pf_stat_teams("2b", pf_all, season_year=2010)
bb <- pf_stat_teams("bb", pf_all, season_year=2011)








