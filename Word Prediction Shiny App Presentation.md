Word Prediction Shiny App Presentation
========================================================
author: JayR
date: 18 July 2020
autosize: true

Word Prediction App - Method
========================================================

  
The phrases used to construct the app are from the following sources in **US English**:

- **blogs**  

- **Twitter**  

- **news articles** 


The app uses a **lookup table** based on these three data sets to determine the next word in a sentence/group of words.


The Lookup Table
========================================================

  
The phrases from the three sources are adjusted in the following ways to form the lookup table:  

- convert words to lower case

- remove punctuation and unusual characters  

- create **ngrams** from the phrases - an *ngram* is a phrase with *n* words

- split the ngrams into two columns: the last word (the predicted next word) and the rest of the words

- for each ngram, count the **frequency** of each possible next word and select the word with the highest frequency as the predicted word.


Features of the app
========================================================

When the app opens, the data needs to load.

During this time there is a **progress bar** at the bottom right and an **animated loading image** to keep the user amused while waiting for the data to load. This only has to be done once during each session.

****

The app uses the **ff** and **ffbase** packages to use a type of dataframe that can be loaded using less memory.


![](snapshot2.JPG)


How to use the app
======================================================

Once the data has loaded, the user can input a phrase into the input textbox in the top left.

The predicted next word will then appear under the user's phrase on the right.

The user can then input more sets of words to obtain further predictions.

![](snapshot.JPG)



