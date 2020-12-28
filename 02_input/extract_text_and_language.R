# - Check encoding and where necessary transliterate to UTF-8
# - Detect languages
# - Extract requirements and job description from vacancies for each language
# - Export to csv files, one row per vacancy, one file per language.

library(rvest)
library(textcat)
library(stringi)

## 01 Extract text, uniformize encoding: html_files, txt_utf8 ----
html_files <- dir("01raw/html",pattern = ".*html", full.names = TRUE)

txt <- character(0)
for ( html_file in html_files){
  html <- read_html(html_file)
  txt  <- c(txt, html_text(html))
}

enc  <- stri_enc_detect2(txt)
# get most probable encoding
from <- sapply(enc, function(x) x[1,1])
# translate UCI notation (windows-1255) to iconv notation (CP1255)
from <- sub(".*(\\d{4})","CP\\1", from) 

txt_utf8 <- sapply(seq_along(txt), function(i){
  iconv(txt[i], from = from[i], to="UTF-8//TRANSLIT")
})

txt_utf8 <- stri_trans_nfkc(txt_utf8)

## 02 label language: txt_lang ----
txt_lang <- textcat(txt_utf8)


## 03 Extract job description and job requirements ----

get_section <- function(x, section){
  # Note: in some Dutch language descriptions, the headings are still in English
  # hence the following regular expressions demarcating the start and end of
  # the job descriptions.
  start_rx <- c(
      "requirements"    = "(^.*Requirements\\n\\s+\\n)|(^.*Functie-eisen\\n\\s+\\n)" 
    , "job description" = "(^.*?Job description\\n\\s+\\n)|(^.*?Functieomschrijving\\n\\s+\\n)"
  )
  
  end_rx <- c(
    "requirements" = "Conditions of employment\\n\\s+\\n.*$|Arbeidsvoorwaarden\\n\\s+\\n.*$"
    , "job description" = "Specifications\\n\\s+\\n.*$|Specificaties\\n\\s+\\n.*$"
  )
  
  txt <- sub(start_rx[section],"", x)
  sub(end_rx[section], "", txt)
}


cleanup <- function(x){
  x <- trimws(x)
  x <- gsub("\\n"," ",x)
  gsub("\\s+"," ",x)
}

reqs <- get_section(txt_utf8, section="requirements")
jbds <- get_section(txt_utf8, section="job description")


textdat <- data.frame(
    file     = html_files
  , language = txt_lang
  , requirements    = cleanup(reqs)
  , job_description = cleanup(jbds) 
)

fname <- sprintf("%s_language_requirements_descriptions.csv",today)
outfile <- file.path("02_input/",fname)
write.csv(textdat, outfile, row.names=FALSE)









