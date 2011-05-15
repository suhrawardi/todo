--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
module TodoDB where

import Database.HDBC
import Database.HDBC.Sqlite3
import Control.Monad(when)
 


createTable :: Connection -> String -> String -> IO ()
createTable dbh table query = do tables <- getTables dbh
                                 when ("tasks" `notElem` tables) $
                                     do putStr msg
                                        run dbh query []
                                        putStrLn "ok" 
                                 commit dbh
                              where msg = "Creating table '" ++ table ++ "': "


addTaskToDB :: Connection -> String -> IO Integer
addTaskToDB dbh text = run dbh query [toSql text]
                       where query = "INSERT INTO tasks VALUES (NULL, ?)"

               
prepDB :: Connection -> IO ()
prepDB dbh = createTable dbh "tasks" q
             where q = "CREATE TABLE tasks (\
                       \ id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                       \ task TEXT NOT NULL)"

               
getDBHandle :: FilePath -> IO Connection
getDBHandle fp = do dbh <- connectSqlite3 fp
                    prepDB dbh
                    return dbh

               
getDBFp :: FilePath -> FilePath
getDBFp dir = dir ++ "/data.db"
