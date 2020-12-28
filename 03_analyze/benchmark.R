library(stringdist)
library(microbenchmark)

today <- format(Sys.Date(),"%Y%m%d")

jobs   <- read.csv("02_input/20201222_language_requirements_descriptions.csv")
skills <- read.csv("02_input/20201223_esco_skills.csv")

## 01 benchmark number of threads ----
set.seed(42)
size <- 500
skillset <- sample(skills$skill, size=size, replace=FALSE)
bm <- microbenchmark(
    "01" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 1)
  , "02" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 2)
  , "03" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 3)
  , "04" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 4)
  , "05" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 5)
  , "06" = afind(jobs$requirements, skillset, method="running_cosine", q=3, nthread = 6)
  , times=10
  , control=list(warmup=1)
)


saveRDS(bm, file=file.path("03_analyze",sprintf("%s_nthread_benchmark.RDS",today) ))



## Benchmark different sizes
sizes <- seq(100,2500,by=100)

samples <- lapply(sizes, function(size){
  sample(skills$skill, size=size, replace=FALSE)
})


bm1 <- microbenchmark(
  afind(jobs$requirements,   samples[[1]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[2]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[3]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[4]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[5]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[6]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[7]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[8]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[9]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[10]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[11]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[12]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[13]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[14]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[15]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[16]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[17]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[18]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[19]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[20]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[21]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[22]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[23]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[24]], method="running_cosine", q=3, nthread = 6)
  , afind(jobs$requirements, samples[[25]], method="running_cosine", q=3, nthread = 6)
  , times=10, control=list(warmup=1)
)

saveRDS(bm1, file=file.path("03_analyze",sprintf("%s_nsearch_benchmark.RDS",today) ))



