# relook
seq(1, 10)
y <- seq(1, 10, leng = 5)
x <- seq(-3, 7, by = 1 / 2)

ggplot(dota = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

# dplyr package
library(nycflights13)
library(tidyverse)
flights

# subset

## two false
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1
near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
filter(flights, month %in% 7:9)
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
# modulo

filter(flights, dep_time %% 2400 <= 600)

filter(flights, between(month, 7, 9))
dim(filter(flights, is.na(dep_time)))

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# arrange, order by
arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))
# Missing values are always sorted at the end:
arrange(flights, dep_time) %>%
    tail()
arrange(flights, desc(is.na(dep_time)), dep_time)

# select = mysql
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
# =
select(flights, vars)
# the same but avoir a column name named vars
select(flights, !!!vars)
select(flights, contains("TIME", ignore.case = FALSE)) # default is true
select(flights, year, month, day)
## select columns between year and day
select(flights, year:day)
select(flights, -(year:day))
# * `starts_with("abc")`: matches names that begin with "abc".
#
# * `ends_with("xyz")`: matches names that end with "xyz".
#
# * `contains("ijk")`: matches names that contain "ijk".
#
# * `matches("(.)\\1")`: selects variables that match a regular expression.
# This one matches any variables that contain repeated characters. You'll
#    learn more about regular expressions in [strings].
#
# *  `num_range("x", 1:3)`: matches `x1`, `x2` and `x3`.

rename(flights, tail_num = tailnum)
or
select(flights, time_hour, air_time, everything())
select(flights, one_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))
select(flights, starts_with("dep_"), starts_with("arr_"))
select(flights, matches("^(dep|arr)_(time|delay)$"))

# mutate add new variables
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# summarise collapse to a single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
summarise(group_by(flights,year,month,day), delay = mean(dep_delay, na.rm = TRUE))

# pipe %>% = then
delays <- flights %>%
    group_by(dest) %>%
    summarise(
        count = n(),
        dist = mean(distance, na.rm = TRUE),
        delay = mean(arr_delay, na.rm = TRUE)
    ) %>%
    filter(count > 20, dest != "HNL")

delays

ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
    geom_point(aes(size = count), alpha = 1/3) +
    geom_smooth(se = FALSE)
## important that na.rm = TRUE
flights %>%
    group_by(year, month, day) %>%
    summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>%
    filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>%
    group_by(tailnum) %>%
    summarise(
        mean_delay = mean(arr_delay),
        n = n()
    )
delays

ggplot(data = delays, mapping = aes(x = n, y = mean_delay)) +
    geom_point(alpha = 1/10)

ggplot(data = delays, mapping = aes(x = delay)) +
    geom_freqpoly(binwidth = 10)
# When looking at this sort of plot, it’s often useful to filter out the groups with the smallest numbers of observations, so you can see more of the pattern and less of the extreme variation in the smallest groups
delays %>%
    filter(n > 25) %>%
    ggplot(mapping = aes(x = n, y = mean_delay)) +
    geom_point(alpha = 1/10)

not_cancelled %>%
    group_by(dest) %>%
    summarise(distance_sd = sd(distance)) %>%
    arrange(desc(distance_sd))

not_cancelled %>%
    group_by(year, month, day) %>%
    summarise(
        first = min(dep_time),
        last = max(dep_time),
        first = min(dep_time),
        last = max(dep_time)
    )
        # Which destinations have the most carriers?
        not_cancelled %>%
            group_by(dest) %>%
            summarise(carriers = n_distinct(carrier)) %>%
            arrange(desc(carriers))

        not_cancelled %>%
            group_by(year, month, day) %>%
            summarise(n_early = sum(dep_time < 500))

        not_cancelled %>%
            count(dest)

        # =
        not_cancelled %>%
            group_by(dest) %>%
            summarise(n = length(dest))
        # =
        not_cancelled %>%
            group_by(dest) %>%
            summarise(n = n())
        # =
        not_cancelled %>%
            group_by(tailnum) %>%
            tally()

        not_cancelled %>%
            count(tailnum, wt = distance)
        # =
        not_cancelled %>%
            group_by(tailnum) %>%
            summarise(n = sum(distance))

        # =  argument in tally is summed
        not_cancelled %>%
            group_by(tailnum) %>%
            tally(distance)


        cancelled_per_day <-
            flights %>%
            mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
            group_by(year, month, day) %>%
            summarise(
                cancelled_num = sum(cancelled),
                flights_num = n(),
            )

        ggplot(cancelled_per_day) +
            geom_point(aes(x = flights_num, y = cancelled_num))

        cancelled_and_delays <-
            flights %>%
            mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
            group_by(year, month, day) %>%
            summarise(
                cancelled_prop = mean(cancelled),
                avg_dep_delay = mean(dep_delay, na.rm = TRUE),
                avg_arr_delay = mean(arr_delay, na.rm = TRUE)
            ) %>%
            ungroup()

        ggplot(cancelled_and_delays) +
            geom_point(aes(x = avg_dep_delay, y = cancelled_prop))
        ggplot(cancelled_and_delays) +
            geom_point(aes(x = avg_arr_delay, y = cancelled_prop))        # Which carrier has the worst delays?
        flights %>%
            group_by(carrier) %>%
            summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
            arrange(desc(arr_delay))
        # filter(airlines, carrier == "F9")

