#' Get Prior Year LPGA Stats Links
#'
#'This function gets the links for pages that have LPGA statistics for previous years.
#'Currently only gets previous year pages for statistics that are on the main page
#'of the statistics section of LPGA.com.
#'
#'@param year Numeric.  This is the previous year that you want to collect the statistics for.
#'@export

lpga_getlinks <- function(year = 2016){
  front_page <- read_html('http://www.lpga.com/statistics/')
  links <- front_page %>%
    rvest::html_nodes('a.button') %>%
    rvest::html_attr('href')

  # keep just the links that go to a statistics page
  statIndex <- grep("statistics", links)
  links <- links[statIndex]

  # add the front part of the URL
  links <- paste0("http://www.lpga.com", links)
  links16 <- paste0(links,"?year=",year)
  return(links16)

}


#' Scrape LPGA Stats Pages
#'
#' This function takes a list of website pages from LPGA.com for current year or prior years statistics
#' and pulls the data table. The list can be the output from the lpga_getlinks() function.
#'  A data frame is created from the table from each page  and added to a list of data frames.
#'  Output is a list of dataframes.
#'
#' @param links  A list of website URLs
#' @export

lpga_scrape <- function(links = NULL){
listofdfs <- list()
for(i in 1:length(links)){
  page <- read_html(links[i])
  table <- page %>%
    html_node('table.table') %>%
    html_table()
  listofdfs[[i]]<- table
}
return(listofdfs)
}


