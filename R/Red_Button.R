red_button<-function(input='no'){
  input=as.character(input)
  if(input=='yes'){
    if(file.exists("pitchfx.sqlite3"))file.remove("pitchfx.sqlite3");
    print("You have pushed the red button");
    print("This console will self destruct");
  }
  if(input=='yes')rm(list=ls(envir=.GlobalEnv),envir = .GlobalEnv)
}
