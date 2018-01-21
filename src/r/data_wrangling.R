
library(tidyverse)

dirs <- dir("home/indiana-nikel/states")
#fileName <- file.path(dirs, paste0(dirs, ".txt"))

dirs

#file_csv <- list.files(pattern="*.csv")
#df <- lapply(files, read_csv) %>% bind_rows()

## import_multiple_csv_files_to_R
# Purpose: Import multiple csv files to the Global Environment in R

# set working directory

setwd("/home/indiana-nikel/states/ca")

# list all csv files from the current directory
list.files(pattern=".csv$") # use the pattern argument to define a common pattern  for import files with regex. Here: .csv

# create a list from these files
list.filenames<-list.files(pattern=".csv$")
list.filenames

# create an empty list that will serve as a container to receive the incoming files
list.data<-list()

# create a loop to read in your data
for (i in 1:length(list.filenames))
{
  list.data[[i]]<-read.csv(list.filenames[i])
}


