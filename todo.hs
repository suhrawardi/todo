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
main = do s <- getArgs
          home <- getEnv "HOME"
          dir <- prepConfig home "2d97cca2"
          dbh <- getDBHandle (getDBFp dir)
          if s == [] 
            then putStrLn "empty!"
            else case head s of
                      "add"  -> addTask dbh
                      "list" -> putStrLn "Oh no!\nNothing there yet."
                      _      -> putStrLn "Plainly wrong"

 
addTask :: Connection -> IO ()
addTask dbh = do putStrLn "Add a task:"
                 t <- getLine
                 putStrLn (t ++ " added to the to do list!")
