#' Exercício 04-twitter
#' Nome do aluno: 

library(tidyverse)
library(httr)

# me ----------------------------------------------------------------------

trends <- rtweet::get_trends()
dplyr::glimpse(trends)

# us ----------------------------------------------------------------------

# 1. Vamos tuitar!
rtweet::post_tweet("Estou tuitando no Workshop de Web Scraping I da @curso_r, usando o pacote rtweet do #rstats")

# you ---------------------------------------------------------------------

# 1. faça rodar tab_twitter <- rtweet::get_my_timeline()

# 2. Rode tibble::glimpse(dplyr::select(tab_twitter, 1:20), 80)
## e cole o resultado abaixo. Deixe o resultado como um comentário
## Dica: Selecione as linhas que deseja comentar e aplique Ctrl+Shift+C


# 2. [extra] faça a tabela do dashboard do slide 09, usando reactable::reactable()
