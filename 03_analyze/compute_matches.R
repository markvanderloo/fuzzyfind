library(stringdist)
source("00_functions/functions.R")
today <- format(Sys.Date(),"%Y%m%d")
options(sd_num_thread = 4)




esco_skills <- read.csv("02_input/20201223_esco_skills.csv")
job_data <- read.csv("02_input/20201228_language_requirements_descriptions.csv")

job_data$text <- tolower(job_data$text)

languages <- unique(esco_skills$language)
distances <- c("running_cosine","jw")
sections  <- unique(job_data$section)



for (section in sections){
  catf("\n")
  catf("\n Working on %s", section)
  i_section <- job_data$section == section
  
  for (distance in distances){
    catf("\n  %s", distance)
    for (language in languages ){
      catf("\n    %7s",language)
      
      # output file
      fname <- sprintf("%s_matches_%s_%s_%s.RDS",today,language, section, distance)
      outfile <- file.path("03_analyze/matches", fname)
      
      # actual calculation
      i <- i_section & job_data$language == language
      j <- esco_skills$language == language
      t <- system.time(
        out <- afind(job_data$text[i], esco_skills$skill[j], method = distance, q=3, p=0.1)
      )
      catf(" (%s)",humanize(t[3], color=FALSE))
      catf(" ==> %s", outfile)
      saveRDS(out, file=outfile)
      
      # clean up
      rm("out")
      gc()
    } # end languages
  } # end distances
} # end sections

catf("\n")