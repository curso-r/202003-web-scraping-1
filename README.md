
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Configuração inicial

#### Passo 1: Instalar pacotes

``` r
install.packages("remotes")

# instalar pacote da Curso-R
remotes::install_github("curso-r/CursoR")

# instalar pacotes que vamos usar durante o curso
CursoR::instalar_dependencias()
```

#### Passo 2: Criar um projeto do RStudio

Faça um projeto do RStudio para usar durante todo o curso e em seguida
abra-o.

``` r
install.packages("usethis")
usethis::create_package("caminho_ate_o_projeto/nome_do_projeto")
```

#### Passo 3: Baixar o material

Certifique que você está dentro do projeto criado no passo 2 e rode o
código abaixo.

**Observação**: Assim que rodar o código abaixo, o programa vai pedir
uma escolha de opções. Escolha o número correspondente ao curso de Web
Scraping\!

``` r
# Baixar ou atualizar material do curso
CursoR::atualizar_material()
```

## Slides

| slide | link |
| :---- | :--- |

## Scripts usados em aula

| script             | link                                                                 |
| :----------------- | :------------------------------------------------------------------- |
| 00-ola-mundo.R     | <https://curso-r.github.io/202003-web-scraping-1/00-ola-mundo.R>     |
| 01-transparencia.R | <https://curso-r.github.io/202003-web-scraping-1/01-transparencia.R> |
| 02-sabesp.R        | <https://curso-r.github.io/202003-web-scraping-1/02-sabesp.R>        |
| 03-sptrans.R       | <https://curso-r.github.io/202003-web-scraping-1/03-sptrans.R>       |
| 04-twitter.R       | <https://curso-r.github.io/202003-web-scraping-1/04-twitter.R>       |
| 05-covid.R         | <https://curso-r.github.io/202003-web-scraping-1/05-covid.R>         |
| 06-chancedegol.R   | <https://curso-r.github.io/202003-web-scraping-1/06-chancedegol.R>   |
| 07-tjsp.R          | <https://curso-r.github.io/202003-web-scraping-1/07-tjsp.R>          |
| 08-case.Rmd        | <https://curso-r.github.io/202003-web-scraping-1/08-case.Rmd>        |
| README.Rmd         | <https://curso-r.github.io/202003-web-scraping-1/README.Rmd>         |
| web-scraping.Rproj | <https://curso-r.github.io/202003-web-scraping-1/web-scraping.Rproj> |
