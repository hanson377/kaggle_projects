Predicting Survival on the Titanic:
================

**Objective:** Compare the predictive power of the following methods:

1.  Logistic Regression  
2.  Classification Tree
3.  Random Forest  
4.  Gradient Boosting

After comparing the above methods, apply model to test data supplied by
Kaggle and upload to see how I rank among other Kaggle Users.

## **Exploratory Data Analysis**

First, we will explore our data to identify key variables that we might
want to include in any predictive model. To do this most efficiently, we
will first define a few functions to quickly cycle through and visualize
differences across factor variables and their values as they relate to
survival rates.

Now that we have some functions, we can quickly calculate survival rates
and visualize them alongside eachother.

![](summary_findings_files/figure-gfm/compare%20survival%20rates%20across%20values%20for%20key%20factor%20variables-1.png)<!-- -->

## **Model Training**

Now that we have our key variables, let us train a few different models
with the variables we identified above. We will then compare the
accuracy of these different models. Namely, we will be comparing
logistic regression, classification trees, and random forest methods.

In the code below, you will the code I use for generating these models.

-----

### **Classification Tree**

-----

``` r
set.seed(1431)

tree <- tree(Survived~.,data=train)
prediction_tree <- predict(tree, train, type="class")  # predicted scores
```

-----

### **Logistic Regression**

-----

``` r
logistic <- glm(Survived~.,data=train,family='binomial')

prediction_logit <- predict(logistic, train, type="response")  # predicted scores

optCutOff <- optimalCutoff(train$Survived, prediction_logit)
prediction_logit <- ifelse(prediction_logit >= optCutOff,1,0)
prediction_logit <- factor(prediction_logit)
```

-----

### **Random Forest**

-----

``` r
forest_model <- randomForest(Survived~., data=train, ntree=500, proximity=T)
prediction_forest <- predict(forest_model, train, type="response")  # predicted scores
```

-----

### **Gradient Boosting**

-----

``` r
temp <- train
temp$Survived <- as.numeric(temp$Survived)

temp$Survived <- temp$Survived-1

boosting_model <- gbm(Survived~., data=temp, distribution='bernoulli',n.trees=10000,interaction.depth=8,shrinkage=0.001)
prediction_boost <- predict(boosting_model, train, n.trees=10000, type = 'response')  # predicted scores

optCutOff <- optimalCutoff(temp$Survived, prediction_boost, optimiseFor = 'misclasserror')
prediction_boost <- ifelse(prediction_boost >= optCutOff,1,0)
prediction_boost <- factor(prediction_boost)

remove(temp)
```

## **Model Results**

Now that we have our models conditioned, lets compare the accuracy of
our models. We will compare our models on three key metrics:

1.  Misclassification Rates
2.  Sensitivity
3.  Specificity

From the view below, it seems that our gradient boosted model has a
slight edge over the random forest for the misclassification rate. Given
that this Kaggle competition is optimizing for misclassification error,
we will use the gradient boosted model for submission to Kaggle.

![](summary_findings_files/figure-gfm/view%20key%20model%20summary%20metrics%20side%20by%20side-1.png)<!-- -->

## **Predictions**

Now that we have a clear winner in the gradient boosted model, lets take
that model and apply it to the test data supplied by Kaggle.

``` r
test <- read.csv("/Users/hanson377/Documents/GitHub/kaggle_projects/Titanic/data/test.csv")
temp <- prepare(test)
test <- data.frame(PassengerId = test$PassengerId,temp)
rm(temp)

test$Survived <- predict(boosting_model, test, type="response")  # predicted scores
```

    ## Using 10000 trees...

``` r
test$Survived <- ifelse(test$Survived >= optCutOff,1,0)

final <- test %>% select(PassengerId,Survived)
final$Survived <- as.numeric(final$Survived)
write.csv(final, "/Users/hanson377/Documents/GitHub/kaggle_projects/Titanic/data/gender_submission.csv", row.names=FALSE)
```
