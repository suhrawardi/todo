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


updateTaskStatus :: Connection -> String -> String -> IO Integer
updateTaskStatus dbh id text = do i <- run dbh query [toSql text, toSql id]
                                  commit dbh
                                  return i
                               where query = " UPDATE tasks SET status = ? \
                                             \ WHERE id = ?"


addTaskToDB :: Connection -> String -> String -> IO Integer
addTaskToDB dbh task desc = do i <- run dbh query [ toSql task
                                                  , toSql desc
                                                  , toSql "b"
                                                  ]
                               commit dbh
                               return i
                            where query = " INSERT INTO tasks VALUES\
                                          \ (NULL, ?, ?, ?, NULL,\
                                          \  DATETIME('now'), NULL, NULL)"


getTasks :: Connection -> String -> IO ()
getTasks dbh status = do r <- quickQuery' dbh
                              " SELECT id, task FROM tasks\
                              \ WHERE status = ? ORDER BY id"
                              [toSql status]
                         let stringRows = map convShortRow r
                         mapM_ putStrLn stringRows


getTask :: Connection -> String -> IO ()
getTask dbh id = do r <- quickQuery' dbh
                         " SELECT id, task, description FROM tasks\
                         \ WHERE id = ?"
                         [toSql id]
                    let stringRows = map convFullRow r
                    mapM_ putStrLn stringRows


convFullRow :: [SqlValue] -> String
convFullRow [sqlId, sqlTask, sqlDesc] = show i ++ ") " ++ t ++ "\n:\t" ++ d
                                        where i = fromSql sqlId::Integer
                                              t = fromMaybe "" (fromSql sqlTask)
                                              d = fromMaybe "" (fromSql sqlDesc)
convFullRow x                         = fail $ "Unexpected result: " ++ show x


convShortRow :: [SqlValue] -> String
convShortRow [sqlId, sqlTask] = show i ++ ") " ++ t
                                where i = fromSql sqlId::Integer
                                      t = fromMaybe "" (fromSql sqlTask)
convShortRow x                = fail $ "Unexpected result: " ++ show x

               
-- status can be b(acklog), w(ip) or d(one).
prepDB :: Connection -> IO ()
prepDB dbh = createTable dbh "tasks" q
             where q = "CREATE TABLE tasks ( \
                       \ id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                       \ task TEXT NOT NULL,\
                       \ description TEXT NOT NULL,\
                       \ status VARCHAR(1) NULL,\
                       \ position INTEGER,\
                       \ added_at DATETIME,\
                       \ started_at DATETIME,\
                       \ finished_at DATETIME )"

               
getDBHandle :: FilePath -> IO Connection
getDBHandle fp = do dbh <- connectSqlite3 fp
                    prepDB dbh
                    return dbh

               
getDBFp :: FilePath -> FilePath
getDBFp dir = dir ++ "/data.db"
