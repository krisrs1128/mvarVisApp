
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
      width = 2
    ),
    mainPanel(
      mvarVisOutput("plot"),
      id = "main-panel"
    )
  ),
  HTML("<input type='text' id = 'panelWidth' name='panelWidth' style='display: none;'>"),
  includeScript("panelWidth.js")
))
