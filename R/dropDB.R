#' dropDB function
#' @param db1 db2 db3 db4 db5
#' return delete db table from sql server

dropDB <- function(db1,db2,db3,db4,db5)
{
  a <- dbConnect(dbDriver("MySQL"),
                 dbname=db1,
                 user=db2,
                 password=db3,
                 host=db4,
                 port=db5)
  dbSendQuery(a, 'set character set "euckr"')
  b0 <- dbListTables(a)[menu(dbListTables(a),graphics=T,title="삭제할 테이블을 고르세요")]
  if(askYesNo(msg=paste0(b0,"테이블을 정말 삭제하시겠습니까?"))==TRUE) {
    dbSendQuery(a,paste0("drop table ",b0,""))
    message(paste0(b0," 테이블을 삭제했습니다."))
  } else{
    stop("테이블 삭제 작업을 중단합니다")
  }
  dbDisconnect(a)
}
