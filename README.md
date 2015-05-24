## Getting and Cleaning Data (getdata-014) course project script
An R script called run_analysis.R does the following:
* creates working directory, downloads data zip there, perform unzipping data and set working directory
* reads data from txt-files and joins essential columns (using plyr-package function ```join()```)
* filters features-column for only ```mean``` and ```std``` variables
* binds subject/activity columns from the file
* stores resulted tidy dataset with binded columns in ```result```
* performs average of each variable for each activity and each subject using ```aggregate``` and stores resulted tidy data set in ```averages``` variable
* performs export data to the ```averages.txt```