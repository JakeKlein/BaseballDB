#' Query Statcast and PITCHf/x Data for All Batters from baseballsavant.mlb.com
#' Code Provided by baseballr written by Bill Petti
#'
#' This function allows you to query Statcast and PITCHf/x data as provided on baseballsavant.mlb.com and have that data returned as a dataframe. Query returns data for all batters over a given time frame.
#' @param start_date Date of first game for which you want data. Format must be in Y-d-m format.
#' @param end_date Date of last game for which you want data. Format must be in Y-d-m format.
#' @keywords MLB, sabermetrics, Statcast
#' @importFrom utils read.csv
#' @export
#' @examples
#' \dontrun{
#' scrape_statcast_savant_batter_all(start_date = "2016-04-06", end_date = "2016-04-15")
#' }
loader("dplyr");loader("data.table")
scrape_statcast_savant_batter_all <- function(start_date, end_date) {
  # Check to make sure args are in the correct format.
  if(!is.character(start_date) | !is.character(end_date)) {
    warning("Please wrap your dates in quotations in 'yyyy-mm-dd' format.")
    return(NULL)
  }
  # Check for other user errors.
  if(as.Date(start_date)<="2015-03-01") { # March 1, 2015 was the first date of Spring Training.
    message("Some metrics such as Exit Velocity and Batted Ball Events have only been compiled since 2015.")
  }
  if(as.Date(start_date)<="2008-03-25") { # March 25, 2008 was the first date of Spring Training.
    stop("The data are limited to the 2008 MLB season and after.")
    return(NULL)
  }
  if(as.Date(start_date)==Sys.Date()) {
    message("The data are collected daily at 3 a.m. Some of today's games may not be included.")
  }
  if(as.Date(start_date)>as.Date(end_date)) {
    stop("The start date is later than the end date.")
    return(NULL)
  }

  # extract season from start_date

  year <- substr(start_date, 1,4)

  # Base URL.
  url <- paste0("https://baseballsavant.mlb.com/statcast_search/csv?all=true&hfPT=&hfAB=&hfBBT=&hfPR=&hfZ=&stadium=&hfBBL=&hfNewZones=&hfGT=R%7CPO%7CS%7C&hfC=&hfSea=", year, "%7C&hfSit=&player_type=batter&hfOuts=&opponent=&pitcher_throws=&batter_stands=&hfSA=&game_date_gt=",start_date,"&game_date_lt=",end_date,"&team=&position=&hfRO=&home_road=&hfFlag=&metric_1=&hfInn=&min_pitches=0&min_results=0&group_by=name&sort_col=pitches&player_event_sort=h_launch_speed&sort_order=desc&min_abs=0&type=details&")

  # Do a try/catch to show errors that the user may encounter while downloading.
  tryCatch(
    {
      print("These data are from BaseballSevant and are property of MLB Advanced Media, L.P. All rights reserved.")
      print("Grabbing data, this may take a minute...")
      payload <- data.table::fread(url,verbose=FALSE,showProgress = FALSE)

    },
    error=function(cond) {
      message(paste("URL does not seem to exist, please check your Internet connection:"))
      message("Original error message:")
      message(cond)
      return(NA)
    },
    warning=function(cond) {
      message(paste("URL caused a warning. Make sure your date range is correct:"))
      message("Original warning message:")
      message(cond)
      return(NULL)
    }
  )
  # Clean up formatting.
  payload[payload=="null"] <- NA
  payload$game_date <- as.Date(payload$game_date, "%Y-%m-%d")
  payload$des <- as.character(payload$des)
  payload$game_pk <- as.character(payload$game_pk) %>% as.integer()
  payload$at_bat_number <- as.character(payload$at_bat_number) %>% as.integer()
  payload$pitch_number <- as.character(payload$pitch_number) %>% as.integer()
  payload$on_1b <- as.character(payload$on_1b) %>% as.integer()
  payload$on_2b <- as.character(payload$on_2b) %>% as.integer()
  payload$on_3b <- as.character(payload$on_3b) %>% as.integer()
  payload$release_pos_x <- as.character(payload$release_pos_x) %>% as.numeric()
  payload$release_pos_z <- as.character(payload$release_pos_z) %>% as.numeric()
  payload$release_pos_y <- as.character(payload$release_pos_y) %>% as.numeric()
  payload$hit_distance_sc <- as.character(payload$hit_distance_sc) %>% as.numeric()
  payload$launch_speed <- as.character(payload$launch_speed) %>% as.numeric()
  payload$launch_angle <- as.character(payload$launch_angle) %>% as.numeric()
  payload$effective_speed <- as.character(payload$effective_speed) %>% as.numeric()
  payload$release_spin_rate <- as.character(payload$release_spin_rate) %>% as.numeric()
  payload$release_speed <- as.character(payload$release_speed) %>% as.numeric()
  payload$release_extension <- as.character(payload$release_extension) %>% as.numeric()
  payload$pfx_x<-as.character(payload$pfx_x) %>% as.numeric()
  payload$pfx_z<-as.character(payload$pfx_z) %>% as.numeric()
  payload$plate_x<-as.character(payload$plate_x) %>% as.numeric()
  payload$plate_z<-as.character(payload$plate_z) %>% as.numeric()
  payload$sz_top<-as.character(payload$sz_top) %>% as.numeric()
  payload$sz_bot<-as.character(payload$sz_bot) %>% as.numeric()
  payload$hc_x<-as.character(payload$hc_x) %>% as.numeric()
  payload$hc_y<-as.character(payload$hc_y) %>% as.numeric()
  payload$barrel <- with(payload, ifelse(launch_angle <= 50 & launch_speed >= 98 & launch_speed * 1.5 - launch_angle >= 11 & launch_speed + launch_angle >= 124, 1, 0))
  message("URL read and payload acquired successfully.")

  return(payload)

}
