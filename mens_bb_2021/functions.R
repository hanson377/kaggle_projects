## uses opposing behavior as prior
ModelGen <- function(data) {

## winning stats for points made
WGames <- max(data$WGames)

 WFGM <- sum(data$WFGM)
 WFGM3 <- sum(data$WFGM3)
 WFGM2 <- WFGM-WFGM3
 WFTM <- sum(data$WFTM)

 ## winning points afford
 WOppFGM <- sum(data$WOppFGM)
 WOppFGM3 <- sum(data$WOppFGM3)
 WOppFGM2 <- WOppFGM-WOppFGM3
 WOppFTM <- sum(data$WOppFTM)

 WMeanDiff <- max(data$WmeanDiffPoints)
 WSDDiff <- max(data$WsdDiffPoints)

 ## losing stats scored
 LGames <- max(data$LGames)

 LFGM <- sum(data$LFGM)
 LFGM3 <- sum(data$LFGM3)
 LFGM2 <- LFGM-LFGM3
 LFTM <- sum(data$LFTM)

 ## losing stats yes
 LOppFGM <- sum(data$LOppFGM)
 LOppFGM3 <- sum(data$LOppFGM3)
 LOppFGM2 <- LOppFGM-LOppFGM3
 LOppFTM <- sum(data$LOppFTM)

 LMeanDiff <- max(data$LmeanDiffPoints)
 LSDDiff <- max(data$LsdDiffPoints)

 ## generate models
 trials <- 500000

 ## general models with gamma distribution
 WFGM3_posterior = rgamma(trials,(WFGM3+LOppFGM3),(WGames+LGames))
 WFGM3_prior = rgamma(trials,LOppFGM3,LGames)
 WFGM3_likelihood = rgamma(trials,WFGM3,WGames)

 WFGM2_posterior = rgamma(trials,(WFGM2+LOppFGM2),(WGames+LGames))
 WFGM2_prior = rgamma(trials,LOppFGM2,LGames)
 WFGM2_likelihood = rgamma(trials,WFGM2,WGames)

 WFTM_posterior = rgamma(trials,(WFTM+LOppFTM),(WGames+LGames))
 WFTM_prior = rgamma(trials,LOppFTM,LGames)
 WFTM_likelihood = rgamma(trials,WFTM,WGames)


 LFGM3_posterior = rgamma(trials,(LFGM3+WOppFGM3),(WGames+LGames))
 LFGM3_prior = rgamma(trials,WOppFGM3,WGames)
 LFGM3_likelihood = rgamma(trials,LFGM3,LGames)

 LFGM2_posterior = rgamma(trials,(LFGM2+WOppFGM2),(WGames+LGames))
 LFGM2_prior = rgamma(trials,WOppFGM2,WGames)
 LFGM2_likelihood = rgamma(trials,LFGM2,LGames)

 LFTM_posterior = rgamma(trials,(LFTM+WOppFTM),(WGames+LGames))
 LFTM_prior = rgamma(trials,WOppFTM,WGames)
 LFTM_likelihood = rgamma(trials,LFTM,LGames)

 WDiff = rnorm(trials,WMeanDiff,WSDDiff)
 LDiff = rnorm(trials,LMeanDiff,LSDDiff)

 model <- data.frame(WFGM3_posterior,WFGM2_posterior,WFTM_posterior,LFGM3_posterior,LFGM2_posterior,LFTM_posterior,WDiff,LDiff,WFGM3_prior,WFGM3_likelihood,WFGM2_prior,WFGM2_likelihood,LFGM2_likelihood,LFGM2_prior,LFGM3_prior,LFGM3_likelihood,LFTM_prior,LFTM_likelihood,WFTM_prior,WFTM_likelihood,LFTM_prior,LFTM_likelihood)

 model$WPoints <- (WFGM2_posterior*2)+(WFGM3_posterior*3)+(WFTM_posterior*1)
 model$WPoints_prior <- (WFGM2_prior*2)+(WFGM3_prior*3)+(WFTM_prior*1)
 model$WPoints_likelihood <- (WFGM2_likelihood*2)+(WFGM3_likelihood*3)+(WFTM_likelihood*1)

 model$LPoints <- (LFGM2_posterior*2)+(LFGM3_posterior*3)+(LFTM_posterior*1)
 model$LPoints_prior <- (LFGM2_prior*2)+(LFGM3_prior*3)+(LFTM_prior*1)
 model$LPoints_likelihood <- (LFGM2_likelihood*2)+(LFGM3_likelihood*3)+(LFTM_likelihood*1)


 return(model)
}



genViews <- function(model,WTeam,LTeam,Year,xmin,xmax,title1,title2) {

  game <- subset(tourney,WTeamName == WTeam & LTeamName == LTeam & Season == Year)
  simulations <- ModelGen(game)

  if (model == 'FGM2') {


    prior <- simulations %>% select(value = WFGM2_prior) %>% mutate(model = 'prior')
    likelihood <- simulations %>% select(value = WFGM2_likelihood) %>% mutate(model = 'likelihood')
    posterior <- simulations %>% select(value = WFGM2_posterior) %>% mutate(model = 'posterior')

    sample1 <- rbind(prior,likelihood,posterior)
    sample1$model <- factor(sample1$model,levels = c('prior','likelihood','posterior'))


    prior <- simulations %>% select(value = LFGM2_prior) %>% mutate(model = 'prior')
    likelihood <- simulations %>% select(value = LFGM2_likelihood) %>% mutate(model = 'likelihood')
    posterior <- simulations %>% select(value = LFGM2_posterior) %>% mutate(model = 'posterior')

    sample2 <- rbind(prior,likelihood,posterior)
    sample2$model <- factor(sample2$model,levels = c('prior','likelihood','posterior'))


    view1 <- ggplot(sample1,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'none') + ggtitle(title1)  + xlab('') + ylab('')
    view2 <- ggplot(sample2,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'bottom',legend.title=element_blank()) + ggtitle(title2) + xlab('Total 2-Point FGs') + ylab('')

    return(grid.arrange(view1,view2))
  }

 if (model == 'FGM3') {

   prior <- simulations %>% select(value = WFGM3_prior) %>% mutate(model = 'prior')
   likelihood <- simulations %>% select(value = WFGM3_likelihood) %>% mutate(model = 'likelihood')
   posterior <- simulations %>% select(value = WFGM3_posterior) %>% mutate(model = 'posterior')

   sample1 <- rbind(prior,likelihood,posterior)
   sample1$model <- factor(sample1$model,levels = c('prior','likelihood','posterior'))


   prior <- simulations %>% select(value = LFGM3_prior) %>% mutate(model = 'prior')
   likelihood <- simulations %>% select(value = LFGM3_likelihood) %>% mutate(model = 'likelihood')
   posterior <- simulations %>% select(value = LFGM3_posterior) %>% mutate(model = 'posterior')

   sample2 <- rbind(prior,likelihood,posterior)
   sample2$model <- factor(sample2$model,levels = c('prior','likelihood','posterior'))



   view1 <- ggplot(sample1,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'none') + ggtitle(title1)  + xlab('') + ylab('')
   view2 <- ggplot(sample2,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'bottom',legend.title=element_blank()) + ggtitle(title2) + xlab('Total 3-Point FGs') + ylab('')

   return(grid.arrange(view1,view2))
 }

 if (model == 'FTM') {

   prior <- simulations %>% select(value = WFTM_prior) %>% mutate(model = 'prior')
   likelihood <- simulations %>% select(value = WFTM_likelihood) %>% mutate(model = 'likelihood')
   posterior <- simulations %>% select(value = WFTM_posterior) %>% mutate(model = 'posterior')

   sample1 <- rbind(prior,likelihood,posterior)
   sample1$model <- factor(sample1$model,levels = c('prior','likelihood','posterior'))


   prior <- simulations %>% select(value = LFTM_prior) %>% mutate(model = 'prior')
   likelihood <- simulations %>% select(value = LFTM_likelihood) %>% mutate(model = 'likelihood')
   posterior <- simulations %>% select(value = LFTM_posterior) %>% mutate(model = 'posterior')

   sample2 <- rbind(prior,likelihood,posterior)
   sample2$model <- factor(sample2$model,levels = c('prior','likelihood','posterior'))



   view1 <- ggplot(sample1,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'none') + ggtitle(title1) + xlab('') + ylab('')
   view2 <- ggplot(sample2,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'bottom',legend.title=element_blank()) + ggtitle(title2) + xlab('Total FTs') + ylab('')

   return(grid.arrange(view1,view2))
 }


  if (model == 'Points') {

    prior <- simulations %>% select(value = WPoints_prior) %>% mutate(model = 'prior')
    likelihood <- simulations %>% select(value = WPoints_likelihood) %>% mutate(model = 'likelihood')
    posterior <- simulations %>% select(value = WPoints) %>% mutate(model = 'posterior')

    sample1 <- rbind(prior,likelihood,posterior)
    sample1$model <- factor(sample1$model,levels = c('prior','likelihood','posterior'))


    prior <- simulations %>% select(value = LPoints_prior) %>% mutate(model = 'prior')
    likelihood <- simulations %>% select(value = LPoints_likelihood) %>% mutate(model = 'likelihood')
    posterior <- simulations %>% select(value = LPoints) %>% mutate(model = 'posterior')

    sample2 <- rbind(prior,likelihood,posterior)
    sample2$model <- factor(sample2$model,levels = c('prior','likelihood','posterior'))

    view1 <- ggplot(sample1,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'none') + ggtitle(title1)  + xlab('') + ylab('')
    view2 <- ggplot(sample2,aes(x=value,colour=model)) + geom_density() + coord_cartesian(xlim=c(xmin,xmax)) + theme(legend.position = 'bottom',legend.title=element_blank()) + ggtitle(title2) + xlab('Total Points Scored') + ylab('')

    return(grid.arrange(view1,view2))
  }

}

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


cleanSeasonData <- function(data){
wins <- data %>% select(Season,DayNum,TeamID = WTeamID, OpposingTeamID = LTeamID, FGM = WFGM, FGA = WFGA,OppFGM = LFGM, OppFGA = LFGA, FGM3 = WFGM3, FGA3 = WFGA3, OppFGM3 = LFGM3, OppFGA3 = LFGA3, FTM = WFTM, FTA = WFTA, OppFTM = LFTM, OppFTA = LFTA) %>% mutate(status = 'won')

losses <- data %>% select(Season,DayNum,TeamID = LTeamID, OpposingTeamID = WTeamID,FGM = LFGM, FGA = LFGA, OppFGM = WFGM, OppFGA = WFGA, FGM3 = LFGM3, FGA3 = LFGA3, OppFGM3 = WFGM3, OppFGA3 = WFGA3, FTM = LFTM, FTA = LFTA, OppFTM = WFTM, OppFTA = WFTA) %>% mutate(status = 'lost')

games <- rbind(wins,losses)
games$diffFG <- (games$FGM-games$OppFGM)
games$diffFG2 <- (games$FGM-games$FGM3)-(games$OppFGM-games$OppFGM3)
games$diffFG3 <- (games$FGM3-games$OppFGM3)
games$diffFT <- (games$FTM-games$OppFTM)

games$diffPoints <- (games$diffFG2*2)+(games$diffFG3*2)+(games$diffFT*1)

summary <- games %>% group_by(TeamID,Season) %>% summarise(total_games = n(), FGM = sum(FGM), FGA = sum(FGA), OppFGM = sum(OppFGM), OppFGA = sum(OppFGA), FGM3 = sum(FGM3), FGA3 = sum(FGA3), OppFGM3 = sum(OppFGM3), OppFGA3 = sum(OppFGA3), FTM = sum(FTM), FTA = sum(FTA), OppFTM = sum(OppFTM), OppFTA = sum(OppFTA), meanDiffPoints = mean(diffPoints), sdDiffPoints = sd(diffPoints))

return(list(summary,games))
}

seasonToTourney <- function(season_data){
tourney <- tourney_results %>% select(Season,WTeamID,LTeamID)

summary_wins <- season_data %>%
  mutate(Season,
         WTeamID = TeamID,
         WFGM = FGM,
         WFGM3 = FGM3,
         WFGM2 = FGM-FGM3,
         WFTM = FTM,
         WOppFGM = OppFGM,
         WOppFGM3 = OppFGM3,
         WOppFGM2 = OppFGM-OppFGM3,
         WOppFTM = OppFTM,
         WmeanDiffPoints = meanDiffPoints,
         WsdDiffPoints=sdDiffPoints,
         WGames = total_games) %>%
          ungroup() %>%
            select(Season,WGames,WTeamID,WFGM,WFGM3,WFGM2,WFTM,WOppFGM,WOppFGM3,WOppFGM2,WOppFTM,WmeanDiffPoints,WsdDiffPoints)

summary_losses <- season_data %>%
  mutate(Season,
         LTeamID = TeamID,
         LFGM = FGM,
         LFGM3 = FGM3,
         LFGM2 = FGM-FGM3,
         LFTM = FTM,
         LOppFGM = OppFGM,
         LOppFGM3 = OppFGM3,
         LOppFGM2 = OppFGM-OppFGM3,
         LOppFTM = OppFTM,
         LmeanDiffPoints = meanDiffPoints,
         LsdDiffPoints=sdDiffPoints,
         LGames = total_games) %>%
          ungroup() %>%
            select(Season,LGames,LTeamID,LFGM,LFGM3,LFGM2,LFTM,LOppFGM,LOppFGM3,LOppFGM2,LOppFTM,LmeanDiffPoints,LsdDiffPoints)

tourney <- tourney %>% inner_join(summary_wins,by=c('WTeamID','Season')) %>% inner_join(summary_losses,by=c('LTeamID','Season'))
tourney <- tourney %>% mutate(game = row_number())

teams <- teams %>% select(TeamID,TeamName)
tourney <- tourney %>% left_join(teams,by=c('LTeamID' = 'TeamID')) %>% mutate(LTeamName = TeamName) %>% select(-TeamName)
tourney <- tourney %>% left_join(teams,by=c('WTeamID' = 'TeamID')) %>% mutate(WTeamName = TeamName) %>% select(-TeamName)

return(tourney)
}

vizPoints <- function(WTeam,LTeam,Year) {

  game <- subset(tourney,WTeamName == WTeam & LTeamName == LTeam & Season == Year)
  simulations <- ModelGen(game)

  simulations$FGM2_diff <- (simulations$WFGM2_posterior-simulations$LFGM2_posterior)
  simulations$FGM3_diff <- (simulations$WFGM3_posterior-simulations$LFGM3_posterior)
  simulations$FTM_diff <- (simulations$WFTM_posterior-simulations$LFTM_posterior)
  simulations$points_diff <- (simulations$WPoints-simulations$LPoints)


  view1 <- ggplot(simulations,aes(x=points_diff)) + geom_histogram(binwidth=1) + ggtitle('Total Points Scored')  + geom_vline(xintercept = 0, linetype = 'dashed', colour='red') + xlab('') + ylab('')
  view2 <- ggplot(simulations,aes(x=FGM2_diff)) + geom_histogram(binwidth=1)  + ggtitle('FGM2') + geom_vline(xintercept = 0, linetype = 'dashed', colour='red') + xlab('') + ylab('')
  view3 <- ggplot(simulations,aes(x=FGM3_diff)) + geom_histogram(binwidth=1)  + ggtitle('FGM3') + geom_vline(xintercept = 0, linetype = 'dashed', colour='red') + xlab('') + ylab('')
  view4 <- ggplot(simulations,aes(x=FTM_diff)) + geom_histogram(binwidth=1) + ggtitle('FTM') + geom_vline(xintercept = 0, linetype = 'dashed', colour='red') + xlab('') + ylab('')

  return(grid.arrange(view1,view2,view3,view4,nrow=2,top = 'Distribution of Differences in Points Scored Across 1M Simulations'))

}

modelTest <- function(WTeam,LTeam,SeasonP,OWeighting) {

game <- subset(tourney,WTeamName == WTeam & LTeamName == LTeam & Season == SeasonP)

OMultiplier <- 1+OWeighting
DMultiplier <- 1-OWeighting

team1_games <- max(game$WGames)
team2_games <- max(game$LGames)

team1_FGM2 <- max(game$WFGM2)*OMultiplier
team1_OppFGM2 <- max(game$WOppFGM2)*DMultiplier

team2_FGM2 <- max(game$LFGM2)*OMultiplier
team2_OppFGM2 <- max(game$LOppFGM2)*DMultiplier

## 3 pt fgs
team1_FGM3 <- max(game$WFGM3)*OMultiplier
team1_OppFGM3 <- max(game$WOppFGM3)*DMultiplier

team2_FGM3 <- max(game$LFGM3)*OMultiplier
team2_OppFGM3 <- max(game$LOppFGM3)*DMultiplier

## free throws made
team1_FTM <- max(game$WFTM)*OMultiplier
team1_OppFTM <- max(game$WOppFTM)**DMultiplier

team2_FTM <- max(game$LFTM)*OMultiplier
team2_OppFTM <- max(game$LOppFTM)**DMultiplier

## models
trials <- 500000

WFGM2 <- rgamma(trials,team2_OppFGM2+team1_FGM2,team1_games+team2_games)
LFGM2 <- rgamma(trials,team1_OppFGM2+team2_FGM2,team1_games+team2_games)

WFGM3 <- rgamma(trials,team2_OppFGM3+team1_FGM3,team1_games+team2_games)
LFGM3 <- rgamma(trials,team1_OppFGM3+team2_FGM3,team1_games+team2_games)

WFTM <- rgamma(trials,team2_OppFTM+team1_FTM,team1_games+team2_games)
LFTM <- rgamma(trials,team1_OppFTM+team2_FTM,team1_games+team2_games)

model <- data.frame(WFGM2,LFGM2,WFGM3,LFGM3,WFTM,LFTM)
model$WPoints <- (model$WFGM2*2)+(model$WFGM3*3)+(model$WFTM*1)
model$LPoints <- (model$LFGM2*2)+(model$LFGM3*3)+(model$LFTM*1)
model$diff <- (model$WPoints-model$LPoints)

return(model)

}

ModelGenWeighted <- function(data,OWeighting,NSims) {

  OMultiplier <- 1+OWeighting
  DMultiplier <- 1-OWeighting

## winning stats for points made
WGames <- max(data$WGames)

 WFGM <- sum(data$WFGM)*OMultiplier
 WFGM3 <- sum(data$WFGM3)*OMultiplier
 WFGM2 <- (WFGM-WFGM3)*OMultiplier
 WFTM <- sum(data$WFTM)*OMultiplier

 ## winning points afford
 WOppFGM <- sum(data$WOppFGM)*DMultiplier
 WOppFGM3 <- sum(data$WOppFGM3)*DMultiplier
 WOppFGM2 <- WOppFGM-WOppFGM3*DMultiplier
 WOppFTM <- sum(data$WOppFTM)*DMultiplier

 WMeanDiff <- max(data$WmeanDiffPoints)
 WSDDiff <- max(data$WsdDiffPoints)

 ## losing stats scored
 LGames <- max(data$LGames)

 LFGM <- sum(data$LFGM)*OMultiplier
 LFGM3 <- sum(data$LFGM3)*OMultiplier
 LFGM2 <- (LFGM-LFGM3)*OMultiplier
 LFTM <- sum(data$LFTM)

 ## losing stats yes
 LOppFGM <- sum(data$LOppFGM)*DMultiplier
 LOppFGM3 <- sum(data$LOppFGM3)*DMultiplier
 LOppFGM2 <- LOppFGM-LOppFGM3*DMultiplier
 LOppFTM <- sum(data$LOppFTM)*DMultiplier

 LMeanDiff <- max(data$LmeanDiffPoints)
 LSDDiff <- max(data$LsdDiffPoints)

 ## generate models
 trials <- NSims

 ## general models with gamma distribution
 WFGM3_posterior = rgamma(trials,(WFGM3+LOppFGM3),(WGames+LGames))
 WFGM3_prior = rgamma(trials,LOppFGM3,LGames)
 WFGM3_likelihood = rgamma(trials,WFGM3,WGames)

 WFGM2_posterior = rgamma(trials,(WFGM2+LOppFGM2),(WGames+LGames))
 WFGM2_prior = rgamma(trials,LOppFGM2,LGames)
 WFGM2_likelihood = rgamma(trials,WFGM2,WGames)

 WFTM_posterior = rgamma(trials,(WFTM+LOppFTM),(WGames+LGames))
 WFTM_prior = rgamma(trials,LOppFTM,LGames)
 WFTM_likelihood = rgamma(trials,WFTM,WGames)


 LFGM3_posterior = rgamma(trials,(LFGM3+WOppFGM3),(WGames+LGames))
 LFGM3_prior = rgamma(trials,WOppFGM3,WGames)
 LFGM3_likelihood = rgamma(trials,LFGM3,LGames)

 LFGM2_posterior = rgamma(trials,(LFGM2+WOppFGM2),(WGames+LGames))
 LFGM2_prior = rgamma(trials,WOppFGM2,WGames)
 LFGM2_likelihood = rgamma(trials,LFGM2,LGames)

 LFTM_posterior = rgamma(trials,(LFTM+WOppFTM),(WGames+LGames))
 LFTM_prior = rgamma(trials,WOppFTM,WGames)
 LFTM_likelihood = rgamma(trials,LFTM,LGames)

 WDiff = rnorm(trials,WMeanDiff,WSDDiff)
 LDiff = rnorm(trials,LMeanDiff,LSDDiff)

 model <- data.frame(WFGM3_posterior,WFGM2_posterior,WFTM_posterior,LFGM3_posterior,LFGM2_posterior,LFTM_posterior,WDiff,LDiff,WFGM3_prior,WFGM3_likelihood,WFGM2_prior,WFGM2_likelihood,LFGM2_likelihood,LFGM2_prior,LFGM3_prior,LFGM3_likelihood,LFTM_prior,LFTM_likelihood,WFTM_prior,WFTM_likelihood,LFTM_prior,LFTM_likelihood)

 model$WPoints <- (WFGM2_posterior*2)+(WFGM3_posterior*3)+(WFTM_posterior*1)
 model$WPoints_prior <- (WFGM2_prior*2)+(WFGM3_prior*3)+(WFTM_prior*1)
 model$WPoints_likelihood <- (WFGM2_likelihood*2)+(WFGM3_likelihood*3)+(WFTM_likelihood*1)

 model$LPoints <- (LFGM2_posterior*2)+(LFGM3_posterior*3)+(LFTM_posterior*1)
 model$LPoints_prior <- (LFGM2_prior*2)+(LFGM3_prior*3)+(LFTM_prior*1)
 model$LPoints_likelihood <- (LFGM2_likelihood*2)+(LFGM3_likelihood*3)+(LFTM_likelihood*1)

 return(model)
}


makePreds <- function(Ngames,Nsims,Weight){

game_list <- tourney %>% sample_n(Ngames,replace=FALSE)

game_list <- unique(game_list$game)

results <- data.frame(game = NA, prob1 = NA)

for (i in game_list) {

 game <- subset(tourney, game == i)
 model <- ModelGenWeighted(game,Weight,Nsims)

 prob1 <- sum(model$WPoints >= model$LPoints)/Nsims

 temp <- data.frame(game=i,prob1)

 results <- rbind(temp,results)

}
results <- subset(results,is.na(prob1) == FALSE)

pred_results <- tourney %>% inner_join(results,by='game') %>% select(Season,WTeamName,LTeamName,WTeamID,LTeamID,prob1)
pred_results <- pred_results %>% left_join(seeds,by=c('WTeamID' = 'TeamID', 'Season' = 'Season')) %>% mutate(WSeed = Seed) %>% select(-Seed)
pred_results <- pred_results %>% left_join(seeds,by=c('LTeamID' = 'TeamID', 'Season' = 'Season')) %>% mutate(LSeed = Seed) %>% select(-Seed)

pred_results <- pred_results %>% mutate(game = row_number())
pred_results$predicted_win <- ifelse(pred_results$prob1 >= .5,1,0)

return(pred_results)
}

seedCleaning <- function(data){
data$WSeed <- substrRight(data$WSeed, 2)
data$WSeed <- str_replace(data$WSeed, 'a','')
data$WSeed <- str_replace(data$WSeed, 'b','')
data$WSeed <- str_remove(data$WSeed, "^0+")
data$WSeed <- as.numeric(data$WSeed)


data$LSeed <- substrRight(data$LSeed, 2)
data$LSeed <- str_replace(data$LSeed, 'a','')
data$LSeed <- str_replace(data$LSeed, 'b','')
data$LSeed <- str_remove(data$LSeed, "^0+")
data$LSeed <- as.numeric(data$LSeed)



data$MinSeed <- apply(data[,c(8:9)], 1, min, na.rm = TRUE)
data$MaxSeed <- apply(data[,c(8:9)], 1, max, na.rm = TRUE)

data$matchup <- paste(data$MinSeed,', ',data$MaxSeed,sep='')

return(data)
}
