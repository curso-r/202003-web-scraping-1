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
api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"

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

# 2. Rode tibble::glimpse(tab_sptrans$l, 50)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C

# 3. [extra] use tidyr::unnest() para obter as coordenadas de latitude e longitude

# 4. [extra] use o pacote leaflet para montar o mapa do slide 09.
## cuidado: use o parâmetro `clusterOptions = leaflet::markerClusterOptions()`,
## quando for usar a função leaflet::addMarkers()

