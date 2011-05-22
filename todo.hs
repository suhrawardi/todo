--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
import System.Environment
import Database.HDBC
import Database.HDBC.Sqlite3

import TodoDB
import TodoConfig


 
-- | 'main' runs the main program
main :: IO ()
main = do args <- getArgs
          home <- getEnv "HOME"
          dir <- prepConfig home
          dbh <- getDBHandle (getDBFp dir)
          case args of
              ("add":_)  -> addTask dbh

              ("list":_) -> putStrLn "Not implemented yet!"

              _          -> putStrLn . unlines $
                            [ "usage:"
                            , "\ttodo add"
                            , "\ttodo list"
                            ]
              

 
addTask :: Connection -> IO ()
addTask dbh = do putStrLn "Add a task:"
                 task <- getLine
                 i <- addTaskToDB dbh task
                 putStrLn (show i ++ " tasks added to the to do list!")
