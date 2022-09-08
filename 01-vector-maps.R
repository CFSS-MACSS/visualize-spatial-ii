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
  ...
)
tompkins_inc

# Draw a choropleth using the median household income data
# Use a continuous color gradient to identify each tract's median household income
ggplot(______) +
  # use fill and color to avoid gray boundary lines
  geom_______(______) +
  # increase interpretability of graph
  scale_color_continuous(labels = label_dollar()) +
  scale_fill_continuous(labels = label_dollar()) +
  map_labels

# Use the viridis color palette for the Tompkins County map drawn
# using the continuous measure


# Draw the same choropleth for Tompkins County, but convert median household income
# into a discrete variable with 6 levels

