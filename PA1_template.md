# Reproducible Research: Peer Assessment 1
by Reinald Kim T. Amplayo

## Loading and preprocessing the data
Show any code that is needed to

1. Load the data (i.e. read.csv())


```r
data = read.csv("activity/activity.csv", sep=",")
```

2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
complete = data[complete.cases(data),]
```

## What is mean total number of steps taken per day?
For this part of the assignment, you can ignore the missing values in the dataset.

1. Make a histogram of the total number of steps taken each day


```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.1.1
```

```r
day_steps = aggregate(complete$steps, list(date = complete$date), sum)
ggplot(day_steps, aes(x=x)) + geom_histogram()
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

2. Calculate and report the **mean** and **median** total number of steps taken per day


```r
print(mean(day_steps$x))
```

```
## [1] 10766
```

```r
print(median(day_steps$x))
```

```
## [1] 10765
```

## What is the average daily activity pattern?
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
mean_steps = aggregate(complete$steps, list(interval = complete$interval), mean)
ggplot(mean_steps, aes(mean_steps$interval, mean_steps$x)) + geom_line()
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
print(mean_steps[mean_steps$x==max(mean_steps$x),])
```

```
##     interval     x
## 104      835 206.2
```

## Imputing missing values
Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```r
not_complete = data[!complete.cases(data), ]
nrow(not_complete)
```

```
## [1] 2304
```

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```r
# Strategy: NA values = 0 (when the device is turned off,
#                         it is assumed that the user is asleep)
new_data = data
new_data[is.na(new_data)] = 0
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
day_steps = aggregate(new_data$steps, list(date = new_data$date), sum)
ggplot(day_steps, aes(x=x)) + geom_histogram()
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 

4. Make a histogram of the total number of steps taken each day and Calculate and report the **mean** and **median** total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
print(mean(day_steps$x))
```

```
## [1] 9354
```

```r
print(median(day_steps$x))
```

```
## [1] 10395
```

```r
# The values differ
# The impact depends on your strategy. In my strategy, the total daily number of steps decreased.
```

## Are there differences in activity patterns between weekdays and weekends?
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
new_data$day_type = ifelse(weekdays(as.Date(new_data$date)) 
                           %in% c("Saturday", "Sunday"), 
                           "weekend", "weekday")
```

2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


```r
mean_steps = aggregate(new_data$steps, 
                       list(interval = new_data$interval,
                            day_type = new_data$day_type), mean)
g = ggplot(mean_steps, aes(interval, x)) + geom_line()
g + facet_grid(. ~ day_type)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 
