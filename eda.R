# Exploratory data analysis on the JULIA dataset
library(data.table)
library(ggplot2)
library(dplyr)

set.seed(123)

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
julia <- filter(julia, julia$Comments == "")
julia <- select(julia, -Comments)
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
ggplot(data = julia) + geom_point()

###---------------- INITIAL MODEL ----------------####
# take all covariates that make sense
# start by removing the SR, OR and AR readings
# We keep in the actual "OR" spherical reading since this is our observable
data <- select(julia, -SR, -OR, -V16, -V17, -V19, -V20, -AR, -V22, -V23)
data <- mutate(data, Y = julia$OR)  # add the OR as observable

# Then we remove the axis and second distance columns
# Since we are only interested in predicting the spherical refractive error right now
# model1 <- lm(data = julia, OR ~ 1 + Gender + `JULIA #` + `JULIA (final)` + Age)
data <- select(data, -`S. No`, -V8, -V9, -V10, -V12, -V13, -V14)

# Split up a training and cross-validation set so that there's no bias introduced by our domain knowledge
# and we do not overfit to the data (and can test generalization error)
train.ind <- sample(1:nrow(data), 0.8*nrow(data))
data.train <- data[train.ind, ]
data.test <- data[-train.ind, ]

# Then generate a model and understand what the covariates are predicting
model1 <- lm(data = data.train, Y ~ .)
plot(residuals(model1)) + abline(0,0)

# Slightly better model, excluding the categorical variables
# interpret the model at http://reliawiki.org/index.php/Simple_Linear_Regression_Analysis#t_Tests
model2 <- lm(data = data.train, Y ~ . -`MR. No`)
plot(residuals(model2)) + abline(0,0)

# Forward stepwise selection
step(lm(data=data.train, Y~1), direction="forward", scope = list(upper=lm(data=data.train, Y~.-`MR. No`)))
ggplot(data=data.train) + geom_point(aes(x = Age, y = Y))

# Remove NA values and calculate correlation coefficient
d <- data.train[complete.cases(data.train),]
cor(d$Age, d$Y)
