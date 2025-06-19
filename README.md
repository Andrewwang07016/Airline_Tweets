
1. Setup

Begin by setting up the title, author, and output of your programming project. This is also a good time to load the libraries or packages, which are tools that extend the language's base functions.


2. Cleaning

Next, load the data into the workspace, and clean the data so that it is ready for analysis. This program deletes extra columns that is not needed, filters out the data to keep tweets relevant, turned the data into a corpus in order to standardize structure. Lowercased the texts, removed common stop words, got rid of numbers, and removed punctuation.


3. Analysis One

In analysis one, we used wordcloud to analyze the tweets. This is done by loading the data again, however this time we've examined the data and made the necessary updates to prepare the tweet texts for analysis. To do this, the cleaned tweets are turned into a matrix or a table. Then the words are counted across all tweets and sorted in decreasing order. A word cloud is then created which shows the collection of the top 50 most used words, their sizes based upon their frequency used.


4. Analysis Two

In analysis two, we used topic modeling to analyze the tweets. The data is converted into a document term matrix like a table with the frequency of each texts. Then the LDA algorithm is used to identify five distinct topics grouped based upon their similarity. These results are then prepared for an interactive visualization which uncovers deeper insights and analysis.


5. Visualization

In this final section we used the ggplot2 library to create a high quality graphs. After turning the categories into tables we use ggplot() to create a bar plot and an additional second chart that shows the top 20 most frequent words found in the tweets.

