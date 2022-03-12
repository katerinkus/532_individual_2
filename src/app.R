library(dash)
library(dplyr)
library(ggplot2)
library(plotly)
library(purrr)

# Create a Dash app
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

cherry_df <- read.csv("data/street-trees.csv", sep = ";") |>
  mutate("DIAMETER_CM" = DIAMETER * 2.54) |>
  filter(GENUS_NAME == "PRUNUS" & DIAMETER_CM > 0 & DIAMETER_CM <= 150) |>
  filter(NEIGHBOURHOOD_NAME == "DOWNTOWN")

cherry_diam <- ggplot(cherry_df) +
  aes(x = DIAMETER_CM) +
  geom_density(fill = "#F3B2D2", alpha = 0.4, size = 1, color = "#d982ad") +
  labs(y = "Density",
       x = "Tree diameter (cm)") +
  theme(axis.text.y = element_blank())


app %>% set_layout(
  h1('Cherry tree diameter'),
  div(
    list(
    div('Here you can see cherry tree diameters by size'),
    dccDropdown(
      options = list(list(label = "New York City", value = "NYC"),
                     list(label = "Montreal", value = "MTL"),
                     list(label = "San Francisco", value = "SF")),
      value = 'MTL'),
    dccGraph(figure=ggplotly(cherry_diam, tooltip = c(""))
  ))
  )
)


# Run the app
app %>% run_app()

app$run_server(debug = T)