#' Exercício 06-chancedegol
#' Nome do aluno: 

library(tidyverse)
library(httr)
library(rvest)

# me ----------------------------------------------------------------------

u_cdg <- "http://www.chancedegol.com.br/br19.htm"

cdg_html <- u_cdg %>%
  GET() %>%
  content('text', encoding = 'latin1')

# us ----------------------------------------------------------------------

cdg_table <- cdg_html  %>%
  read_html() %>%
  xml_find_first('//table')

cores <- cdg_html %>%
  # ADICIONAR ISSO AQUI
  read_html() %>% 
  xml_find_all('//font[@color="#FF0000"]') %>%
  xml_text()

# you ---------------------------------------------------------------------

# 1. Obtenha o vetor com as probabilidades dos resultados que realmente aconteceram
## Dica: qual é a cor deles?

cores

# 2. Construa a tabela final e armazene em tab_cdg
## Dica: utilize rvest::html_table() e adicione a coluna cores
# 2.1. aplicar a função rvest::html_table() no objeto cdg_table
# 2.2. adicionar a coluna prob_vencedor usando o objeto cores

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

# 3. Rode tibble::glimpse(tab_cdg)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C

# Observations: 376
# Variables: 10
# $ dt_jogo     <chr> "27/04/2019", "27/04/2019", "27/04/2019", "27/04/…
# $ mandante    <chr> "Atlético MG", "São Paulo", "Flamengo", "Chapecoe…
# $ placar      <dbl> 2, 2, 3, 2, 1, 4, 4, 0, 3, 4, 2, 1, 2, 1, 1, 1, 1…
# $ visitante   <chr> "Avaí", "Botafogo", "Cruzeiro", "Internacional", …
# $ p_mandante  <dbl> 54.6, 56.9, 51.7, 24.2, 60.4, 56.3, 69.4, 51.3, 4…
# $ p_empate    <dbl> 24.5, 27.8, 25.1, 31.3, 23.7, 26.2, 24.3, 24.7, 3…
# $ p_visitante <dbl> 20.9, 15.2, 23.2, 44.6, 15.8, 17.5, 6.3, 23.9, 20…
# $ p_vitorioso <dbl> 54.6, 56.9, 51.7, 24.2, 15.8, 56.3, 69.4, 23.9, 4…
# $ maximo_p    <dbl> 54.6, 56.9, 51.7, 44.6, 60.4, 56.3, 69.4, 51.3, 4…
# $ acertou     <lgl> TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE…

# 4. [extra] construa o gráfico do slide 09. O gráfico mostra qual é a proporção
# de acertos do Chance de Gol por time. Os passos são
# a) obter qual seria o chute do Chance de Gol, dado pelo resultado com
# maior probabilidade em cada jogo
# b) construir uma coluna "acertou", que é TRUE se o modelo acertou 
# e FALSE caso contrário
# c) empilhar a base (usar tidyr::gather ou tidyr::pivot_longer) para considerar
# tanto mandantes quanto visitantes
# d) agrupar por time e calcular a proporção de acertos. Ordenar a variável
# pela proporção de acertos
# e) montar o gráfico!

tab_cdg %>% 
  mutate_at(vars(vitoria_mandante, empate, vitoria_visitante, prob_vencedor), parse_number) %>%
  mutate(prob_maior = pmax(vitoria_mandante, empate, vitoria_visitante)) %>% 
  mutate(acertou = (prob_maior == prob_vencedor)) %>% 
  select(data, mandante, visitante, acertou) %>% 
  pivot_longer(c(mandante, visitante)) %>% 
  group_by(value) %>% 
  summarise(prop_acertou = mean(acertou)) %>% 
  mutate(value = fct_reorder(value, prop_acertou)) %>% 
  ggplot(aes(y = value, x = prop_acertou)) +
  geom_col()
