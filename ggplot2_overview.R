

library(ggplot2)

# ggplot2 default datasets
mpg    # Cars
msleep # Sleep hours

# In ggplot each layer stacks on top of the layers below via the + operator

# This layer represents only the plane, axes and scale
# The argument 'aes' stands for 'aesthetics'
ggplot(data = mpg, mapping = aes(x = displ, y = hwy))

# The geometric object 'geom_point()' specifies the plot type (scatterplot)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point()

# Adding the 'color' argument
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))

# The 'mapping' argument can be omitted and the 'aes' function can be moved to
# other terms producing equivalent results
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, color = class))

# Adding the (dot) 'size' argument
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, color = class, size = drv))

# As an alternative we can change transparency ('alpha') or dot shape ('shape')
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, shape = class))

# The same arguments outside aes are global parameters
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, color = class, size = drv), alpha = 0.6)

# Make 7 different scatterplots, one per car class...
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~class, nrow = 2)

# ...and make each class of a different color
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, color = class)) +
  facet_wrap(~class, nrow = 2)

# Decomposing according to 2 variables for a grid representation
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(drv~cyl)

# It is easy to change representation by changing the geometric object
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_smooth()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_smooth(aes(color=class))

# Points and lines can be overlaid via the layer grammar
# NOTE: the order of the layers matters...those written after are on top!
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() + geom_point()

# You can decide to apply aesthetic attributes globally or locally
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_smooth() + geom_point()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth() + geom_point(aes(color = class))

#Since the dataset can be defined on each term you can easily graph all points
# and show the smooth curve of only one class
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) +
  geom_point()



# Geometric object 'geom_bar' for Bar Charts
# NOTE: summary statistics to be plotted (mean, median, SD, SEM, ...) need to be
#       prepared first!
df <- data.frame(class = sort(unique(mpg$class)),
                 mean_hwy = as.vector(with(mpg, by(hwy, class, mean))),
                 sd_hwy = as.vector(with(mpg, by(hwy, class, sd))))

ggplot(data = df, mapping = aes(x = class, y = mean_hwy)) +
  geom_bar(stat = "identity")

ggplot(data = df, mapping = aes(x = class, y = mean_hwy, fill = class)) +
  geom_bar(stat = "identity") +
  geom_errorbar(mapping = aes(ymin = mean_hwy - sd_hwy,
                              ymax = mean_hwy + sd_hwy),
                linewidth = 1.0, width = 0.5, color = "black")



# Geometric object 'geom_boxplot' (or lower level 'stat_boxplot')
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = class)) +
  geom_boxplot()

# The x variable can also be continuous affecting the width of the boxes
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_boxplot()

# Rotate the whole plane by flipping the axes through 'coord_flip()'
ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = class)) +
  geom_boxplot() + coord_flip()



# Geometric object 'geom_violin' for Violin Plots
ggplot(data = msleep, mapping = aes(x = vore, y = sleep_total, fill=vore)) +
  geom_violin()

# Violins and boxplots overlaid
ggplot(data = msleep, mapping = aes(x = vore, y = sleep_total, fill=vore)) +
  geom_violin() + geom_boxplot(width = 0.1, fill = "white", alpha = 0.6)

ggplot(data = msleep, mapping = aes(x = vore, y = sleep_total, fill=vore)) +
  geom_violin(alpha = 0.4) + geom_boxplot(width = 0.07)



# Each plot (or part of it) can be saved in a variable and then reused to add 
# more layers
p <- ggplot(data = msleep, mapping = aes(x = vore, y = sleep_total, fill=vore)) +
  geom_violin(alpha = 0.4) + geom_boxplot(width = 0.07)

# Change the title, axis labels, and their orientation
p + ggtitle("Plot of hours of sleep\n by feeding") +
  xlab("Feeding type") + ylab("Total sleep time (hours)")







