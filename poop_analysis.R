library(tidyverse)
data <- read.csv("~/Desktop/poop.csv")

data$date <- as_datetime(data$date)
data$month <- month(data$date) 
data$h <- hour(data$date)

as_fractional_hour <- function(x) {
  hour(x) + (minute(x) / 60)
}

as_angle <- function(x) {
  ((360 * x) / 24) * (pi / 180)
}

# Get rid of people who are not partecipating anymore
data |> filter(! author %in% c("Cristian Roffino", "Benny")) -> data

# How many poops per person (ppp)?
ppp <- data |> count(author)

# How many poops per person per month (ppppm) ?
ppppm <- data |>
  mutate(month = month(date, label=TRUE)) |>
  count(author, month)

# At what Times do People Poop?
tpp <- data |> 
  mutate(
    time = as_fractional_hour(date),
    time_angle = as_angle(as_fractional_hour(date))
    )

## --- graphs ---

## poops per person

plot_ppp <- ggplot(ppp, aes(x = reorder(author, -n), y = n)) +
  geom_bar(stat = "identity", fill = "#8c4e07") +
  ggtitle("Total poops of 2024 (since 1st of January)") +
  xlab("Pooper") + ylab("Number of Poops") +
  theme_minimal()
plot_ppp

## Poops per person per month
plot_ppppm <- ggplot(ppppm, aes(x = reorder(author, -n), y = n, fill = month)) +
  geom_bar(stat = "identity", position = "dodge") +
  ggtitle("Total poops of 2024 (since 1st of January) by month of poop") +
  xlab("Pooper") + ylab("Number of Poops") +
  theme_minimal()
plot_ppppm

# Time when people poop
# Make colors --
# From 0 to 7
late_night <- colorRampPalette(c("#2f2f4d", "#3c66ab"))
# From 8 to 12
morning <- colorRampPalette(c("#5382cf", "#53cf5f"))
# From 13 to 18
afternoon <- colorRampPalette(c("#49e659", "#c2b32b"))
# From 19 to 21
evening <- colorRampPalette(c("#a3972c", "#ff8400"))
# From 22 to 24
early_night <- colorRampPalette(c("#c26502", "#1f1e1e"))

day_colors <- c(
  late_night(8),
  morning(5),
  afternoon(6),
  evening(3),
  early_night(3)
)

plot_tpp2 <- ggplot(tpp, aes(x = as.numeric(time_angle))) +
  ggtitle("Preferred Pooping Time") +
  scale_x_continuous(
    labels = c("24", as.character(1:23)),
    breaks = seq(from = 0, to = pi*2, by = (pi*2/23))
  ) +
  #scale_y_reverse(breaks = 0:24, labels = 0:24) +
  scale_color_gradientn(colors=day_colors) +
  geom_jitter(aes(y=0, color = time_angle), height=2) + 
  theme_minimal() +
  facet_wrap(~author) +
  coord_radial(start = 0, expand = FALSE, inner.radius = 0.4) +
  theme(legend.position = "bottom") + 
  geom_density(adjust = 1/10) +
  theme(legend.position = "none", axis.text.y = element_blank()) +
  guides(color = guide_legend(title = "Hour of Day", nrow = 1, label.position = "top", keywidth = 1))
plot_tpp2

requireNamespace("circular")
data$circular <- circular::circular(data$h_frac, units = "hours")

ggplot(data = data, aes(x = ))

