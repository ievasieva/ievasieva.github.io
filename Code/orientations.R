##########################################################
##                                                      ##
## Construct validity and reliability test for          ##  
## ORIETATION SCALES / VALUE ITEMS                      ##  
##                                                      ##
##########################################################

#In order to measure top-management commitment to strategic paradoxes and logics 
#that they are exposed to, we used the organizational identity scale developed by @Voss2006. 
#The scales investigate five values - artistic, achievement, prosocial, customer and financial. 
#We made small modifications in the wording of the items to match the for-profit setting, 
#since the original scales were developed for the non-profit artistic sector. 
#The artistic value dimension was renamed as creative value dimension and an additional dimension 
#of entrepreneurial values adapted from @Srivastava2013 was added. 
#All constructs were measured using a 7-point Likert scale, inviting the respondents to indicate 
#how important the statements are to their firm's identity. 




#The original study treats them as separate constructs, so we first run a Confirmatory Factor Analysis (CFA) 
#specifying a model with 6 different logics that firms can commit to. However, there were several issues. 
#Firstly, the responses on items of the market values scale were highly skewed towards 7, 
#with only 4 respondents answering lower than 6. We removed those items. 

#Secondly, the items of creative, achievement, and social values were highly correlated. 



#Thirdly, the entrepreneurial values scale had very low factor loadings. 
#Therefore, we aggregated the first three concepts under the concept of "Creative Orientation" 
#and retained only the financial values under the concept of "Business Orientation". 
#We specified another model for CFA, and only retained the items with satisfactory loadings. 




## @knitr





#CONFIRMATORY FACTOR ANALYSIS VALUES
#------------------------------------

#Make a data frame that only includes data for values variables
values <- bots[,grepl("values", names(bots))]

#Check the distributions for non-normalities
apply(values, 2, hist, xlab= "Likert score")

#After the examination, we took out the market value data, since they were highly skewed. 
values <- values[,!grepl("Market", names(values))]

#Correlation matrix (lower part)
lowerCor(values)

#Finding the number of factors
fa.parallel(values) #analysis suggests 3 factors 
vss(values) #3 or 4 factors

#CFA using the psych package
test.simple <- fa(r=cor(values, use="complete.obs"), nfactors=3, fm="ml", rotate="oblimin")
test.simple
fa.diagram(test.simple, cut = .4, digits = 2)
test.simple$loadings
test.simple$valid

#using the clustering algorithm (a simpler alternative to CFA)
iclust(values)
Phi <- test.simple$Phi
fa.diagram(test.simple$loadings,Phi=Phi,main="Input from a matrix")
fa.diagram(ICLUST(values,3,title="Two cluster solution"),main="Input from ICLUST")

omega(values)

psych::alpha(values) #score all of the items as part of one scale.

keys.list <- list(creative=c(6,7,4,8,3,5,2), entrepreneurial=c(15,14,13,1), 
                  financial=c(11,10,16,12,9))

myKeys <- make.keys(values,keys.list)
my.scores <- scoreItems(myKeys,values) #form several scales
print(my.scores, short = FALSE) #show the highlights of the results


#Creating a data frame for Structural equation model using the sem package. 
mydata <- values
colnames(mydata) <- paste("X", 1:16, sep="")

## MODEL specification 
HS.model <- ' artistic  =~ X1 + X2 + X3
achievement =~ X4 + X5 + X6
social   =~ X7 + X8 + X9 
financial =~ X10 + X11 + X12 + X16
entrepreneurial =~ X13 + X14 + X15'

fit <- cfa(HS.model, data=mydata)
summary(fit, fit.measures=TRUE)

HS.modelEFA <- ' creative  =~ X2 + X6 + X7 + X8
financial =~ X10 + X11 + X16'

fitEFA <- cfa(HS.modelEFA, data=mydata)
summary(fitEFA, fit.measures=TRUE)

model.reliabilityEFA <- round(reliability(fitEFA), digits = 3)
print(model.reliabilityEFA)

parameterEstimates(fitEFA)
inspect(fitEFA,what="std")$lambda


##From the pre-test we retained two orientations - creative and financial.
#We excluded market orientation due to the very skewed responses on the items. 

bots2$MeanCO <- rowMeans(bots[,c("Q15_VC_3", "Q15_VA_3", "Q15_VS_1", "Q15_VS_2")]) 
bots2$MeanBO <- rowMeans(bots[,  c("Q15_VF_1", "Q15_VF_2", "Q15_VF_4")])