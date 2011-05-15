--
-- Copyright (c) 2011 Jarra <suhrawardi@gmail.com>
-- GPL version 2 or later (see http://www.gnu.org/copyleft/gpl.html)
--
module TodoConfig where

import Control.Monad(unless)
import System.Directory
import Data.UUID
import Data.UUID.V1



getUUIDString :: IO String
getUUIDString = do nuuid <- nextUUID
                   case nuuid of
                        Nothing    -> return uuid
                                      where uuid = "default"
                        Just nuuid -> return uuid
                                      where uuid = (toString nuuid)


prepConfig :: String -> IO FilePath
prepConfig home = do dir <- createDir (home ++ "/.todo")
                     uuid <- getProfile (dir ++ "/default.profile")
                     createDir (dir ++ "/" ++ uuid) 


getProfile :: FilePath -> IO String
getProfile path = do isFile <- doesFileExist path
                     if isFile
                       then readFile path
                       else do uuid <- getUUIDString
                               writeFile path uuid
                               return uuid


createDir :: FilePath -> IO FilePath
createDir path = do isDir <- doesDirectoryExist path
                    unless isDir $ createDirectory path
                    return path
