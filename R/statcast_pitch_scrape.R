statcast_pitch_scrape=function(start_date,stop_date){
  start=as.Date(start_date);
  stop=as.Date(stop_date);
  if(stop>start+5){
    data=statcast_scrape_pitching_single(as.character(start),as.character(start+5))
  }
  else{
    data=statcast_scrape_pitching_single(as.character(start),as.character(stop))
  }
  start=start+6
  while (start<stop){
    data=rbind2(data,statcast_scrape_pitching_single(as.character(start),as.character(start+5)))
    start=start+6
  }
  return(unique(data))
}