library(xml)

start = '2018-04-01'
end = '2018-07-11'

dates2urls <- function(first.day, last.day) {
  prefix = 'http://gd2.mlb.com/components/game/mlb/';
  suffix = '/epg.xml';
  dates <- seq(as.Date(first.day), as.Date(last.day), by = "day");
  paste0(prefix,"year_", format(dates, "%Y"), "/month_",
         format(dates, "%m"), "/day_", format(dates, "%d"),suffix);
}

urls=dates2urls(start, end);

gamepk = NULL;
first_pitch = NULL;

for(i in 1:length(urls)){
  url = urls[i];
  xml = xmlParse(url);
  games = xmlToList(xml);
  for(j in 1:(length(games) - 1)){
    gamepk = c(gamepk, (as.numeric(as.character(list[[j]][[2]][[5]]))));
    first_pitch = c(first_pitch, gsub("/", "-", list[[j]][[2]][[6]]));
  }  
}

gametimes = data.table(gamepk, first_pitch);
