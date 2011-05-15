--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
import System.Environment
import Control.Monad(unless)
import System.Directory
import Database.HDBC
import Database.HDBC.Sqlite3

import TodoDB


 
-- | 'main' runs the main program
main :: IO ()
main = do s <- getArgs
          home <- getEnv "HOME"
          dir <- prepConfig home "2d97cca2"
          dbh <- getDBHandle (getDBFp dir "data")
          if s == [] 
            then putStrLn "empty!"
            else case head s of
                      "add"  -> addTask dbh
                      "list" -> putStrLn "Oh no!\nNothing there yet."
                      _      -> putStrLn "Plainly wrong"


prepConfig :: String -> String -> IO FilePath
prepConfig home uuid = do dir <- createDir (home ++ "/.todo")
                          createDir (dir ++ "/" ++ uuid) 


createDir :: FilePath -> IO FilePath
createDir path = do isDir <- doesDirectoryExist path
                    unless isDir $ createDirectory path
                    return path

 
addTask :: Connection -> IO ()
addTask dbh = do putStrLn "Add a task:"
                 t <- getLine
                 putStrLn (t ++ " added to the to do list!")
