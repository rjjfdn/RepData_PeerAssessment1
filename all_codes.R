library(ggplot2)

data = read.csv("activity/activity.csv", sep=",")

complete = data[complete.cases(data),]

day_steps = aggregate(complete$steps, list(date = complete$date), sum)
ggplot(day_steps, aes(x=x)) + geom_histogram()

print(mean(day_steps$x))
print(median(day_steps$x))

mean_steps = aggregate(complete$steps, list(interval = complete$interval), mean)
ggplot(mean_steps, aes(mean_steps$interval, mean_steps$x)) + geom_line()

print(mean_steps[mean_steps$x==max(mean_steps$x),])

not_complete = data[!complete.cases(data), ]
nrow(not_complete)

new_data = data
new_data[is.na(new_data)] = 0

day_steps = aggregate(new_data$steps, list(date = new_data$date), sum)
ggplot(day_steps, aes(x=x)) + geom_histogram()

print(mean(day_steps$x))
print(median(day_steps$x))

new_data$day_type = ifelse(weekdays(as.Date(new_data$date)) 
                           %in% c("Saturday", "Sunday"), 
                           "weekend", "weekday")

mean_steps = aggregate(new_data$steps, 
                       list(interval = new_data$interval,
                            day_type = new_data$day_type), mean)
g = ggplot(mean_steps, aes(interval, x)) + geom_line()
g + facet_grid(. ~ day_type)