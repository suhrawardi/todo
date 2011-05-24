--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
module TodoDB where

import Database.HDBC
import Database.HDBC.Sqlite3
import Control.Monad(when)
import Data.Maybe
 


createTable :: Connection -> String -> String -> IO ()
createTable dbh table query = do tables <- getTables dbh
                                 when ("tasks" `notElem` tables) $
                                     do putStr msg
                                        run dbh query []
                                        putStrLn "ok" 
                                 commit dbh
                              where msg = "Creating table '" ++ table ++ "': "


addTaskToDB :: Connection -> String -> IO Integer
addTaskToDB dbh text = do i <- run dbh query [toSql text, toSql "b"]
                          commit dbh
                          return i
                       where query = "INSERT INTO tasks VALUES (NULL, ?, ?)"


getTasks :: Connection -> String -> IO ()
getTasks dbh status = do r <- quickQuery' dbh
                              " SELECT id, task FROM tasks\
                              \ WHERE status = ? ORDER BY id"
                              [toSql status]
                         let stringRows = map convRow r
                         mapM_ putStrLn stringRows
                      where convRow :: [SqlValue] -> String
                            convRow [sqlId, sqlTask] =
                                show i ++ "), " ++ t
                                where i = fromSql sqlId::Integer
                                      t = fromMaybe "NULL" (fromSql sqlTask)
                            convRow x = fail $ "Unexpected result: " ++ show x

               
-- status can be b(acklog), w(ip) or d(one).
prepDB :: Connection -> IO ()
prepDB dbh = createTable dbh "tasks" q
             where q = "CREATE TABLE tasks (\
                       \ id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                       \ task TEXT NOT NULL,\
                       \ status VARCHAR(1) NULL)"

               
getDBHandle :: FilePath -> IO Connection
getDBHandle fp = do dbh <- connectSqlite3 fp
                    prepDB dbh
                    return dbh

               
getDBFp :: FilePath -> FilePath
getDBFp dir = dir ++ "/data.db"
