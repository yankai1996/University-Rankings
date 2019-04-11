# University-Rankings
Best global universities in the world.

### Data

1. [QS World University Rankings 2019 | Top Universities](https://www.topuniversities.com/university-rankings/world-university-rankings/2019)
2. [World University Rankings 2019 | Times Higher Education (THE)](https://www.timeshighereducation.com/world-university-rankings/2019/world-ranking)
3. [ARWU World University Rankings 2018 | Academic Ranking of World Universities 2018](http://www.shanghairanking.com/ARWU2018.html)



### Procedure

1. Run `excel2sas.sas` which imports the source `excel/rankings.xlsx` and outputs `qs2019.sas7bdat`, `the2019.sas7bdat`, and `arwu2018.sas7bdat`. 
2. Run `python3 match.py`. This will generate two files `qs_the.csv` and `qs_arwu.csv`. Each of them links two ranking tables together.
3. Run `merge_rank.sas` which merges the above two `.csv` files.