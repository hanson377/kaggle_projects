Predicting Home Prices
================

## **Objectives**

In this document, we will explore using a Gradient Boosted model for
predicting home prices within the context of the class Kaggle
competition dataset.

-----

## **Exploratory Data Analysis**

-----

Let us begin by looking at the distribution for the variable we are
attempting to predict, SalePrice.

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](predicting_home_prices_files/figure-gfm/sale%20price%20distribution-1.png)<!-- -->

|     Mean | 10th Percentile |    25th | 50th | 75th | 90th |
| -------: | --------------: | ------: | ---: | ---: | ---: |
| 180.9212 |         106.475 | 129.975 |  163 |  214 |  278 |

-----

## **Factor Variables**

-----

Now that we have an understanding of our predictor variables
distribution, let us move onto identifying which factor variables seem
to have values significantly implacting our key variable. To do this, we
will cycle through a large number of boxplots and test for significance
with simple ANOVA models.

Below, we will examine the following:

1.  Location  
2.  Sales Condition

-----

## **Location**

Below, we examine Location’s impact on Sales Price. First, let us look
at a simple boxplot.

![](predicting_home_prices_files/figure-gfm/look%20at%20location-1.png)<!-- -->

| Factor Value | Sample Size |      Mean | 10th Percentile |     25th |    50th |     75th |     90th |
| :----------- | ----------: | --------: | --------------: | -------: | ------: | -------: | -------: |
| NAmes        |         225 | 145.84708 |        110.0000 | 127.5000 | 140.000 | 158.0000 | 180.3000 |
| CollgCr      |         150 | 197.96577 |        132.9500 | 152.9588 | 197.200 | 225.7250 | 260.1500 |
| OldTown      |         113 | 128.22530 |         87.0000 | 105.9000 | 119.000 | 140.0000 | 161.0000 |
| Edwards      |         100 | 128.21970 |         82.4500 | 101.5000 | 121.750 | 145.2250 | 177.2000 |
| Somerst      |          86 | 225.37984 |        162.2500 | 177.9750 | 225.500 | 252.9195 | 305.2385 |
| Gilbert      |          79 | 192.85451 |        167.5200 | 174.0000 | 181.000 | 197.2000 | 231.6000 |
| NridgHt      |          77 | 316.27062 |        202.5000 | 253.2930 | 315.000 | 374.0000 | 438.2924 |
| Sawyer       |          74 | 136.79314 |        110.5300 | 127.2500 | 135.000 | 149.4625 | 167.1000 |
| NWAmes       |          73 | 189.05007 |        152.0000 | 165.1500 | 182.900 | 205.0000 | 241.2000 |
| SawyerW      |          59 | 186.55580 |        119.7128 | 145.5000 | 179.900 | 222.5000 | 264.2040 |
| BrkSide      |          58 | 124.83405 |         78.6000 | 100.5000 | 124.300 | 141.1750 | 181.5500 |
| Crawfor      |          51 | 210.62473 |        139.0000 | 159.2500 | 200.624 | 239.0000 | 311.5000 |
| Mitchel      |          49 | 156.27012 |        118.6000 | 131.0000 | 153.500 | 171.0000 | 202.0600 |
| NoRidge      |          41 | 335.29532 |        250.0000 | 265.0000 | 301.500 | 341.0000 | 430.0000 |
| Timber       |          38 | 242.24745 |        173.5000 | 186.9000 | 228.475 | 286.1157 | 321.3500 |
| IDOTRR       |          37 | 100.12378 |         55.0000 |  81.0000 | 103.000 | 120.5000 | 140.0400 |
| ClearCr      |          28 | 212.56543 |        151.4000 | 183.7500 | 200.250 | 242.2250 | 277.9000 |
| StoneBr      |          25 | 310.49900 |        188.1000 | 213.5000 | 278.000 | 377.4260 | 476.6142 |
| SWISU        |          25 | 142.59136 |        107.2000 | 128.0000 | 139.500 | 160.0000 | 185.2000 |
| Blmngtn      |          17 | 194.87088 |        164.4240 | 174.0000 | 191.000 | 213.4900 | 239.0312 |
| MeadowV      |          17 |  98.57647 |         78.2000 |  83.5000 |  88.000 | 115.0000 | 131.5400 |
| BrDale       |          16 | 104.49375 |         86.7000 |  91.0000 | 106.000 | 118.0000 | 121.0000 |
| Veenker      |          11 | 238.77273 |        165.0000 | 184.2500 | 218.000 | 282.0000 | 324.0000 |
| NPkVill      |           9 | 142.69444 |        127.9000 | 140.0000 | 146.000 | 148.5000 | 149.8000 |
| Blueste      |           2 | 137.50000 |        126.7000 | 130.7500 | 137.500 | 144.2500 | 148.3000 |

    ## Call:
    ##    aov(formula = SalePrice ~ Neighborhood, data = train)
    ## 
    ## Terms:
    ##                 Neighborhood    Residuals
    ## Sum of Squares  5.023606e+12 4.184305e+12
    ## Deg. of Freedom           24         1435
    ## 
    ## Residual standard error: 53999
    ## Estimated effects may be unbalanced

-----

## **Sales Condition**

Now, we move on to examing Sales Condition’s impact on Sales Price.

![](predicting_home_prices_files/figure-gfm/look%20at%20sale%20condition-1.png)<!-- -->

| Factor Value | Sample Size |     Mean | 10th Percentile |     25th |    50th |    75th |     90th |
| :----------- | ----------: | -------: | --------------: | -------: | ------: | ------: | -------: |
| Normal       |        1198 | 175.2022 |        107.9700 | 130.0000 | 160.000 | 205.000 | 265.2700 |
| Partial      |         125 | 272.2918 |        164.5800 | 193.8790 | 244.600 | 339.750 | 419.9192 |
| Abnorml      |         101 | 146.5266 |         84.9000 | 104.0000 | 130.000 | 172.500 | 220.0000 |
| Family       |          20 | 149.6000 |        103.3000 | 115.5000 | 140.500 | 170.250 | 226.0000 |
| Alloca       |          12 | 167.3774 |         91.4198 | 116.3833 | 148.145 | 202.043 | 268.1030 |
| AdjLand      |           4 | 104.1250 |         81.3000 |  81.7500 | 104.000 | 126.375 | 127.0500 |

    ## Call:
    ##    aov(formula = SalePrice ~ SaleCondition, data = train)
    ## 
    ## Terms:
    ##                 SaleCondition    Residuals
    ## Sum of Squares   1.247649e+12 7.960263e+12
    ## Deg. of Freedom             5         1454
    ## 
    ## Residual standard error: 73991.44
    ## Estimated effects may be unbalanced

From the above, we know a few things. The simple boxplot seems to imply
that ‘Partial’ and ‘AdjLand’ houses might be significantly different
from the other condition types. A post-hoc Tukey test seems to confirm.
Although our ANOVA model itself is not of significance, the Tukey HSD
reveals that there exist significant differences between most conditions
and the two types named above.

As a result, we should generate binaries for these two types and
incorporate them into our model. However, it should be noted that houses
with these conditions are rather small in volume, so we might not expect
them to make a huge difference.
