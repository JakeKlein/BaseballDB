loader<-function(package){
  tryCatch(
    {
    if(suppressWarnings(!require(package,character.only = TRUE,quietly = TRUE))){
      print(paste(package,"not installed",sep=" "));
      print(paste("Will install:",package,sep=" "));
      install.packages(package,quiet=TRUE);
      require(package,character.only=TRUE)
    }
    else{
      require(package,character.only=TRUE,quietly = TRUE)
    }
  },
  error=function(cond){
    message('Must input package name in quotation marks {""}')
  }
  )
}

  