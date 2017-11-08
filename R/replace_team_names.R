pitchfx_teams=c("chamlb","miamlb","wasmlb","anamlb","detmlb","nyamlb","tbamlb","phimlb","cinmlb","kcamlb","oakmlb","milmlb","arimlb",
                "seamlb","colmlb","sdnmlb","atlmlb","balmlb","clemlb","texmlb","chnmlb","minmlb","houmlb","slnmlb",
                "bosmlb","lanmlb","nynmlb","tormlb","sfnmlb","pitmlb")

statcast_teams=c("CWS","MIA","WAS","LAA","DET","NYM","TB","PHI","CIN","KC","OAK","MIL","ARI",
                "SEA","COL","SDN","ATL","BAL","CLE","TES","CHC","MIN","HOU","STL",
                "BOS","LAD","NYY","TOR","SF","PIT")

replace_team_names<-function(name,verbose=FALSE){
  index=match(name,pitchfx_teams);
  name=statcast_teams[index];
  if(verbose==TRUE){
    print(name)
  }
  invisible(name)
}
