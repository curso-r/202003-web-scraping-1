library(tidyverse)
library(googledrive)

## rodar apenas uma vez
# drv <- googledrive::drive_find("Web Scraping 1 28/03/2020")
# tab <- googledrive::drive_ls(googledrive::as_id(drv$id[1])) %>% 
#   dplyr::select(nm = name, id) %>% 
#   dplyr::arrange(name) %>% 
#   dplyr::filter(!stringr::str_detect(name, "Templa"))
# datapasta::tribble_paste(tab)

ids_ex <- tribble(
                 ~nm,                                                                        ~id,
      "00-ola-mundo", "0BxqNgtra6i0ufjFQNF9IczdZQkxVbTdmRHl6UU9Ub3RpMFYzOGtNRlZQd0l2cFFibnI0ZkE",
  "01-transparencia", "0BxqNgtra6i0ufllMQ3g4bnpWLThpY2lKZzNxaUJtS25uN0c0UW15X3F3a19yYkh6T3lJNkk",
         "02-sabesp", "0BxqNgtra6i0ufnc3N1ZsbW5sVzBwbmMxZkhLVlRST3hZTUp4Wk90cmQ1YzJHSVU3MHJiVWM",
        "03-sptrans", "0BxqNgtra6i0ufjZ0Z0tVa1N0VUl0QnRxLWNFNDFmdDNxNENkNU1OWnBQeU1JeHZzT3ozem8",
        "04-twitter", "0BxqNgtra6i0ufnBBdm44Vk93UVFWZmVaaGlka0JoMlpNckIxVXpndHcxVkgxUzJoNGJJMG8",
          "05-covid", "0BxqNgtra6i0ufnBOQkw3QnBjRmNIcm1CS3ctNFJwSFpkUk52VjJFMnJTakJObmxkd0otbkU",
    "06-chancedegol", "0BxqNgtra6i0ufnZCSVhaTGtQX1pDU0RJaklhTWprZVRMd2s4YXduclpENDYxVVY5T0loU00",
           "07-tjsp", "0BxqNgtra6i0ufl9ST2tBM19oSUNFbUJfU0pTN2N6ODNvVUpYbXlFVk5RRWk5bnVlTnBQOUU"
  )

baixar_exercicios <- function(ii) {
  
  id_exercicio <- ids_ex$id[ii]
  nm_exercicio <- ids_ex$nm[ii]
  
  path_exercicio <- paste0("prof/", nm_exercicio)
  tab_exercicios <- id_exercicio %>% 
    as_id() %>% 
    drive_ls() %>% 
    mutate(
      user = map_chr(drive_resource, pluck, "sharingUser", "emailAddress"),
      nm = str_extract(user, "[^@]+"),
      file = paste0(path_exercicio, "/", nm, "_", name)
    )
  fs::dir_create(path_exercicio)
  walk2(tab_exercicios$id, tab_exercicios$file, 
        ~drive_download(as_id(.x), .y, verbose = FALSE, overwrite = TRUE))
}

