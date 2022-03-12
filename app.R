library(dash)
library(dplyr)
library(ggplot2)
library(plotly)
library(purrr)
library(stringr)

# Create a Dash app
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

cherry_df <- read.csv("data/street-trees.csv", sep = ";") %>%
  mutate("DIAMETER_CM" = DIAMETER * 2.54) %>%
  filter(GENUS_NAME == "PRUNUS" & DIAMETER_CM > 0 & DIAMETER_CM <= 150)


app %>% set_layout(
  div(id = 'main-container',
    list(
    h1('Cherry tree diameter'),
    div('Here you can see cherry tree diameters by size'),
    dccDropdown(
      id = 'nb_select',
      value = 'All neighbourhoods',
      options = (c(unique(cherry_df$NEIGHBOURHOOD_NAME), 'All neighbourhoods')) %>%
        purrr::map(function(item) list(label = item, value = item)),
      ),
    dccGraph(id='plot-area')
  ))
)

app$callback(
  output('plot-area', 'figure'),
  list(input('nb_select', 'value')),
  function(nb) {
    
  if (nb != 'All neighbourhoods') {
    cherry_df <- cherry_df %>%
      filter(NEIGHBOURHOOD_NAME == nb)
  }
    
    cherry_diam <- ggplot(cherry_df) +
      aes(x = DIAMETER_CM) +
      geom_density(fill = "#F3B2D2", alpha = 0.4, size = 1, color = "#d982ad") +
      labs(y = "Density",
           x = "Tree diameter (cm)") +
      theme(axis.text.y = element_blank())
    ggplotly(cherry_diam, tooltip = c(""))
  }
)


app$run_server(host = '0.0.0.0')
#app$run_server(debug = T)