module AnalyzeLogs where

import           Data.CSV.Table
import           Text.CSV
import qualified Data.List as L
import           System.Directory (getDirectoryContents)
import           Data.Function (on)
import           System.FilePath

--------------------------------------------------------------------------------
collateDir :: FilePath -> FilePath -> IO Table
--------------------------------------------------------------------------------
collateDir dir f = do
  ts      <- mapM load =<< dirCsvs dir
  let ts'  = fst <$> L.sortBy (compare `on` snd) ts
  let t    = transform ts'
  toFile f t
  return t

dirCsvs :: FilePath -> IO [FilePath]
dirCsvs dir = do
  fs      <- getDirectoryContents dir
  return [dir </> f | f <- fs, ".csv" `L.isSuffixOf` f]

-- | Usage:
--      ghci> collate ["summary-1.csv", "summary-2.csv", ... , "summary-n.csv"] "out.csv"
--------------------------------------------------------------------------------
collate :: [FilePath] -> FilePath -> IO Table
--------------------------------------------------------------------------------
collate fs f = do
  ts    <- mapM load fs
  let t  = transform (fst <$> ts)
  toFile f t
  return t

--------------------------------------------------------------------------------
load :: FilePath -> IO (Table, TimeStamp)
--------------------------------------------------------------------------------
load f = mkTable f <$> readFile f

type TimeStamp  = String

mkTable :: FilePath -> String -> (Table, TimeStamp)
mkTable f s = (tab, stamp)
  where
    tab     = fromString f $ unlines (hdr : body)
    hdr     = "test, time-" ++ stamp ++ ",result"
    body    = drop 6 ls
    stamp   = drop 17 (ls !! 2)
    ls      = lines s

--------------------------------------------------------------------------------
transform :: [Table] -> Table
--------------------------------------------------------------------------------
transform = sortBy rngC FInt Dsc
          . addRange
          . foldr1 join
          . map hideResult

hideResult :: Table -> Table
hideResult t = hide t [C "result"]

addRange :: Table -> Table
addRange = newColumn rngC range

rngC :: Col
rngC = C "range"

range :: RowInfo -> Field
range cvs = show $ truncate (hi - lo)
  where
    vs    = [ read v :: Double | (C c, v) <- cvs, "time-" `L.isInfixOf` c ]
    lo    = minimum vs
    hi    = maximum vs
