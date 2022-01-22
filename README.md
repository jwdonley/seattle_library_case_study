# Seattle Library Subject Traffic Case Study

Using the Seattle Public Library's data set available via the Seattle government website, I want to learn how read interests have shifted since the start of the pandemic.

The data consists of rows each containing the number of times every items has been checked out each month. It also includes the subjects pertaining to that item.

I started by loading the raw data into a PostgreSQL database table. I then processed the raw data into a simple schema to make it easier for me to query the information.

Next I will build and populate a report data aggregating on the number of times each month an item of each subject was checked out.
