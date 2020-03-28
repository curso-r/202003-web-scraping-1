#' Exercício 05-covid
#' Nome do aluno: 

library(tidyverse)
library(httr)

# me ----------------------------------------------------------------------
# sem ajuda dessa vez ;)

# us ----------------------------------------------------------------------
# sem ajuda dessa vez ;)


# obtendo os dados do MS

# https://covid.saude.gov.br

u_ms <- "https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalRegiao"

r_ms <- httr::GET(
  u_ms, 
  httr::add_headers("x-parse-application-id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

tab_covid_regiao <- content(r_ms, simplifyDataFrame = TRUE)$results

class(tab_covid_regiao)

# ctrl+shift+C

# you ---------------------------------------------------------------------

# 1. baixe e carregue a base do covid no objeto tab_covid

u_covid <- "https://pomber.github.io/covid19/timeseries.json"
r_covid <- httr::GET(u_covid)
tab_covid <- content(r_covid, simplifyDataFrame = TRUE)

u_ms <- "https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalMapa"

r_ms <- httr::GET(
  u_ms, 
  httr::add_headers("x-parse-application-id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

tab_covid <- content(r_ms, simplifyDataFrame = TRUE)$results

# 2. Rode tibble::glimpse(tab_covid, 50)

# Observations: 27
# Variables: 8
# $ objectId       <chr> "uTN8WP10HY", "XHUDIFEjQ…
# $ nome           <chr> "Acre", "Alagoas", "Amap…
# $ qtd_confirmado <int> 25, 14, 4, 111, 128, 314…
# $ latitude       <chr> "-9.97499", "-9.66599", …
# $ longitude      <chr> "-67.8243", "-35.735", "…
# $ createdAt      <chr> "2020-03-25T23:37:11.094…
# $ updatedAt      <chr> "2020-03-28T19:24:52.296…
# $ percent        <chr> "0%", NA, NA, NA, NA, NA…

# 3. [extra] monte um gráfico mostrando a taxa de mortes divida pela quantidade 
# de casos total, para cada país. Filtrar somente os dez países com mais casos.

## OBS: Montamos um mapa no lugar do gráfico :)
## se quiser ver o gráfico, acesse prof/08-case.R

library(leaflet)
tab_covid %>% 
  as_tibble() %>% 
  mutate(
    latitude = as.numeric(latitude),
    longitude = as.numeric(longitude)
  ) %>% 
  leaflet() %>% 
  addTiles() %>% 
  addCircles(radius = ~qtd_confirmado * 100)
