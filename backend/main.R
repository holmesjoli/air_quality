library(magrittr)
library(RAQSAPI)

sapply(list.files("R", full.names = TRUE), source, .GlobalEnv)

config <- yaml::read_yaml("config.yaml")
endpoint <- config$api$endpoint
state_code <- config$params$state_code
bdate <- config$params$bdate
edate <- config$params$edate
email <- config$params$email
param <- config$params$params

key <- Sys.getenv("API_AQS")

assertthat::assert_that(httr::status_code(httr::GET(glue::glue(config$api$up, endpoint = endpoint))) == 200)

cnty_code <- get_aqs_df(glue::glue(config$api$county_path, 
                        endpoint = endpoint, 
                        state_code = state_code))

class <- get_aqs_df("https://aqs.epa.gov/data/api/list/classes?email=test@aqs.api&key=test")

params <- get_aqs_df("https://aqs.epa.gov/data/api/list/parametersByClass?email=test@aqs.api&key=test&pc=CRITERIA")

df <- httr::GET(glue::glue(config$api$annual_data, 
           endpoint = endpoint,
           state_code = state_code,
           bdate = bdate,
           edate = edate,
           email = email,
           key = key,
           cnty_code = cnty_code$code[1],
           param = paste(param, collapse = ",")))

df <- httr::GET("https://aqs.epa.gov/data/api/annualData/byCounty?email=test@aqs.api&key=test&param=88101&bdate=20160101&edate=20160228&state=37&county=183") %>% 
  httr::content()


df <- lapply(list.files("data", full.names = TRUE), readr::read_csv) %>% 
  dplyr::bind_rows()
