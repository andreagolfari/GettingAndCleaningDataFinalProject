---
title: "README.md"
output: html_document
---

## Getting and Cleaning Data Course Final Project

This repository is my submission for the final project of the Getting and Cleaning Data course.

It uses data collected from the accellerometers and gyroscopes in smartphones that was collected from 30 volunteers while engaged in different activities.
More specific information on the experiment is available from this webpage:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

* ```CodeBook.md``` provides a description of the steps performed by the code in the script ```run_analysis.R```.

* ```run_analysis.R``` contains all the code to download, prepare, clean the data.

1. The data downloaded in several different .txt files in assembled in one dataset
2. The data related to mean and standard deviation of the measurements is isolated
3. Human readable names are given to the activities recorded
4. Human readable labels are given to the variable names
5. A new, indipendent tidy dataset with the mean value for each subject and activity is created

If desired, the new tidy dataset can be exported to a .txt file.
