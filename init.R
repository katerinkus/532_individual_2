r <- getOption('repos')
r['CRAN'] <- 'http://cloud.r-project.org'
options(repos=r)

# ======================================================================



# packages go here
install.packages(c('remotes', 'dash', 'dplyr', 'ggplot2', 'plotly', 'purrr', 'stringr'))
remotes::install_github('facultyai/dash-bootstrap-components@r-release')