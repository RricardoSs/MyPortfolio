# Palmers Penguins Exploratory Data Analysis Project 🐧

## Context
The Palmerpenguins is a great dataset for data exploration & visualization, and for this project I will be suing Python, and libraries like seaborn and matplotlib to analyze and visualize this dataset. The data was collected and made available by _Dr. Kristen Gorman and the Palmer Station, Antarctica LTER_, a member of the Long Term Ecological Research Network. The dataset contains a simplified version of the data collected in 3 Antarctica Islands that refers to the species and characteristics of a sample of penguins over 3 studies.

## Task
With this in mind my objective with this project is to conduct an explorative analysis of the physical characteristics of each penguin species, along with their corresponding distribution across the studied islands. By delving into these aspects, my goal is to gain deeper insights into the unique characteristics of each species within the penguin population.

## Outline [^1]
The initial phase of the project involved setting up the notebook by importing necessary libraries and loading the dataset. Following the setup phase, an overview was conducted to familiarize with the format and content of the dataset. Subsequently, a brief cleaning phase was undertaken, during which rows containing mostly missing values were removed, despite not being the primary focus or within the scope of the project.

Beginning the exploratory analysis, the initial step was to generate summary statistics for each physical characteristic. This was done to provide insights into the central tendency, dispersion, and overall distribution of the data. No variable stood out with unusual or unreasonable values, except for ```body_mass_g```, where there was a notable difference between the mean and median. This discrepancy raised concerns and alerted to the possibility of outliers. However, further examination through visualizations confirmed that no outliers were identified in the dataset.

Following the summary statistics, an univariate analysis was conducted to analyze the distribution of each variable and understand its variation within the dataset. This involved examining each variable individually, using visualizations such as histograms, pie charts, and density plots to explore the distribution of values and identify any patterns or outliers. 

Following the univariate analysis, a bivariate analysis was conducted to examine the relationship between pairs of variables and understand how they interact within the dataset. This involved exploring the distribution of two variables together in order to uncover patterns.

In concluding the exploratory analysis, a correlation matrix was employed to delve deeper into the relationships between multiple variables simultaneously. This approach allowed for the examination of how variables interacted with each other and provided insights into complex patterns or dependencies within the dataset.

## Findings
This project aimed to conduct an explorative analysis of the physical characteristics across the sample of study penguins on the 3 Islands. Through this analysis, I gained valuable insights into the unique traits of each species within the penguin population.

Key observations include the common occurrence of Adélie species with presence in all islands, the relatively lower presence of Chinstrap penguins, and the notable concentration of penguins on Biscoe Island. Notably, Torgersen Island exclusively hosts Adélie penguins, while Biscoe Island is home to Gentoo penguins, and Chinstrap penguins inhabit Dream Island.

Additionally, I observed similarities and differences in physical characteristics among species, with Gentoo penguins exhibiting larger flippers and culmens, albeit shallower culmens and heavier weights. Notably, female penguins generally have smaller features compared to males, regardless of species.

Correlation analysis revealed significant associations between various physical features, with body mass strongly correlated with flipper length and culmen length positively correlated with both flipper length and body mass. Interestingly, culmen depth exhibited a negative correlation with flipper length. Furthermore, while the sex of the penguin showed slight correlation with physical features, it was not a significant determining factor.

Overall, this project sheds light on the intricate relationship between penguin species, their physical characteristics, and their habitat preferences, offering valuable insights.

# License
Gorman KB, Williams TD, Fraser WR (2014) Ecological Sexual Dimorphism and Environmental Variability within a Community of Antarctic Penguins (Genus Pygoscelis). PLoS ONE 9(3): e90081. doi:10.1371/journal.pone.0090081

[^1]: Where I will list the process of the project, for more detail about findings and code check the Notebook.
