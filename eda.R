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
# Also remove the outliers which had the reading greater than 80
# TODO: Keep seperate check box/factor/indicator covariate for these patients
julia <- filter(julia, `Comments` == "")
julia <- julia[!julia$`JULIA (final)` > 80, ]

###---------------- EDA PLOTS ----------------####
# plot the OR vs JULIA 1st axis distance
# Formatting tips from https://www.r-bloggers.com/how-to-format-your-chart-and-axis-titles-in-ggplot2/
ggplot(data = julia) +
geom_point(aes(y = `JULIA (final)`, x = OR, color=Investigator)) +
labs(x ="Refractive Error of patient eye measured by OR (Dioptres)", y="Folding Phoropter Reading (mm)") 

# plot the initial JULIA reading w.r.t. final reading
ggplot(data = julia) + geom_point(aes(y = `JULIA (final)`, x = `JULIA (initial)`))

# plot the readings vs age

