library(tidyverse)
library(httr)

# 01-transparencia -----------------------------------------------------------

valor_bf <- NULL
qtd_bf <- NULL

try({
  u_bf <- "http://www.transparencia.gov.br"
  endpoint <- "/api-de-dados/bolsa-familia-por-municipio"
  u_bf <- paste0(u_bf, endpoint)
  
  q_bf <- list(
    mesAno = "202001",
    codigoIbge = "3550308",
    pagina = 1
  )
  
  r_bf <- GET(u_bf, query = q_bf)
  conteudo <- content(r_bf)
  
  valor_bf <- conteudo[[1]]$valor
  qtd_bf <- conteudo[[1]]$quantidadeBeneficiados
})

# 02-sabesp ---------------------------------------------------------------

tab_sabesp <- NULL

try ({
  u_sabesp <- "http://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
  data <- Sys.Date() - 1 
  u_sabesp <- paste0(u_sabesp, data)
  
  r_sabesp <- GET(u_sabesp)
  conteudo <- content(r_sabesp, simplifyDataFrame = TRUE)
  
  tab_sabesp <- conteudo$ReturnObj$sistemas
})

# 03-sptrans --------------------------------------------------------------

tab_sptrans <- NULL

try({
  u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
  u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")
  q_sptrans_login <- list(token = Sys.getenv("API_OLHO_VIVO"))
  
  r_sptrans_login <- POST(u_sptrans_login, query = q_sptrans_login)
  content(r_sptrans_login)
  
  u_sptrans_busca <- paste0(u_sptrans, "/Posicao")
  r_sptrans_busca <- GET(u_sptrans_busca)
  tab_sptrans <- content(r_sptrans_busca, simplifyDataFrame = TRUE)
})

# 04-twitter --------------------------------------------------------------
tab_twitter <- NULL

try({
  tab_twitter <- rtweet::get_my_timeline()
})


# 05-covid ----------------------------------------------------------------

tab_covid <- NULL

try({
  tab_covid <- "https://pomber.github.io/covid19/timeseries.json" %>% 
    jsonlite::fromJSON() %>% 
    purrr::map_dfr(tail, 1, .id = "pais")
})

# 06-chancedegol ----------------------------------------------------------

tab_cdg <- NULL

try({

  ano <- 2019
  u_cdg <- sprintf('http://www.chancedegol.com.br/br%02d.htm', ano - 2000)
  
  cdg_html <- u_cdg %>%
    httr::GET() %>%
    httr::content('text', encoding = 'latin1') %>%
    xml2::read_html() %>%
    xml2::xml_find_first('//table')
  
  cores <- cdg_html %>%
    xml2::xml_find_all('//font[@color="#FF0000"]') %>%
    xml2::xml_text()
  
  tab_cdg <- rvest::html_table(cdg_html, header = TRUE)
  names(tab_cdg) <- c('dt_jogo', 'mandante', 'placar', 'visitante',
                      'p_mandante', 'p_empate', 'p_visitante')
  
  tab_cdg$p_vitorioso <- cores
  
  tab_cdg <- tab_cdg %>% 
    mutate_at(vars(starts_with("p")), parse_number) %>% 
    mutate(maximo_p = pmax(p_mandante, p_empate, p_visitante)) %>% 
    mutate(acertou = p_vitorioso == maximo_p)
  
})

# 06-tjsp -----------------------------------------------------------------

tab_tjsp <- NULL

try({
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
    
    ler_item <- . %>% 
      rvest::html_table(fill = TRUE) %>% 
      tibble::as_tibble() %>% 
      dplyr::mutate_all(stringr::str_squish)
    
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
  
})

