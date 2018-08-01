###Load Libraries
require(devtools)
install_github("JakeKlein/BaseballDB")
require(baseballDB)
loader("dplyr"); loader("dbplyr"); loader("lubridate"); loader("tidyr"); 
loader("reldist"); loader("XML"); loader("xml2"); loader("magrittr")
###Functions

red_button() ### enter 'yes' as input to delete entire environment and restart your work


###Initialize
initialize=1 #set to 1 if building database, 0 if updating
start="2015-04-02"
stop="2015-10-01"

###Collect Statcast Pitching Data
statcast_pitching=data.table(statcast_pitch_scrape(start,stop))

statcast_pitching_columns=c("game_pk","at_bat_number","pitch_number","pitch_type","game_date","release_speed","release_pos_x","release_pos_z","release_pos_y","player_name","batter","pitcher",
                            "events","description","zone","game_type","stand","p_throws","home_team","away_team","type", "home_score", "away_score",
                            "hit_location","bb_type","balls","strikes","game_year","pfx_x", "pfx_z", "plate_x","plate_z","on_1b","on_2b","on_3b","outs_when_up",
                            "inning","inning_topbot","hc_x","hc_y","sv_id","sz_top","sz_bot","hit_distance_sc","launch_speed","launch_angle",
                            "effective_speed","release_spin_rate","release_extension","pos1_person_id","pos2_person_id","pos3_person_id",
                            "pos4_person_id","pos5_person_id","pos6_person_id","pos7_person_id","pos8_person_id","pos9_person_id","woba_value",
                            "woba_denom","babip_value","iso_value", "vx0", "vy0", "vz0", "ax", "ay", "az")

statcast_pitching_col_names=c("gameid","eventseq","pitchseq","pitch_type","gamedate","velocity","rel_x","rel_z","rel_y","pitcher_name","batterid","pitcherid",
                              "event","description","gameday_zone","game_type","batter_hand","pitcher_throws","home_team","away_team","pitch_result",  "home_score", "away_score",
                              "bipfielderpos","batted_ball_type","balls","strikes","yearid","breakx_statcast","breakz_statcast","plate_x","plate_z","runneron_1b","runneron_2b","runneron_3b","outs",
                              "inning","istop","bip_x","bip_y","statcastid","sz_top","sz_bot","hit_distance","launch_speed","launch_angle",
                              "perceived_velocity","spinrate","extension","pos1_id","pos2_id","pos3_id","pos4_id","pos5_id","pos6_id","pos7_id","pos8_id","pos9_id",
                              "woba_value","pa","babip_value","iso_value", "vx0", "vy0", "vz0", "ax", "ay", "az")

statcast<-statcast_pitching[,..statcast_pitching_columns]
colnames(statcast)<-statcast_pitching_col_names


statcast<-unique(statcast)


pitchgames<-pitching[,list(first_pitch=as.POSIXct(min(gametime,na.rm=TRUE),tz="UTC")),by=c("gameid","home_team","away_team")]




###Collect Batter Names
statcast_hitting=data.table(statcast_hit_scrape(start,stop))

statcast_hitting_columns=c("game_pk","at_bat_number","pitch_number","player_name","batter","sz_top","sz_bot","pitch_type")
statcast_hitting_col_names=c("gameid","eventseq","pitchseq","batter_name","batterid","sz_top","sz_bot","pitch_type")

statcast_hit<-statcast_hitting[,..statcast_hitting_columns]
colnames(statcast_hit)=statcast_hitting_col_names
statcast_hit$eventseq[statcast_hit$gameid==415327 & statcast_hit$eventseq>66]=statcast_hit$eventseq[statcast_hit$gameid==415327 & statcast_hit$eventseq>66]-1
statcast_hit$eventseq[statcast_hit$gameid==414189 & statcast_hit$eventseq>76]=statcast_hit$eventseq[statcast_hit$gameid==414189 & statcast_hit$eventseq>76]-1
statcast_hit$eventseq[statcast_hit$gameid==414793 & statcast_hit$eventseq>34]=statcast_hit$eventseq[statcast_hit$gameid==414793 & statcast_hit$eventseq>34]-1

all_data=merge(pitching,statcast_hit,by.x=c("gameid","eventseq","pitchseq","batterid","sz_top.x","sz_bot.x","pitch_type"),by.y=c("gameid","eventseq","pitchseq","batterid","sz_top","sz_bot","pitch_type"),all.x='True')
all_data=unique(all_data)


###Split into tables

#Games
game_cols=c('gameid', 'yearid','game_type','gametime',"gamedate","home_team","away_team")
games<-unique(all_data[eventseq==1 & pitchseq==1,..game_cols])
colnames(games)=c('gameid', 'yearid','game_type','first_pitch',"gamedate","home_team","away_team")

#Players
pitcher_cols=c("pitcherid", "pitcher_name", "pitcher_throws")
batter_cols=c("batterid", "batter_name", "batter_hand")

pitchers<-unique(all_data[,..pitcher_cols])
pitchers[,switch:=length(levels(as.factor(pitcher_throws))),by=c("pitcherid","pitcher_name")]
pitchers$pitcher_throws[pitchers$switch==2]="B";pitchers$switch=NULL
pitchers<-unique(pitchers)

batter<-unique(all_data[,..batter_cols])
batter[,switch:=length(levels(as.factor(batter_hand))),by=c("batterid","batter_name")]
batter$batter_hand[batter$switch==2]="B";batter$switch=NULL
batter<-unique(batter)

#Events
event_cols<-c('gameid', 'yearid', 'eventseq', 'batterid', 'pitcherid', 'event', 'batted_ball_type',
              'bipfielderpos','batter_hand', 'pitcher_throws', 'inning', 'istop', 'outs', 'score',
              'home_runs','away_runs','event1','event2','event3','')
































