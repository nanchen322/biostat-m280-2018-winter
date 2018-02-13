*Nan Chen*

### Overall Grade: 93/100

### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline?

    Yes. `Feb 1, 2018, 3:38 PM PST`.

-   Is the final report in a human readable format html?

    Yes. `html`.

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report?

    Yes.

### Correctness and efficiency of solution: 49/50

-   Q1 (9/10)

    \#2. (-1 pt) **Currently, your repository is public. Make it private.**

-   Q2 (20/20)

    \#2. The following implementation (from Dr. Zhou's solution sketch) is fast as it traverses `bim` file only once. The `uniq` command in Linux is useful for counting but takes longer.

    ``` bash
    time awk '
    {chrno[$1]++;} 
    END{ for (c in chrno) print "chr.", c, "has", chrno[c], "SNPs"}'                                   
    /home/m280-data/hw1/merge-geno.bim
    ```

-   Q3 (20/20)

    \#1. `runSim.R`: Use `rcauchy` for the Cauchy distribution.

### Usage of Git: 10/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch?

    Yes.

-   Are there enough commits? Are commit messages clear?

    Yes.

-   Are the folders (`hw1`, `hw2`, ...) created correctly?

    Yes.

-   Do not put a lot auxillary files into version control.

    Yes.

### Reproducibility: 7/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? (-3 pts)

    - You need to run `Rscript autoSim.R` in `hw1.Rmd` prior to running `outputtable.R`. Make sure your collaborators can easily run your code.

    - Note that in your `hw1.Rmd`, the path `/home/nanchen322/Biostat-m280-2018-winter/hw1/` is unique to your account on the server. Make sure your collaborators can easily run your code. Instead, you may use something like the following for easier reproducibility.

```bash
echo "    2.40  = FILE FORMAT VERSION NUMBER." > mendel_snpdef.txt
echo "8348674  = NUMBER OF SNPS LISTED HERE." >> mendel_snpdef.txt
awk '{OFS = ","} {print $2, $1, $4}' /home/m280-data/hw1/merge-geno.bim >> mendel_snpdef.txt
head mendel_snpdef.txt
```
  
-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

    Not applicable for hw1.

### R code style: 17/20

-   [Rule 3](https://google.github.io/styleguide/Rguide.xml#linelength): Never place more than 80 characters on a line. (-1 pt)

    Some violations:
    -   `autoSim.R`: line 10

-   [Rule 4](https://google.github.io/styleguide/Rguide.xml#indentation): 2 spaces for indenting.

-   [Rule 5](https://google.github.io/styleguide/Rguide.xml#spacing): Place spaces around all binary operators (`=`, `+`, `-`, `<-`, etc.). Exception: Spaces around `=`'s are optional when passing parameters in a function call. (-1 pt)

    Some violations:
    -   `outputtable.R`: line 23-24
    -   `runSim.R`: line 40-41, 44
        -   Need spaces around `-`, `*`, `/`.

-   [Rule 5](https://google.github.io/styleguide/Rguide.xml#spacing): Do not place a space before a comma, but always place one after a comma. (-1 pt)

    Some violations:
    -   `outputtable.R`: line 23-24

-   [Rule 5](https://google.github.io/styleguide/Rguide.xml#spacing): Place a space before left parenthesis, except in a function call. Do not place spaces around code in parentheses or square brackets. Exception: Always place a space after a comma.
