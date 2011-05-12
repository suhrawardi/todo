--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
import System.Environment
 
-- | 'main' runs the main program
main :: IO ()
main = do s <- getArgs
          putStrLn (haqify (head s))
 
haqify :: String -> String
haqify s = "Haq! " ++ s
