#' Exercício 07-tjsp
#' Nome do aluno: 

library(tidyverse)
library(httr)
library(rvest)

# me ----------------------------------------------------------------------

u_tjsp <- "https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do"

b_tjsp <- list(
  dados.buscaInteiroTeor = "coronavirus", 
  dados.origensSelecionadas = "T"
)

r_tjsp <- POST(u_tjsp, body = b_tjsp)

# muitas vezes precisa disso aqui
r_tjsp <- POST(u_tjsp, body = b_tjsp, encode = "form")

# us ----------------------------------------------------------------------

u_tjsp_pag <- "https://esaj.tjsp.jus.br/cjsg/trocaDePagina.do"
q_tjsp_pag <- list(tipoDeDecisao = "A", pagina = pag, conversationId = "")
r_tjsp_pag <- GET(u_tjsp_pag, query = q_tjsp_pag, write_disk(paste0(pag, ".html")))

tab_html <- r_tjsp_pag %>% 
  read_html(encoding = "UTF-8") %>% 
  xml_find_all("//tr[@class='fundocinza1']//table")

tab_html[[1]] %>% 
  html_table(fill = TRUE) %>% 
  as_tibble() %>% 
  mutate(X1 = str_squish(X1))

# you ---------------------------------------------------------------------

# 1. Crie uma função tjsp_baixar_pag() que baixa a página
## Dica: usar httr::write_disk()
# 2. Baixe todos os resultados
# 3. Crie uma funcao ler_item que lê cada item da tabela, como fizemos
# 4. Aplique a sua função em todos os elementos da saída e empilhe
## Dica: usar purrr::map_dfr()
# 5. Separe o título do conteúdo
## Dica: usar tidyr::separate()
# 6. Aplique tidyr::spread() ou tidyr::pivor_wider() para ficar com uma linha
## para cada processo. Cuidado: a linha com o número do processo é diferente
# 7. Armazene o resultado final em tab_tjsp


u_tjsp <- "https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do"
b_tjsp <- list(
  dados.buscaInteiroTeor = "coronavirus", 
  dados.origensSelecionadas = "T"
)

r_tjsp <- httr::POST(u_tjsp, body = b_tjsp, encode = "form")

tjsp_baixar_pag <- function(pag, pasta) {
  dir.create(pasta, showWarnings = FALSE, recursive = TRUE)
  arquivo <- sprintf("%s/%04d.html", pasta, pag)
  u_tjsp_pag <- "https://esaj.tjsp.jus.br/cjsg/trocaDePagina.do"
  q_tjsp_pag <- list(tipoDeDecisao = "A", pagina = pag, conversationId = "")
  r_tjsp_pag <- GET(u_tjsp_pag, query = q_tjsp_pag, write_disk(arquivo, overwrite = TRUE))
}

purrr::walk(1:2, tjsp_baixar_pag, pasta = "tjsp")

tjsp_ler_pag <- function(arquivo) {
  
  tab_html <- arquivo %>% 
    xml2::read_html(encoding = "UTF-8") %>% 
    xml2::xml_find_all("//tr[@class='fundocinza1']//table")
  
  ler_item <- function(item) {
    item %>% 
      rvest::html_table(fill = TRUE) %>% 
      tibble::as_tibble() %>% 
      dplyr::mutate_all(stringr::str_squish)
  }
  
  re_id_processo <- "[0-9.-]+"
  
  tab_html %>% 
    purrr::map_dfr(ler_item, .id = "item") %>% 
    dplyr::select(item, titulo_valor = X1) %>% 
    tidyr::separate(titulo_valor, c("titulo", "valor"), sep = ": ", extra = "merge", fill = "right") %>% 
    dplyr::mutate(processo = stringr::str_extract(titulo, re_id_processo)) %>% 
    tidyr::fill(processo) %>% 
    dplyr::filter(!stringr::str_detect(titulo, re_id_processo)) %>% 
    tidyr::pivot_wider(names_from = titulo, values_from = valor) %>% 
    janitor::clean_names()
}

tab_tjsp <- dir("tjsp", full.names = TRUE) %>% 
  purrr::map_dfr(tjsp_ler_pag, .id = "id_file")


# 8.  Rode tibble::glimpse(tab_tjsp)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C

# 9. [extra] monte o wordcloud do exemplo.
## Dica: use tidytext para separar as palavras e ggwordcloud para o gráfico.
## Dica: mostre apenas palavras que aparecem mais do que 5 vezes.

