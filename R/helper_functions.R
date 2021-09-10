#' @title Get AQS data
#' @description AQS: air quality system
get_aqs_df <- function(url) {

  httr::GET(url) %>% 
    httr::content() %>% 
    .[[2]] %>% 
    dplyr::bind_rows()
}
