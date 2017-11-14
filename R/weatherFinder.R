loader(data.table)

weatherFinder = function(station, gamedate){
  url = paste0('https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py?',
    'station=', station,
    '&data=all&year1=', year(gamedate),
    '&month1=', month(gamedate),
    '&day1=', mday(gamedate),
    '&year2=', year(gamedate),
    '&month2=', month(gamedate),
    '&day2=', mday(gamedate),
    '&tz=Etc%2FUTC&format=onlycomma&latlon=no&direct=no&report_type=1&report_type=2');
  vars = c('station', 'valid', 'tmpf', 'relh', 'alti');
  colnames = c('station', 'time', 'tempf', 'humidity', 'pressure');
  data = fread(url, sep = ",", header = TRUE,verbose=FALSE,showProgress = FALSE)[tmpf!='M'][,..vars];
  colnames(data) = colnames;
  return(data[,time_dif:=abs(as.POSIXct(time)-gamedate)][which.min(time_dif)])
}

