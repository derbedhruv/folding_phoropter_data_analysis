# Exploratory data analysis on the JULIA dataset
library(data.table)
library(ggplot2)

# Read in, remove incomplete cases and convert relevant columns to numeric datatype
# MAKE sure you are in the right folder and the CSV file is local
julia_raw <- fread("JULIA data.csv")
julia <- julia_raw[complete.cases(julia_raw),]  # select all columns (empty second arg) with complete rows
julia$`JULIA (initial)` <- as.numeric(julia$`JULIA (initial)`)
julia$`JULIA (final)` <- as.numeric(julia$`JULIA (final)`)
julia$OR <- as.numeric(julia$OR)

# Remove rows with comments - as these patients had issues
# TODO: Keep seperate check box/factor/indicator covariate for these patients
julia <- filter(julia, `Comments` == "")

# plot the OR vs JULIA 1st axis distance
ggplot(data = julia) + geom_point(aes(y = `JULIA (final)`, x = OR))