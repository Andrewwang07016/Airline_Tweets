
---
author: "Andrew Wang, David Duong, Isabelle Bolen, Mathew Luu"
output: html_document
---



```{r setup}
#add libraries

library(wordcloud2)
library(tm)
```

## Cleaning



```{r, 'cleaning'}

#reads in csv file
flight <- read.csv('Tweets-1.csv')

#get rid of unneeded columns
flight <- flight[,-c(1, 3, 5, 7,8, 9, 10, 12, 13, 14, 15)]

#removes any row that does not contain 'United' within the airline column
flight <- flight[grepl('United', flight$airline), ] 



#Creates a corpus from the text column
text.corpus <- Corpus(VectorSource(flight$text))

#lower case all characters
text.corpus <- tm_map(text.corpus, content_transformer(tolower))

#remove stopwords
text.corpus <- tm_map(text.corpus, removeWords, stopwords("en"))

#remove numbers
text.corpus <- tm_map(text.corpus, removeNumbers)

#remove punctuation
text.corpus <- tm_map(text.corpus, removePunctuation)


```

## Analysis 1



```{r, 'step 1'}
#load packages
library(tm)
library(wordcloud)
library(wordcloud2)
library(stopwords)

#load the data
TweetData <- read.csv("Tweets-1.csv")
str(TweetData)
TweetData <- TweetData$text
#check data
str(TweetData)
head(TweetData)

#clean data so that only united remains
TweetData <- TweetData[grep("@united", TweetData)]
TweetData <- TweetData[-c(1:2)]
head(TweetData)

#character vector source for corpus
TweetData.vec <- VectorSource(TweetData)
TweetData.corpus <- Corpus(TweetData.vec)
TweetData.corpus

#lowercase values
TweetData.corpus <- tm_map(TweetData.corpus, content_transformer(tolower))
#removes numerical values
TweetData.corpus <- tm_map(TweetData.corpus, removeNumbers)
#removes punctuation
TweetData.corpus <- tm_map(TweetData.corpus, removePunctuation)
#removes stop words
TweetData.corpus <- tm_map(TweetData.corpus, removeWords, stopwords("english"))
#removes specific words
TweetData.corpus <- tm_map(TweetData.corpus, removeWords, c("@united", "can", "just", "flight"))
head(TweetData)

#create document term matrix
TermDoc <- DocumentTermMatrix(TweetData.corpus)
TermDoc
inspect(TermDoc)

#dtm to rm
RegularMaxtrix <- as.matrix(TermDoc)
textCount <- rowSums(RegularMaxtrix)
textCount <- sort(textCount, decreasing = TRUE)
head(textCount)

#extracts terms from dtm
Terms <- Terms(TermDoc)
#select top terms
TopTerms <- Terms[as.numeric(names(textCount))]
#rename as the top terms
names(textCount) <- TopTerms

#setting the seed for fixed results
set.seed(123)

#dataframe of words corresponding to frequencies
cloudFrame <- data.frame(word = names(textCount), freq = textCount)
head(cloudFrame)

#using wordcloud
wordcloud(cloudFrame$word, cloudFrame$freq, max.words = 50)

#adjust the plot area
par(mar = c(0, 0, 0, 0))
#using wordcloud with customization
wordcloud(names(textCount), textCount, colors = brewer.pal(5, "Dark2"), max.words = 50)

#dataframe for word frequencies
wordFreq<- data.frame(word = names(textCount), freq = textCount)
#using wordcloud2
wordcloud2(wordFreq, color = brewer.pal(5, "Dark2"), backgroundColor = "white", size = 0.5, fontFamily = "sans-serif")


```

## Analysis 2



```{r, 'step 2'}
# Analysis 2

# Load the necessary library
library(topicmodels)
library(LDAvis)
library(servr)



# We already have our DTM from the previous steps
dtm <- DocumentTermMatrix(text.corpus)

# Fit the LDA model
lda_model <- LDA(dtm, k = 5, control = list(seed = 1234))

# Get the terms per topic
terms(lda_model, 5)

# Get the topics per document
topics(lda_model)

# Check the distribution of topics in each document
posterior(lda_model)$topics

# Convert dtm to a matrix
dtm <- as.matrix(dtm)

# Create the JSON object to feed the visualization
json <- createJSON(phi = posterior(lda_model)$terms,
                   theta = posterior(lda_model)$topics,
                   doc.length = rowSums(dtm),
                   vocab = colnames(dtm),
                   term.frequency = colSums(dtm))

# Visualize
serVis(json)







```

## Visualization



```{r, 'visualization'}

# Load library
library(ggplot2)

# Count the number of tweets for each sentiment
sentiment_counts <- table(flight$airline_sentiment)

# Convert the sentiment counts to a data frame
sentiment_df <- data.frame(sentiment = names(sentiment_counts),
                           count = as.numeric(sentiment_counts))

# Create the ggplot bar plot
ggplot(sentiment_df, aes(x = sentiment, y = count, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(title = "Sentiment Distribution for United Airlines Tweets",
       x = "Sentiment",
       y = "Number of Tweets") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_fill_manual(values = c("positive" = "green", "negative" = "red", "neutral" = "blue"))



# Create a ggplot word frequency plot 
ggplot(head(cloudFrame, 20), aes(x = reorder(word, freq), y = freq, fill = ifelse(seq_along(word) %% 2 == 0, "skyblue", "darkblue"))) +
  geom_col(color = "black") +
  coord_flip() +
  labs(title = "Top 20 Most Common Words in United Airlines Tweets",
       x = "Word",
       y = "Frequency") +
  scale_fill_identity() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8)) +
  geom_text(aes(label = freq), vjust = -0.2, hjust = -0.4, size = 3) # Add frequency labels on top of bars


```
