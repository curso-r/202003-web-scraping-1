#' Exercício 03-sptrans
#' Nome do aluno: 

library(tidyverse)
library(httr)

# me ----------------------------------------------------------------------

url_base <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"
u_sptrans_busca <- paste0(url_base, endpoint)
(r_sptrans <- httr::GET(u_sptrans_busca))
httr::content(r_sptrans)

# us ----------------------------------------------------------------------

# caso voce nao queira/nao tenha conseguido fazer uma conta
u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")

# api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"
q_sptrans_login <- list(token = api_key)
r_sptrans_login <- POST(u_sptrans_login, query = q_sptrans_login)
httr::content(r_sptrans_login)

# para colocar sua chave de forma segura, instale o pacote usethis
# install.packages("usethis")
# e use a função edit_r_environ() para colocar sua chave.
usethis::edit_r_environ()

# 1. Obtenha a API key e coloque no seu ambiente
## Dica: usar usethis::edit_r_environ("project")
u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")
q_sptrans_login <- list(token = Sys.getenv("API_OLHO_VIVO"))
r_sptrans_login <- POST(u_sptrans_login, query = q_sptrans_login)

# precisa ser TRUE!
content(r_sptrans_login)

# you ---------------------------------------------------------------------

# 1. Agora baixe as posicoes pelo endpoint /Posicao

u_sptrans_busca <- paste0(u_sptrans, "/Posicao")
r_sptrans_busca <- GET(u_sptrans_busca)
tab_sptrans <- content(r_sptrans_busca, simplifyDataFrame = TRUE)

tab_sptrans$l$vs[[1]]

# 2. Rode tibble::glimpse(tab_sptrans$l, 50)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C

# Observations: 1,812
# Variables: 7
# $ c   <chr> "4315-10", "576C-10", "647A-10", "6…
# $ cl  <int> 2175, 1290, 34083, 33123, 33365, 33…
# $ sl  <int> 1, 1, 2, 2, 2, 2, 1, 1, 2, 1, 2, 2,…
# $ lt0 <chr> "TERM. PQ. D. PEDRO II", "TERM. STO…
# $ lt1 <chr> "TERM. VL. CARRÃO", "METRÔ JABAQUAR…
# $ qv  <int> 2, 3, 5, 6, 3, 7, 3, 6, 7, 5, 7, 3,…
# $ vs  <list> [<data.frame[2 x 5]>, <data.frame[…

# 3. [extra] use tidyr::unnest() para obter as coordenadas de latitude e longitude

tab_sptrans$l %>%
  tidyr::unnest(vs)

# 4. [extra] use o pacote leaflet para montar o mapa do slide 09.
## cuidado: use o parâmetro `clusterOptions = leaflet::markerClusterOptions()`,
## quando for usar a função leaflet::addMarkers()

library(leaflet)
tab_sptrans$l %>%
  tidyr::unnest(vs) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(
    lng = ~px, lat = ~py,
    clusterOptions = leaflet::markerClusterOptions()
  )

