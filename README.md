---
title: "readme"
author: "Wouter van der Bijl"
date: "May 24, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## How to run

Install the `shiny` package first, if necessary:

```{r shiny, eval = FALSE}
install.package('shiny')
```

Then run:

```{r run_app}
library(shiny)
runGitHub('Ax3man/FindTheCanine')
```

## Data

Every time you click save, a row will be added to [this google sheet](https://docs.google.com/spreadsheets/d/1R9FLU0xr9uNC79LCqzu2axQ4McPMjZWV0u96ap2kDIc/edit?usp=sharing).
