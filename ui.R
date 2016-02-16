
################################################################################
# UI for shiny app
################################################################################

library("shiny")
library("mvarVis")

shinyUI(fluidPage(
  titlePanel("mvarVis"),
  sidebarLayout(
    sidebarPanel(
      fileInput("quanti_data", "Upload Data"),
      fileInput("supp_data", "Supplemental Data"),
      selectInput("method", "Method", c("factominer_pca", "acm",
                                        "coa", "fpca", "pco", "CA", "isomap",
                                        "hillsmith", "decorana", "ade4_pca", "metaMDS")),
      uiOutput("point_types")
    ),
    mainPanel(
      mvarVisOutput("plot"),
      textOutput("n_tables")
    )
  )
))
