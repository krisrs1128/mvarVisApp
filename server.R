
################################################################################
# server for mvarvis app
################################################################################

library("shiny")
library("mvarVis")

shinyServer(function(input, output, session) {

  # upload-data
  data_fun <- reactive({
    cur_path <- input$quanti_data$datapath
    if(is.null(cur_path)) {
      cur_path <- "data/decathlon_quanti.csv"
    }
    cur_data <- read.csv(cur_path)
    res <- as.matrix(cur_data[, -1])
    rownames(res) <- cur_data[, 1]
    res
  })

  supp_data_fun <- reactive({
    cur_path <- input$supp_data$datapath
    if(is.null(cur_path)) {
      cur_path <- "data/decathlon_supp.csv"
    }
    cur_data <- read.csv(cur_path)
    res <- as.matrix(cur_data[, -1])
    rownames(res) <- cur_data[, 1]
    res
  })

  ordi_fun <- reactive({
    args <- list(data_fun(), input$method, rows_annot = supp_data_fun())
    if(input$method %in% c("CA", "factominer_pca")) {
      args$graph <- FALSE
    }
    if(input$method %in% c("acm", "coa", "fpca", "pco", "hillsmith",
                           "ade4_pca")) {
      args$scannf <- FALSE
    }
    do.call(ordi, args)
  })

  # how many tables are there?
  n_tables <- reactive({
    length(ordi_fun()@table)
  })
  output$n_tables <- reactive({n_tables()})

  # what is the width (in pixels) of the plot container?
  panelWidth <- reactive( {
    input$panelWidth
  })

  output$plot <- renderMvarVis(
    plot_mvar_d3(ordi_fun(), width = as.numeric(panelWidth()))
  )
})
