#' Exercício 01-transparencia
#' Nome do aluno: 

# me ----------------------------------------------------------------------
library(httr)
library(magrittr)
library(jsonlite)

url_base <- "http://transparencia.gov.br"
endpoint <- "/api-de-dados/orgaos-siafi"
u_siafi <- paste0(url_base, endpoint)
r_siafi <- GET(u_siafi)

# us ----------------------------------------------------------------------

# 1. Entenda a diferença entre essas formas de pegar o conteúdo do resultado

str(r_siafi)

content(r_siafi)
content(r_siafi, "text")
content(r_siafi, "raw")
content(r_siafi, "parsed")

content(r_siafi, "parsed", simplifyDataFrame = TRUE)

fromJSON(content(r_siafi, "text"))

# 2. Pegar informações filtrando com o código

codigo_siafi <- "01000"

q_siafi <- list(
  codigo = codigo_siafi,
  pagina = 1
)

r_siafi_filtrado <- GET(u_siafi, query = q_siafi)

u_query <- "http://transparencia.gov.br/api-de-dados/orgaos-siafi?codigo=01000&pagina=1"
r_siafi_filtrado <- GET(u_query)

content(r_siafi_filtrado, simplifyDataFrame = TRUE)

# 3. O que faz httr::write_disk()?

dir.create("output", showWarnings = FALSE, recursive = TRUE)
# GET(u_siafi, query = q_siafi, write_disk("output/01-siafi.json", overwrite = TRUE))

# you ---------------------------------------------------------------------

# 1. Acesse os resultados do Bolsa Família em Janeiro, para a cidade de São Paulo
## código IBGE: "3550308"
## data (ano/mês): 202001

url_base <- "http://transparencia.gov.br"
endpoint_bf <- "/api-de-dados/bolsa-familia-por-municipio"
u_bf <- paste0(url_base, endpoint_bf)

q_bf <- list(
  codigoIbge = "3550308",
  mesAno = "202001",
  pagina = 1
)

r_bf <- GET(u_bf, query = q_bf)

# 2. Armazene o valor e a quantidade nos objetos valor_bf e qtd_bf, respectivamente.

resultado <- content(r_bf)

valor_bf <- resultado[[1]]$valor
qtd_bf <- resultado[[1]]$quantidadeBeneficiados

# 3. [extra]: abra o 01-case.Rmd e faça os itens "1." ficarem iguais à imagem do slide 09.
## Dica: usar flexdashboard::valueBox()

