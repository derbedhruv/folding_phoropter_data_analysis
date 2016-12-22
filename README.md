# Data Analysis on the Folding Phoropter - Pilot Study
### Author 
Dhruv Joshi (based on earlier work by Ang Cui)

### Data collection brief
The [folding phoropter](http://lvpmitra.com/phoropter) is an [award-winning device](http://mashable.com/2016/11/02/social-good-innovations-october-2016/#iK896J3Dc5qu) built at the Srujana Center for Innovation, [L V Prasad Eye Institute](http://www.lvpei.org) (LVPEI), Hyderabad, India, to combat the disproportionate access to tools for screening for refractive error in low resource areas. This device is extremely low-cost, disposable, easy to assemble and open-source, which means anyone can build their own following the instructions. Read more [here](http://lvpmitra.com/phoropter). A short video explaining the device is [here](http://www.youtube.com/watch?v=7etlqg5fsDI).

Data was collected at the Kallam Anji Reddy Campus of LVPEI during June 2016 on 125 refractive error patients and volunteers (250 eyes). The criteria for inclusion in the study was:
* Adults (over 18 years of age)
* No ocular diseases besides refractive error and astigmatistm
* All would be current or past patients of LVPEI, whose data would be on file

Four independent devices were used to collected data and two Optometrist interns were doing the data collection. The "outcome" variable is the subjective refraction (SR) of the patients, and we will attempt to build a model of the same w.r.t. different covariates which were measured.

# Questions we want to ask:
* Did the individual investigators have any effect on the outcome? (Variation with user)
* Did the individual devices have any effect on the outcome? (Device variation)
* Do any other covariates affect the outcome besides the device reading? (i.e. should we take any other factors into our model)
* Can we build a simple emperical linear regression model relating the measured value with the "gold standard" Refractive Error value, that generalizes well?
* Can we then relate this linear model to the actual population model?

The following is the plot the (final) measured readings w.r.t. the 'gold standard' or ground truth refractive errors.

![Measurements vs ground truth](https://raw.githubusercontent.com/derbedhruv/folding_phoropter_data_analysis/master/plots/reading_vs_optom.jpeg)

The following is the plot of the initial vs final readings on the device (see measurement protocol).

![Final w.r.t. Initial](https://raw.githubusercontent.com/derbedhruv/folding_phoropter_data_analysis/master/plots/initial_vs_final.jpeg)

We will use the chi-squared test to quantify the independence of two categorical variables. For continuous variables, we will use the Pearson coefficient.

# Possible Sources of Sampling bias:
* All the tests were done only on one day - since the optometrists were only free one day per week.
* All the patients were past patients of LVPEI

# Exploratory model and interpretation
The first model which was run was on all covariates and with MR No. included. This, as expected, gave a very high coefficient of determination, R² = 0.9761. Of course it was overfitting to the data, as the residuals plot showed most points on the 0 line. 

![Overfit](https://raw.githubusercontent.com/derbedhruv/folding_phoropter_data_analysis/master/plots/overfit_residuals.jpeg)

Removal of the MR No categorical covariate resulted in a better model, at least in terms of the residuals. The covariate `Age` had an extremely low p-value of 0.000569, indicating that there was a statistically significant relationship at the 0.001 significance level. The overall R² = 0.7245.

The next step was to try a forward stepwise selection in R to select appropriate covariates.
