#Change the path below to the location of the file you downloaded
setwd('~/Documents/Workshops/ml_lecture/homePricesKaggle/')
#Show all files in the directory
list.files()
#Load in the datasets
train_df <- read.csv('train.csv',stringsAsFactors = F)
test_df <- read.csv('test.csv',stringsAsFactors = F)
head(train_df)#Preview first 6 rows
dim(train_df)# get rows x columns
nrow(train_df)# just rows (N)
ncol(train_df)# just columns
ncol(test_df)# One less column? 
#Which column is missing?
missing_col <- which(!(colnames(train_df) %in% colnames(test_df)))
colnames(train_df)[missing_col] #The sale price is missing! Kept a secret on Kaggle for evaluation!

#Lets take a look at some of our data:
summary(train_df)#A summary of every column
#We may want to apply a few transformations to our data. 
  #To make our life simple, lets merge all of the data together, do the transformations,
    #then re-separate the data.
#First remove the sales data from the training data
y_train <- train_df[,missing_col]
train_df <- train_df[,-missing_col]
train_df$Train_Flag <- T
test_df$Train_Flag <- F
#Stack the training and test data together
all_data <- rbind.data.frame(train_df,test_df)
dim(all_data)

#First lets look at our target variable (sales)
hist(y_train) #Distribution is highly skewed; What transformation might we apply?
summary(y_train)
log_y_train <- log(y_train)
summary(log_y_train) #ahhh, much better
#How close to a normal distribution is our data now?
#Plot an empirical probability density function of our data
plot(density(log_y_train),typ='l')
#Overlay a simulated normal distribution with the same mean and standard deviation
lines(density(rnorm(10000,mean(log_y_train),sd(log_y_train))),col = 2)

#Now lets move on to our exogenous variables (our x's)
#First lets check how much 'missing' data we have; R codes up missing values with an NA
#The apply function applies operations either row by row (index = 1), or, column by column (index = 2)
sort(apply(all_data,2,function(x)sum(is.na(x))/length(x)))
#Looks like 'missing' data begins with Exterior1st; Lots of missing data for PoolQC.
  #To the docs!
#NA for PoolQC (pool quality) applies to homes with no pool.
#NA for Fence implies no fence.
#etc. 
#R will drop any rows that contain an NA; we can replace these NAs with a different code like 'None' then treat them as part of a 'one-hot-encoding'
all_data$PoolQC[is.na(all_data$PoolQC)] <- 'None'
all_data$MiscFeature[is.na(all_data$MiscFeature)] <- 'None'
all_data$Alley[is.na(all_data$Alley)] <- 'None'
all_data$Fence[is.na(all_data$Fence)] <- 'None'
all_data$FireplaceQu[is.na(all_data$FireplaceQu)] <- 'None'
all_data$MasVnrType[is.na(all_data$MasVnrType)] <- 'None'
all_data$MasVnrArea[is.na(all_data$MasVnrArea)] <- 0
all_data$MSZoning[is.na(all_data$MSZoning)] <- names(which.max(table(all_data$MSZoning)))
all_data$Functional[is.na(all_data$Functional)] <- 'Typ'
all_data$Electrical[is.na(all_data$Electrical)] <- names(which.max(table(all_data$Electrical)))
all_data$KitchenQual[is.na(all_data$KitchenQual)] <- names(which.max(table(all_data$KitchenQual)))
all_data$Exterior1st[is.na(all_data$Exterior1st)] <- names(which.max(table(all_data$Exterior1st)))
all_data$Exterior2nd[is.na(all_data$Exterior2nd)] <- names(which.max(table(all_data$Exterior2nd)))
all_data$SaleType[is.na(all_data$SaleType)] <- names(which.max(table(all_data$SaleType)))
all_data$MSSubClass[is.na(all_data$MSSubClass)] <- 'None'
all_data <- all_data[,-which(colnames(all_data) == 'Utilities')]
#Some of the basement features are categorical and some are numeric
bsmt_cols <- grep('Bsmt',colnames(all_data))
bsmt_cols_numeric <- bsmt_cols[c(5,7:11)]
for(col in bsmt_cols){
  if(col %in% bsmt_cols_numeric){
    all_data[is.na(all_data[,col]),col] <- 0
  }else{
    all_data[is.na(all_data[,col]),col] <- 'None'
  }
}
#Some of the garage features are categorical and some are numeric
garage_cols <- grep('Garage',colnames(all_data))
garage_cols_numeric <- garage_cols[c(2,4,5)]
for(col in garage_cols){
  if(col %in% garage_cols_numeric){
    all_data[is.na(all_data[,col]),col] <- 0
  }else{
    all_data[is.na(all_data[,col]),col] <- 'None'
  }
}
#Okay, now lets check how much missing data we have:
sort(apply(all_data,2,function(x)sum(is.na(x))/length(x)))
#Looks like we got most of it. What about LotFrontage? (Linear feet of street connected to property)
#Most neighborhoods tend to have the same 'lot frontage' lets fill the missing data with the medians of each neighborhood.
nbrhood_median_lot_frontage <- tapply(all_data$LotFrontage,all_data$Neighborhood,function(x)median(x,na.rm = T))
nbrhood_median_lot_frontage
for(i in 1:nrow(all_data)){
  if(is.na(all_data$LotFrontage[i])){
    all_data$LotFrontage[i] <- nbrhood_median_lot_frontage[match(all_data$Neighborhood[i],
                                                                 names(nbrhood_median_lot_frontage))]
  }
}
sort(apply(all_data,2,function(x)sum(is.na(x))/length(x)))
#Wohoo no missing data
  #Now we need to encode our data..we cant run a regression on the word 'None',.., or can we?
  #We want to be very careful with this encoding. 
  #Some times we may have only one data point that falls in a category. 
  #We can encode these 'levels' as 'other'
col_classes <- c()
for(i in 1:ncol(all_data)){
  #Check the class of each column
  col_classes[i] <- class(all_data[,i])
  if(col_classes[i] == 'character'){
    #If the class is a column
    cnts <- table(all_data[,i]) #count frequency of each term
    cnts <- cnts[ifelse(cnts < 50,T,F)] #keep those with a frequency under 50 occurences
    #Replace those with under 50 occurences with 'other'
    all_data[,i] <- ifelse(all_data[,i] %in% names(cnts),'Other',all_data[,i])
    #Code up the occurences as dummy variables
    all_data[,i] <- as.factor(all_data[,i])
  }
}
col_classes
#Lets go check out one of the columns in the docs to make sure we got this right
colnames(all_data)[2]


#^_^ Now to the fun part -> modeling
#Lets separate our training from our test data and remove a few columns
train_clean_data <- all_data[all_data$Train_Flag == T,]
train_id <- train_clean_data$Id
train_clean_data <- train_clean_data[,-which(colnames(train_clean_data) %in% c('Train_Flag','Id'))]
test_clean_data <- all_data[all_data$Train_Flag == F,]
test_id <- test_clean_data$Id
test_clean_data <- test_clean_data[,-which(colnames(test_clean_data) %in% c('Train_Flag','Id'))]

#Lets write a few functions to evaluate the models we fit
evaluator <- function(x,target){
  rmse <- sqrt(mean((x-target)^2))
  mad <- mean(abs(x-target))
  errors <- c(rmse,mad)
  names(errors) <- c('RMSE','MAD')
  return(errors)
}

#Lets see what happens with a simple linear model#
ols_data <- cbind.data.frame(log_y_train,train_clean_data)
mdl <- lm(log_y_train ~ .,data = ols_data)
summary(mdl) #hmm why do we have a few NAs?
#Make predictions on the training data
train_predictions <- predict(mdl)
#How well does the model work?
evaluator(x = train_predictions,target = log_y_train)
evaluator(x = exp(train_predictions),target = exp(log_y_train))
#Make predictions on the test data in dollars#
test_predictions <- exp(predict(mdl,test_clean_data))
submission_df <- data.frame(Id = test_id,
                            SalePrice = test_predictions)
write.csv(submission_df,'simple_ols_model_attempt_1.csv',row.names = F)
#Base line submission gets a test RMSE of 0.20815. 2x our train sample RMSE.
#Our model does well in sample and does poorly out of sample. This is a sign of over fitting!

#Lets try a simple machine learning model: Ridge Regression
#install.packages('glmnet')
library(glmnet)
#Glmnet takes in a model matrix
mdl_matrix <- model.matrix(mdl)
#Cross validate a ridge regression model
mdl_ridge <- cv.glmnet(mdl_matrix,log_y_train,alpha = 0)
plot(mdl_ridge)
plot(mdl_ridge$glmnet.fit)
#Get the best of the cross validated results
best_lambda_ridge <- mdl_ridge$lambda.1se #Best lambda
#Estimate the best model using the tuned parameters
mdl_ridge_final <- glmnet(mdl_matrix,log_y_train,alpha = 0,lambda = best_lambda_ridge)
#Make predictions on the training data
train_predictions_ridge <- predict(mdl_ridge_final,newx = mdl_matrix)
#How well does the model work?
evaluator(x = train_predictions_ridge,target = log_y_train)
#Our model performance seems to have gone down?
evaluator(x = exp(train_predictions_ridge),target = exp(log_y_train))
#Make predictions on the test data in dollars#
test_mdl_mat <- model.matrix(rep(1,nrow(test_clean_data))~.,data = test_clean_data)
test_predictions <- exp(predict(mdl_ridge_final,test_mdl_mat))
submission_df <- data.frame(Id = test_id,
                            SalePrice = test_predictions[,1])
write.csv(submission_df,'simple_ridge_model_attempt_2.csv',row.names = F)
#Our Ridge submission gets a test RMSE of 0.15648! Only 8% higher than our training sample rmse! Not bad
0.15648/0.14373717
#Try out lasso by setting alpha = 1
#Elastic net by removing by setting alpha between 0 and 1 (or removing it; it will be 'tuned')

#How about a random forest?
#install.packages(gbm)
library(gbm)
cores <- detectCores() - 3
mdl_rf <- gbm(log_y_train~.,data = ols_data,distribution = 'gaussian',n.trees = 1000,interaction.depth = 2,n.minobsinnode = 10,cv.folds = 4,n.cores = cores)
summary(mdl_rf)
plot(mdl_rf)
#Make predictions on the training data
train_predictions_rf <- predict(mdl_rf,newx = ols_data)
#How well does the model work?
evaluator(x = train_predictions_rf,target = log_y_train)
#Our model performance seems to have gone down?
evaluator(x = exp(train_predictions_rf),target = exp(log_y_train))

gbmGrid <-  expand.grid(interaction.depth = c(5, 10),
                        n.trees = c(5000,10000),
                        shrinkage = seq(0.001,0.002,length.out = 3),
                        n.minobsinnode = 10)
library(caret)
fitControl <- trainControl(method = "repeatedcv",repeats = 1)

mdl_rf_cv <- train(log_y_train~.,data = ols_data,
            distribution = "gaussian",
            method = "gbm",
            nTrain = round(nrow(ols_data) *.75),
            trControl = fitControl,
            verbose = TRUE,
            tuneGrid = gbmGrid,
            ## Specify which metric to optimize
            metric = "RMSE")

#saveRDS(mdl_rf_cv,'random_forest_mdl.RDS')
mdl_rf_cv <- readRDS('random_forest_mdl.RDS')
mdl_rf_cv$results[which.min(mdl_rf_cv$results$RMSE),]
mdl_rf_cv$bestTune
mdl_rf <- gbm(log_y_train~.,data = ols_data,distribution = 'gaussian',
              n.trees = 10000,interaction.depth = 5,n.minobsinnode = 10,
              cv.folds = 2,n.cores = cores,shrinkage = 0.0015)

#Make predictions on the training data
train_predictions_rf <- predict(mdl_rf,newx = ols_data)
#How well does the model work? 
evaluator(x = train_predictions_rf,target = log_y_train)
evaluator(x = exp(train_predictions_rf),target = exp(log_y_train))
#Make predictions on the test data in dollars#
test_predictions <- exp(predict(mdl_rf,test_clean_data))
submission_df <- data.frame(Id = test_id,
                            SalePrice = test_predictions)
write.csv(submission_df,'random_forest_model_attempt_3.csv',row.names = F)
#Not bad now we have an RMSE of 0.12196...we're definitely moving in the right direction!
  #Now at a global rank of 1,112 out of 4,450 competitors -> top 25% of the world!

#Hmm what else can we do? How about a neural network?
#install.packages('keras')
library(keras)
#install_keras()
#neural nets work with matrices so we will go back to using mdl_matrix
model <- keras_model_sequential()
model %>%
  layer_dense(units = 128,activation = 'relu',input_shape = c(dim(mdl_matrix)[2]),kernel_initializer='uniform') %>%
  layer_dropout(rate = 0.1)%>%
  layer_dense(units = 64,activation = 'relu',kernel_initializer='uniform') %>%
  layer_dropout(rate = 0.1)%>%
  layer_dense(units = 32,activation = 'relu',kernel_initializer='uniform') %>%
  layer_dropout(rate = 0.1)%>%
  layer_dense(units = 16,activation = 'relu',kernel_initializer='uniform') %>%
  layer_dropout(rate = 0.1)%>%
  layer_dense(units = 8,activation = 'relu',kernel_initializer='uniform') %>%
  layer_dropout(rate = 0.1)%>%
  layer_dense(units=1,activation = 'linear')
#?layer_dense
model %>% 
  compile(
    loss='mean_squared_error',
    optimizer = optimizer_sgd(lr = 1e-6),
    metrics = 'mean_squared_error'
  )
#?optimizer_sgd
history <- model %>%
  fit(
    mdl_matrix,log_y_train,
    epochs = 800,batch_size =1,
    validation_split = 0.25,
    callbacks = list(
      callback_early_stopping(monitor = "val_loss",
                              patience = 10, verbose = 0, mode = c("auto"))
  ))

predicted_price <- predict(model,mdl_matrix)
summary(predicted_price)
cor(predicted_price,train_predictions_rf)
evaluator(predicted_price,log_y_train)
#Make predictions on the test data in dollars#
test_predictions <- exp(predict(model,test_mdl_mat))
submission_df <- data.frame(Id = test_id,
                            SalePrice = test_predictions)
write.csv(submission_df,'nn_model_attempt_4.csv',row.names = F)

summary(submission_df$SalePrice)



