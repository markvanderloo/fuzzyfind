# Scraping academic transfer.
# Download upto the first vacancies
# - store a csv of the vacancy links
# - store all downloaded html files.
# Author: Mark van der Loo 2020-12-22
library(rvest)

base_url <- "https://www.academictransfer.com"
today    <- format(Sys.Date(),"%Y%m%d")


# scrape job urls from front page
html <- read_html(file.path(base_url,"en/"))

## 01 obtain link to job pages: job_links ----

links <- character(0)
npages <- 60
for (page in seq_len(npages) ){
  try({
    url  <- file.path(base_url, sprintf("en/?page=%d", page))
    html <- read_html(url)
    link_nodes <- html_nodes(html, css="div > a")
    all_links <- html_attr(link_nodes, "href")
    links <- c(links, all_links)
    Sys.sleep(0.5)
  })
}

# filter job links, they all look like
# <base_url>/en/<6 numbers>/?<job title>/<random cruft>
job_links <- links[grepl("^/en/\\d{6}.*/\\?", links)]
# remove cruft at the end
job_links <- sub("/\\?.*$","",job_links)

fname <- sprintf("%s_job_links.csv",today)
write.csv(data.frame(link=job_links), file=file.path("01raw/",outfile),row.names=TRUE)


## 02 scrape job pages and save ----

i <- 1
for (link in job_links){
  cat("\n", sprintf("Downloading %03d/%03d: %s",i <- i+1,length(job_links), link))
  fname <- sprintf("%s_%s.html", today, gsub("^.*\\d{6}/","",link))
  outfile <- file.path("01raw/html",fname)
  url <- file.path(base_url,link)
  try(write_html(read_html(url), outfile))
  Sys.sleep(0.5)
}

