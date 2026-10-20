# A Minimal Example

## Setup

First, load the `reproducibleRchunks` package in the first code chunk.
Once the package is loaded, the code chunk type `reproducibleR` is now
available. Your first code chunk will probably look like this:

```` markdown
```{r setup, include = FALSE}
library(reproducibleRchunks)
```
````

## Using reproducible code chunks

Now, you can use reproducibleR chunks like you use normal R code chunks.
For example, let us define some data and run a simple statistical model
in the following code chunk:

```` markdown
```{reproducibleR model1}
x <- 1:6
y <- c(4, 8, 15, 16, 23, 42 )

model <- lm(y~x)
```
````

``` r
x <- 1:6
y <- c(4, 8, 15, 16, 23, 42 )

model <- lm(y~x)
```

###### Code Chunk Reproduction Report

- ✅model: REPRODUCTION SUCCESSFUL

- ✅x: REPRODUCTION SUCCESSFUL

- ✅y: REPRODUCTION SUCCESSFUL

The reproducibleRchunks package will store meta-data about all variables
that are newly declared within a given chunk. Every time, the document
is regenerated and metadata are present, reproducibleR will compare the
original data and the regenerated data and will display information
about whether they match or not.
