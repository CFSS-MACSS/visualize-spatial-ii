library(tidyverse)
library(sf)
library(tidycensus)
library(colorspace)
library(scales)

# useful on MacOS to speed up rendering of geom_sf() objects
if (!identical(getOption("bitmapType"), "cairo") && isTRUE(capabilities()[["cairo"]])) {
  options(bitmapType = "cairo")
}

# set default theme
theme_set(theme_minimal())

# create reusable labels for each plot
map_labels <- labs(
  title = "Median household income in Tompkins County, NY",
  subtitle = "In 2020",
  color = NULL,
  fill = NULL,
  caption = "Source: American Community Survey"
)

# Obtain information on median household income in 2020 for Tompkins County, NY
# at the tract-level using the ACS
tompkins_inc <- get_acs(
  state = "NY",
  county = "Tompkins",
  geography = "tract",
  variables = c(medincome = "B19013_001"),
  year = 2020,
  geometry = TRUE,
  output = "wide"
)
tompkins_inc

# Draw a choropleth using the median household income data
# Use a continuous color gradient to identify each tract's median household income
ggplot(data = tompkins_inc) +
  # use fill and color to avoid gray boundary lines
  geom_sf(aes(fill = medincomeE, color = medincomeE)) +
  # increase interpretability of graph
  scale_color_continuous(labels = label_dollar()) +
  scale_fill_continuous(labels = label_dollar()) +
  map_labels

# Use the viridis color palette for the Tompkins County map drawn
# using the continuous measure
ggplot(data = tompkins_inc) +
  # use fill and color to avoid gray boundary lines
  geom_sf(aes(fill = medincomeE, color = medincomeE)) +
  # increase interpretability of graph
  scale_fill_continuous_sequential(
    palette = "viridis",
    rev = FALSE,
    aesthetics = c("fill", "color"),
    labels = label_dollar(),
    name = NULL
  ) +
  map_labels

# Draw the same choropleth for Tompkins County, but convert median household income
# into a discrete variable with 6 levels

## cut_interval()
tompkins_inc %>%
  mutate(inc_cut = cut_interval(medincomeE, n = 6)) %>%
  ggplot() +
  # use fill and color to avoid gray boundary lines
  geom_sf(aes(fill = inc_cut, color = inc_cut)) +
  # increase interpretability of graph
  scale_fill_discrete_sequential(
    palette = "viridis",
    rev = FALSE,
    aesthetics = c("fill", "color"),
    name = NULL
  ) +
  map_labels

## cut_number()
tompkins_inc %>%
  mutate(inc_cut = cut_number(medincomeE, n = 6)) %>%
  ggplot() +
  # use fill and color to avoid gray boundary lines
  geom_sf(aes(fill = inc_cut, color = inc_cut)) +
  # increase interpretability of graph
  scale_fill_discrete_sequential(
    palette = "viridis",
    rev = FALSE,
    aesthetics = c("fill", "color"),
    name = NULL
  ) +
  map_labels

## binned_scale() - default breaks
ggplot(data = tompkins_inc) +
  geom_sf(mapping = aes(fill = medincomeE, color = medincomeE)) +
  scale_fill_binned_sequential(
    palette = "viridis",
    rev = FALSE,
    aesthetics = c("fill", "color"),
    labels = label_dollar()
  ) +
  # increase interpretability of graph
  map_labels

## binned_scale() - quintiles
ggplot(data = tompkins_inc) +
  geom_sf(mapping = aes(fill = medincomeE, color = medincomeE)) +
  scale_fill_binned_sequential(
    palette = "viridis",
    rev = FALSE,
    aesthetics = c("fill", "color"),
    n.breaks = 4, nice.breaks = FALSE,
    labels = label_dollar()
  ) +
  # increase interpretability of graph
  map_labels
