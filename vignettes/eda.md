---
title: "R Notebook"
output:
  html_document:
    keep_md: true
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code.

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Cmd+Shift+Enter*.


```r
library(readr)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(tidyr)
prefix <- "https://raw.githubusercontent.com/nelsonamayad/Elecciones-presidenciales-2022/main/"
path <- "Encuestas%202022/encuestas_2022.csv"
df <- paste0(prefix, path) %>%
    readr::read_csv(
        col_types = list(
            encuestadora = col_character(),
            fuente = col_character(),
            link = col_character(),
            muestreo = col_character(),
            tipo = col_character(),
            hipotesis = col_character(),
            fecha = col_date(),
            n = col_integer(),
            .default = col_double()
        )
    ) %>%
    mutate(se = margen_error / 1.96) %>%
    select(
        -n,
        -tasa_respuesta,
        -fuente,
        -hipotesis,
        -muestra_int_voto,
        -margen_error
    ) %>%
    rename(
        pollster = encuestadora,
        date= fecha,
        n = muestra,
        other = otros,
        other_nsnr=ns_nr,
        sampling_type = muestreo,
        polling_type = tipo,
        num_cities = municipios
    ) %>%
    tidyr::pivot_longer(
        !c(
            pollster,
            date,
            n,
            link,
            sampling_type,
            polling_type,
            num_cities,
            se            
        ),
        names_to = "candidate",
        values_to = "prop"
    ) %>%
    relocate(
        candidate,
        prop,
        se,
        .after = date
    ) %>%
    mutate(
        candidate = stringr::str_to_title(
            stringr::str_extract(
                candidate, "[^_]+$"
            )
        ),
        prop = prop / 100,
        se = se / 100
    )
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.


```r
library(ggplot2)
library(scales)
```

```
## 
## Attaching package: 'scales'
```

```
## The following object is masked from 'package:readr':
## 
##     col_factor
```

```r
df %>%
    filter(candidate %in% c("Fajardo", "Gutierrez", "Petro", "Hernandez")) %>%
    ggplot(aes(date, prop, color=candidate, shape=pollster)) +
    geom_point(alpha=1) +
    geom_line(alpha=0.2) +
    scale_y_continuous(labels = scales::percent)
```

![](eda_files/figure-html/unnamed-chunk-2-1.png)<!-- -->
