library(magrittr)

config <- yaml::read_yaml("config.yaml")

assertthat::assert_that(httr::status_code(httr::GET(config$api_up)) == 200)
