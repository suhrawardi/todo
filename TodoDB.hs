--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
module TodoDB where

import Database.HDBC
import Database.HDBC.Sqlite3
 


createTable :: Connection -> String -> String -> IO ()
createTable dbh table query = do run dbh query []
                                 commit dbh
                                 putStrLn msg
                              where tables = getTables dbh
                                    msg = ("Creating table '" ++ table ++ "'\
                                           \: ok")

               
getDbHandle :: IO Connection
getDbHandle = do dbh <- connectSqlite3 ("." ++ uuid ++ ".db")
                 createTable dbh "tasks" q
                 return dbh
              where q = "CREATE TABLE tasks (\
                        \ id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                        \ task TEXT NOT NULL)"
                    uuid = "712df98a-7ed6"
