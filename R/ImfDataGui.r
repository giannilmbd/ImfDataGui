
#' Retrieve data from IMF (IFS)
#'
#' @param varname Name to be given to output (panel)
#' @param series Keyword(s) to search IFS dataset
#' @param startdate Starting date of series
#' @param enddate End date of series
#'
#' @return panel data in data.frame format
#' @export
#'
#' @examples
#'#' ImfDataGui(varname="gdp",series='Gross Domestic Product',startdate='1980-01-01',enddate='2016-12-31')
#'
ImfDataGui<-function(varname="gdp",series='Gross Domestic Product',
                         startdate='1980-01-01',
                         enddate='2016-12-31'){
  IFS.available.codes <- DataStructureMethod('IFS')
  names(IFS.available.codes)
  code_val_txt<-IFS.available.codes[[3]]
  sersel<-grep(series,code_val_txt$CodeText,ignore.case = F)#
  listed<-code_val_txt$CodeText[sersel]
  databaseID <-'IFS'
  checkquery = F
  w <- gwindow(paste("IMF data ",varname,sep=""))
  gp <- ggroup(container=w)
  glabel(series, container=gp)
  f <- function(h,...) selected<-grep(svalue(h$obj),listed)

  cb <- gcombobox(listed, editable=T, container=gp, handler=f)
  merge_series<-function(tmpval=gdp){
    R<-tmpval$Obs
    # for(jj in length(Y)){colnames(Y[[jj]])<-gsub("@","",colnames(Y[[1]]))}
    for(jj in c(1:length(R))){colnames(R[[jj]])<-c("quarter",tmpval$'@REF_AREA'[jj])}
    # mearge data
    name<-as.data.frame(R[[1]][,1:2])
    for(jj in c(2:length(R))){name<-merge(name, R[[jj]][,1:2], all = TRUE, by = c('quarter'))}
    return(name)
  }

  group <- ggroup(horizontal=FALSE,container = w)
  button.group <- ggroup(container = group )
  handler=function(h,...) {
    selected<-svalue(cb)
    print('SELECTED SERIES')
    print(selected)
    selected<-grep(svalue(cb),listed)
    # print(selected)
    assign("selected",grep(svalue(cb),listed),envir = .GlobalEnv)
    tmp0<-code_val_txt$CodeValue[sersel[selected]]
    # tmp<-CodeSearch(IFS.available.codes,'CL_INDICATOR_IFS',tmp0)
    print("DATA IMF CODE")
     print(tmp0)
    queryfilter <- list(CL_FREA="Q", CL_AREA_IFS="", CL_INDICATOR_IFS =c( tmp0))
    tmpval <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery)
    ser<-merge_series(tmpval)
    # GET PANEL ---------------------------------------------------------------
    df<-melt(ser,id='quarter',variable.names=('cc'))
    df$value<-as.numeric(df$value)
    names(df)<-c('date','cc',varname)
    df<-df[order(as.character(df[,"cc"])),]
    assign(varname, df,envir=.GlobalEnv)
    ## In this instance dispose finds its parent window and closes it
    # dispose(h$obj) NO NEED TO CLOSE IT
  }
  ## Push buttons to right
  addSpring(button.group)
  gbutton("ok", handler=handler, container=button.group)

  gbutton("cancel", handler = function(h,...) dispose(h$obj),container=button.group)

  return();
}
