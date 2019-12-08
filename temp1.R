## scatterplot

ggplot(mpg, aes(displ, hwy)) +
    geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)
ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
    geom_point()
# outliers
geom_point(data = dplyr::filter(mpg, displ > 5, hwy > 20), colour = "red", size = 2.2)
geom_point(mapping = aes(x = displ, y = hwy), colour = "blue")
+
    facet_wrap(~ class, nrow = 2)
facet_grid(drv ~ cyl)
facet_grid(. ~ cyl)
# The symbol . ignores that dimension when faceting. For example, drv ~ . facet by values of drv on the y-axis.
# While, . ~ cyl will facet by values of cyl on the x-axis.
# Given human visual perception, the max number of colors to use when encoding unordered categorical (qualitative) data is nine, and in practice, often much less than that.
# The arguments nrow (ncol) determines the number of rows (columns) to use when laying out the facets. It is necessary since facet_wrap() only facets on one variable.

## line
In ggplot2 syntax, we say that they use different geoms.

ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
    geom_point() +
    geom_smooth(mapping = aes(linetype = drv),se = FALSE)

```{r}
ggplot(data = mpg) +
    geom_smooth(
        mapping = aes(x = displ, y = hwy, color = drv),
        show.legend = FALSE
    )
```

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
    geom_point() +
    geom_smooth(se = TRUE)
# standard error
# https://www.youtube.com/watch?v=A82brFpdr9g
# same two output
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point() +
    geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(mapping = aes(color = class)) +
    geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# more control see the se = FALSE should be inserted into smooth clause
ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(group = drv), se = FALSE) +
    geom_point()
# color = surrounding stroke
ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(size = 4, color = "white") +
    geom_point(aes(colour = drv))

# bar chart
## with count
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut))

glimpse(diamonds)
diamonds$cut
ggplot(data = diamonds) +
    stat_count(mapping = aes(x = cut))
## with identity. original values
demo <- tribble(
    ~cut,         ~freq,
    "Fair",       1610,
    "Good",       4906,
    "Very Good",  12082,
    "Premium",    13791,
    "Ideal",      21551
)

ggplot(data = demo) +
    geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")
## proportion
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
## more stat
ggplot(data = diamonds) +
    stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.ymin = min,
        fun.ymax = max,
        fun.y = median
    )
# default stat_summary geom is pointrange, only mean and sd
ggplot(data = diamonds) +
    geom_pointrange(
        mapping = aes(x = cut, y = depth),
        stat = "summary"
    )

ggplot(data = diamonds) +
    geom_pointrange(
        mapping = aes(x = cut, y = depth),
        stat = "summary",
        fun.ymin = min,
        fun.ymax = max,
        fun.y = median
    )

ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
# only 126 points overplotting
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy))
length(mpg$hwy)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_jitter(height = 0, width = 0)

# size the points relative to the number of observations
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_count()

# compare overplotting
ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
    geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
    geom_count()

## avoid overplotting in boxplot
ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
    geom_boxplot()
###The default position for geom_boxplot() is "dodge2"
## with overlap
ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
    geom_boxplot(position = "identity")


# coordinates
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
    geom_boxplot() +
    coord_flip()
## nice to do some game chart
x <- tribble(
    ~cut,         ~freq,
    "Fair",       500,
    "Good",       500,
    "Very Good",  500,
    "Premium",    500,
    "Ideal",     500
)

bar <- ggplot(data = x) +
    geom_bar(
        mapping = aes(x = cut, fill = cut),
        show.legend = FALSE,
        width = 1
    ) +
    theme(aspect.ratio = 1) +
    labs(x = NULL, y = NULL)
bar + coord_flip()
bar + coord_polar()

## pie chart
ggplot(mpg, aes(x = factor(1), fill = drv)) +
    geom_bar() +
    coord_polar(theta = "y")
## bull eye chart
ggplot(mpg, aes(x = factor(1), fill = drv)) +
    geom_bar(width = 1) +
    coord_polar()

# annotation
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
    geom_boxplot() +
    coord_flip() +
    labs(
        y = "Highway MPG",
        x = "Class",
        title = "Highway MPG by car class",
        subtitle = "1999-2008",
        caption = "Source: http://fueleconomy.gov"
    )
# The xlab(), ylab(), and x- and y-scale functions can add axis titles. The ggtitle() function adds plot titles.

p <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point() +
    geom_abline()
p
p + coord_fixed() # 45 degrees line
# On average, humans are best able to perceive differences in angles relative to 45 degrees.
