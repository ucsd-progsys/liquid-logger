# README

## Usage 

This repository contains scripts for analyzing liquidhaskell log files in order
to detect performance regresssions. To use it:

```
$ stack ghci

ghci> collateDir "logs" "logs/out/out.csv" 
```

will produce `logs/out/out.csv` which 

1. *joins* the times from each run,
2. *orders* the benchmarks by the range of running times.

The example is pretty self-explanatory.

It is trivial to open the resulting `out.csv` in your favorite spreadsheet to
plot graphs, look for anomalies etc.
