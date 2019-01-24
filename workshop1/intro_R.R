####INTRO TO R####
## To run line(s) of code from a script 
  #Single line: Mac = CMD+Enter; Windows = CNTRL+Enter
  #Multiple lines: highlight the lines than use above
###Numerical Operations###
#Addition
2 + 2
#Subtraction
2-2
#Multipicatoin
2*2
#Division
2/2

##Declaring objects##
  #use either <- or = 
x <- 1
y = 2
x = y
y <- 3
x;y #Use colon to run multiple commands on same line

###Main objects in R###
#Atomic Vector: c(...) where ... objects to be concatenated 
  #character: "a" or 'a'
  #numeric: 1.0
  #integer: 1
  #logical: True/False or T/F
  #complex: (1+2i)

##Character
example_vector_char <- c('the','cat','in','the','hat')
example_vector_char[1:3]

sort(unique(example_vector_char))
sort(example_vector_char)
paste('file',1:5,sep='_')

nchar(example_vector_char) #number of characters
paste(example_vector_char,collapse = ' ') #paste elements together
rev(example_vector_char) #reverse ordering
x <- gsub('h','',example_vector_char) #replace h with nothing in all elements of example_vector_char
grepl('h',example_vector_char) #index of those with h
example_vector_char[grep('h',example_vector_char)]
grepl('h',example_vector_char) #logical if there is an h

which(grepl('h',example_vector_char)|grepl('a',example_vector_char)) #which are T #Chain commands inside done before outside

substr(example_vector_char,1,1) #Substring from character 1 to 1 of the string 
strsplit(example_vector_char,'h') #Split the character string around h

##Numeric
example_vector_numeric <- seq(1,1000,by = 0.1)
head(example_vector_numeric,10)
tail(example_vector_numeric,10)
sum(example_vector_numeric)
tail(cumsum(example_vector_numeric)) 
mean(example_vector_numeric)
median(example_vector_numeric)
quantile(example_vector_numeric,0.25)
summary(example_vector_numeric)
hist(example_vector_numeric)
which(example_vector_numeric == 434)# == for a logical check
?plot
plot(example_vector_numeric,typ = 'l',xlab = 'X-AXIS LfdasL',
     ylab = 'Y-AXIS LABEL',main ='MAIN LABEL',col = 2)
hist(example_vector_numeric)#histogram

?runif
example_vector_numeric <- rnorm(1000,mean = 1,sd = 1) #Thousand standard normal draws
hist(example_vector_numeric)
plot(density(example_vector_numeric))

example_vector_numeric_2 <- rnorm(1000,mean = 20,sd = 1)
hist(example_vector_numeric_2)
#Dot product
c(1,2,3,4) %*% matrix(c(1,2,3,4,5,6,7,8),4,2)

example_vector_numeric %*% example_vector_numeric_2

#Element wise operations
example_vector_numeric * example_vector_numeric_2


##Logical
T == TRUE
T == F
F == FALSE
T != F # ! indicates Not
F != F
T + T #True is coded as a 1 in R and F is coded as a 0
F + T
F + F
T*T
T | F# Vertical bar is an OR statement -> One needs to be true
F | F
T & F #& represents an AND statement -> both need to be true
T & T
F & F

##Factors: Reduce memory in your system
example_factor <- sample(rep(c('boy','girl'),100))
head(example_factor)
class(example_factor)
example_factor <- as.factor(example_factor)
head(example_factor)
class(example_factor)
levels(example_factor)
nlevels(example_factor)
as.numeric(example_factor) #Will return the factor level
as.numeric(as.factor(c('2','32','2','1','3')))#WRONG
as.numeric(as.character(as.factor(c('2','32','2','1','3'))))#Hurray


#Matrix: All entries are of the same type (character, factor, etc..) 

example_matrix <- matrix(NA,nrow = 10,ncol = 5)
dim(example_matrix)
head(example_matrix)
example_matrix[2,3] <- 3
head(example_matrix)
example_matrix[2,] <- 3
head(example_matrix)
na.omit(example_matrix)
example_matrix <- matrix(rnorm(50),nrow = 10,ncol = 5)
example_matrix_2 <- matrix(rnorm(50),nrow = 5,ncol = 10)
dim(example_matrix %*% example_matrix_2)

#Dataframe: All entries in a COLUMN are of the same type (character, factor, etc..)
example_df <- data.frame(a = c('apple','orange'),b = c(1:2),c = factor(c('boy','girl')))
class(example_df$a)
example_df$a <- as.character(example_df$a)
#Can access column vector data using df_name$column_name
nrow(example_df)
ncol(example_df)

#List: can hold multiple objects
example_list <- list(example_vector_char,
                     example_vector_numeric,
                     example_matrix,
                     example_df)

example_list[[1]][2]
head(example_list[[2]])
head(example_list[[3]])
head(example_list[[4]])
str(example_list)
length(example_list)


##Functions
#There are tons of built in functions..and even more avaialbe open source through CRAN
  #https://cran.r-project.org/web/packages/available_packages_by_name.html
#But you can make your own functions too
my.function <- function(x,y){
  (x + y)^2
}
my.function(1000,1000)

#options(scipen = 10)
andyFunction <- function(x,y){
  gen_dat_1 <- rnorm(1000,x,x^2)
  gen_dat_2 <- rnorm(1000,y,y^2)
  plot(gen_dat_1,gen_dat_2)
  return(sum(ifelse(gen_dat_1 > gen_dat_2,T,F)))
}
res <- andyFunction(100,200)
res

##Conditional Statment
if((2+2) == 5){
  #DO THIS
  print('HI')
}else{
  #DO SOMETHING ELSE
  print('NO')
}

#Can also be simplified quickly to 
ifelse(4> 3,'HI','NO')


#####Loops
#For
for(cat in 1:4){
  if(cat == 2){
    print('YO')
  }else{
    print(cat*2)
  }
}

for(row in 1:nrow(example_df)){ #Can nest loops -> gets slow 
  for(col in 1:ncol(example_df)){
    print(example_df[row,col])
  }
}

#Apply family
sapply(1:4,function(x)print(x)) #apply a function to a loop

apply(example_matrix,1,sum) #Rowwise loop through matrix
for(i in 1:nrow(example_matrix)){
  print(sum(example_matrix[i,]))
}

apply(example_matrix,2,sum) #Columnwise loop through matrix 1:ncol(example_matrix)
for(j_col in c(1,41,21,21)){
  print(j_col)
  #print(sum(example_matrix[,j_col]))
}


lapply(example_list,length) #Apply a function to each element of a list

#While loop
itr <- 1
while(itr <= 10){
  print(itr)
  itr <- itr + 1
}


##Repeat until
readinteger <- function(){
  n <- readline(prompt="Please, enter your ANSWER: ") 
}

repeat {   
  response <- as.integer(readinteger())
  if (response == 42) {
    print("Well done!")
    break
  } else print("Sorry, the answer to whatever the question MUST be 42")
}


##Plotting
plot(cos(1:100),typ = 'h',col=ifelse(cos(1:100) > 0,3,2),xlab = '',ylab = 'Cos(x)',ylim=c(-2,2))
lines(cos(1:100),col = 4)
legend('topleft',legend = c('Greater 0','Less 0'),col = 3:2,lty = 1)
text(50,1,'Yo')

rand_dat <- matrix(NA,100,10)
for(i in 1:ncol(rand_dat)){
  rand_dat[,i] <- rnorm(100,i,i^0.2)
}

plot(rand_dat[,1],typ = 'l',xlab = '',ylab = '',ylim=c(min(rand_dat),max(rand_dat)))
for(i in 2:ncol(rand_dat)){
  lines(rand_dat[,i],col = i)
}



#The data give the speed of cars and the distances taken to stop. Note that the data were recorded in the 1920s.
head(cars)
plot(cars$speed,cars$dist,xlab = 'Speed',ylab = 'Distance',main = 'Stopping Distance')
mdl <- lm(cars$dist~cars$speed)
mdl
summary(mdl)
mdl$coefficients
mdl$residuals
plot(cars$speed,cars$dist,xlab = 'Speed',ylab = 'Distance',main = 'Stopping Distance')
abline(mdl,col = 2)


##Can look into ggplot as well
##http://rstudio-pubs-static.s3.amazonaws.com/12581_042080eb6d9a498da1f7dc99238e2efc.html
head(mtcars)
install.packages('ggplot2')
library(ggplot2)