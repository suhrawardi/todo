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
              ("add":task:_)    -> addTask dbh task

              ("add":_)         -> do putStrLn "Add a task:"
                                      task <- getLine
                                      addTask dbh task

              ("list":status:_) -> listTasks dbh status

              _                 -> putStrLn . unlines $
                                   [ "usage:"
                                   , "\ttodo add [task]"
                                   , "\ttodo list (backlog|wip|done)"
                                   ]

 
addTask :: Connection -> String -> IO ()
addTask dbh task = do i <- addTaskToDB dbh task
                      putStrLn (show i ++ " tasks added to the to do list!")


listTasks :: Connection -> String -> IO ()
listTasks dbh status = case status of
                           "backlog" -> do putStrLn "Showing backlog"
                                           getTasks dbh "b"
                           "wip"     -> do putStrLn "Showing WIP"
                                           getTasks dbh "w"
                           "done"    -> do putStrLn "Showing work done"
                                           getTasks dbh "d"
