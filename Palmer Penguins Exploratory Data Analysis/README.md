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
1. The Adélie species constitutes the majority of individuals. And the Chinstrap penguin species has the fewest number of samples.
<img width="647" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/da8e6c80-22cd-4b65-acf9-8be9aa023197">

2. Most pinguins are located on Biscoe island. And only 15% of the penguins are on the Torgersen island.
<img width="669" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/5ebf736c-edb3-425b-bcec-0c0165c89cb4">

3. The sample composition in terms of sex is similar across the various categories of islands and species
<img width="273" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/d437dfb1-c679-46d5-a976-363210aaa23f">
<img width="674" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/e06b3b33-8e3f-45d6-8a27-5819cbd5a8a3">

4. Adelie penguin species is present in all islands, about equally. Torgersen island contains only Adelie penguins. Biscoe island contains only Gentoo penguins. And Dream island contains only Chinstrap penguins.
<img width="442" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/f418fdb0-f104-4ad5-ad4b-78c5320a31bb">

5. Adelie Penguins present smaller culmen and smaller flippers. Adelie and Chinstrap penguins are the penguins that weigth less. Gentoo penguins possess larger flippers and bigger culmens compared to some other species, although they have shallower culmens and are generally heavier. In average Chinstrap penguins present the bigger culmen of all
Adelie and Chinstrap penguins are highly similiar, only diferenciating on culmen length
<img width="556" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/15eb9fc3-9769-4a97-a1a3-065948b5e86a">
<img width="534" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/01f7c7ff-dac3-4403-9790-912d52810dc5">


6. Female penguins have smaller features when comparing to male penguins. This ignoring species conditioning
<img width="533" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/77a0fd45-219c-4aa5-988d-1a9fc357369e">
<img width="510" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/cec6ebeb-fc6e-4e6a-9088-d4689d725505">

7. When analyzing correlation with features, we can see the body mass of a penguin is highly correlated with the flipper length of the same.Also the culmen length is positvely correlated with the flipper length and the body mass. On the other hand, culmen depth is negatively correlated with the flipper length of a penguin. The fact the penguin is male or not, is slightly correlated with the physical features, specially body mass
<img width="389" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/ec1f8e49-8ba8-46ed-a56d-3bb687ce3b01">

# License
Gorman KB, Williams TD, Fraser WR (2014) Ecological Sexual Dimorphism and Environmental Variability within a Community of Antarctic Penguins (Genus Pygoscelis). PLoS ONE 9(3): e90081. doi:10.1371/journal.pone.0090081

[^1]: Where I will list the process of the project, for more detail about findings and code check the Notebook.
