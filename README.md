# README

This repository contains scripts for analyzing liquidhaskell log files in order
to detect performance regresssions. To use it:

```
stack ghci src/Main.hs

ghci> collate ["logs/summary-develop.csv", "logs/summary-developgraph.csv", "logs/summary-developgraph-eliminate.csv"] "logs/out.csv"
```

will produce `logs/out.csv` which 

1. *joins* the times from each run,
2. *orders* the benchmarks by the range of running times.

The example `logs/out.csv` is pretty self-explanatory.

