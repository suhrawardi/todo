--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
import System.Environment
import Database.HDBC
import Database.HDBC.Sqlite3

 
-- | 'main' runs the main program
main :: IO ()
main = do s <- getArgs
          if s == [] 
            then putStrLn "empty!"
            else case head s of
                      "add"  -> addTask
                      "list" -> putStrLn "Oh no!\nNothing there yet."
                      _      -> putStrLn "Plainly wrong"

 
addTask :: IO ()
addTask = do putStrLn "Add a task:"
             t <- getLine
             putStrLn (haqify t)


haqify :: String -> String
haqify s = "Haq! " ++ s
