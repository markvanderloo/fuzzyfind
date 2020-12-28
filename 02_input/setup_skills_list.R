# read skills and gather into a single cv file with labeled skills.

esco_files <- c(
  lang_en = "01raw/esco-bundle/v1.0.0_1/languageSkillsCollection_en.csv"
  , lang_nl = "01raw/esco-bundle/v1.0.0_1/languageSkillsCollection_nl.csv"
  , trans_en  = "01raw/esco-bundle/v1.0.0_1/transversalSkillsCollection_en.csv"
  , trans_nl =  "01raw/esco-bundle/v1.0.3/transversalSkillsCollection_nl.csv"
  , skills_en = "01raw/esco-bundle/v1.0.3/skills_en.csv"
  , skills_nl = "01raw/esco-bundle/v1.0.3/skills_nl.csv"
)

L <- setNames(vector(mode="list", length=length(esco_files)), basename(esco_files))

for (esco_file in esco_files){
#  esco_file <- esco_files[6]
  d <- read.csv(esco_file)
  skill_class <- sub("(_.*$)|[A-Z].*$","",basename(esco_file))
  skill_lang  <- if( grepl("_en",basename(esco_file))) "english" else "dutch"
  version     <- if (grepl("1.0.3", esco_file)) "1.0.3" else "1.0.0_1" 
  K <- lapply(seq_len(nrow(d)), function(i){
    x <- d[i,]
    data.frame(
      skill  =  c(
        x$preferredLabel
        , trimws(strsplit(x$altLabels, "\\||\\n")[[1]]))
      , skilltype       =  x$skillType
      , description     = x$description
      , class           = skill_class
      , language        = skill_lang
      , esco_version    = version
    )
  })
  L[[basename(esco_file)]] <- do.call("rbind", K)  
}


out <- do.call("rbind", L)
out <- out[!duplicated(out),]

today <- format(Sys.Date(),"%Y%m%d")
fname <- sprintf("%s_esco_skills.csv", today)
write.csv(out, file=file.path("02_input/",fname),row.names=FALSE)


