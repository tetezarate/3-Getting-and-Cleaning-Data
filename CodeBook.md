## Getting & cleaning data course project

The `run_analysis.R` script cleaned the dataset and leaves tidy data to work with. This was done through the following steps:

1. Prepare data
2. Merge dataset
3. Extract mean and std measurements
4. Descriptive names
5. Appropriate labels
6. Independent dataset

#### 1. Prepare data
In this step the data was downloaded and the different databases where assigned to an R variable in order to proceed with the cleaning tasks. 

#### 2. Merge dataset
using the *rbind* function datasets `X`, `Y` and `subject` where created. The datasets used to create this new datasets were:

* `X` (rows, columns)
+ `x_train` (rows, columns)
+ `x_test` (rows, columns)

* `Y` 
+ `y_train`
+ `y_test`

* `subject`
+ `subject_train`
+ `subject_test`

Finally, through a `cbind()`, all (`X`, `Y` and `subject`) datasets are taken together to create the database which will be tidied.

#### 3. Extract mean and std measurements
A new database is created by selecting only the columns: subject, code and the measurements on the mean and standard deviation (std) for each measurement

#### 4. Descriptive names
For the code column which has a number in it instead of a descriptive name, a left join is applied in order to obtain the new database with the descriptive names of the activities.

#### 5. Appropriate labels
Convert the column named `code` in `ndb_named` into `activities`
Convert all column names with the following:

+ `Acc` into `Accelerometer`
+ `Gyro` into `Gyroscope`
+ `BodyBody` into `Body`
+ ``Mag` into `Magnitude`

Columns that: 
+ start with `f` replace by `Frequency`
+ start with `t` replace by `Time`

#### 6. Independent dataset
Use dataset from step four and create a second tidy data set which contains the average of each variable for each of the activities and subjects



