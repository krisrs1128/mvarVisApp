
################################################################################
# server for mvarvis app
################################################################################

library("shiny")
library("mvarVis")

shinyServer(function(input, output) {
  # upload-data
  data_fun <- reactive({
    cur_path <- input$quanti_data$datapath
    cur_data <- read.csv(cur_path)
    res <- as.matrix(cur_data[, -1])
    rownames(res) <- cur_data[, 1]
    res
  })

  supp_data_fun <- reactive({
    cur_path <- input$supp_data$datapath
    if(is.null(cur_path)) {
      return (NULL)
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

  # for each table, user can select type of point
  output$point_types <- renderUI({
    point_types <- list()
    for(i in seq_len(n_tables())) {
      point_types[[i]] <- selectInput(paste0("type_select_", i),
                                      paste0("Type Select ", i),
                                      choices = c("point", "text", "arrow"))
    }
    do.call(tagList, point_types)
  })

  output$n_tables <- reactive({n_tables()})

  # get the types of points user has selected
  cur_types <- reactive({
    sapply(1:n_tables(), function(i) {
      input[[paste0("type_select_", i)]]
    })
  })
  output$plot <- renderMvarVis(
    plot_mvar_d3(ordi_fun(), types = cur_types())
  )
})