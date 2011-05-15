--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
module TodoConfig where

import Control.Monad(unless)
import System.Directory



prepConfig :: String -> String -> IO FilePath
prepConfig home uuid = do dir <- createDir (home ++ "/.todo")
                          createDir (dir ++ "/" ++ uuid) 


createDir :: FilePath -> IO FilePath
createDir path = do isDir <- doesDirectoryExist path
                    unless isDir $ createDirectory path
                    return path
