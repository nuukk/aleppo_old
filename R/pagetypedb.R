pagetypedb <- function(name,db1,db2,db3,db4,db5)
{
  a <- dbConnect(dbDriver("MySQL"),
                 dbname=db1,
                 user=db2,
                 password=db3,
                 host=db4,
                 port=db5)
  dbSendQuery(a, 'set character set "euckr"')
  b0 <- dbListTables(a)[menu(dbListTables(a),graphics=T,title="Page Type을 갱신할  테이블을 고르세요")]
  sql_temp <- dbGetQuery(a,paste0("select * from ",b0,""))
  dbWriteTable(a,paste0('backup_',b0,"_",gsub("-|:| ","_",Sys.time())),sql_temp,append=TRUE,row.names=F,overwrite=F)
  sql_temp <- sql_temp %>% select(-`page type`)
  list_pf <- normalizePath(choose.files(caption="기초정보 파일을 선택하세요"))
  if(length(list_pf)>1) {
    list_pf <- choose.files(caption="기초정보 파일을 다시 선택하세요")
  }
  list_pf <- suppressMessages(read_excel(list_pf,sheet='Page Type'))
  colnames(list_pf) <- list_pf[2,]
  list_pf <- list_pf[-c(1:2),c(4:6)]
  sql_temp <- left_join(sql_temp,list_pf,by=c('url'='URL'))
  export_directory <- choose.dir(caption="파일을 저장할 경로를 지정하세요")
  dbWriteTable(a,b0,sql_temp,row.names=F,overwrite=T)
  dbDisconnect(a)
  if(file.exists(paste0(export_directory,"/",name,".csv"))) {
    write.table(sql_temp,paste0(export_directory,"/",name,".csv"),row.names=F,append=T,col.names=F,sep=",")
  } else {
    write.table(sql_temp,paste0(export_directory,"/",name,".csv"),row.names=F,append=T,col.names=T,sep=",")
  }
}
