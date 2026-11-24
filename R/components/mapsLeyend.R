library(shiny)

mapsLeyend = function (limInf, limSup, col) {
  
  limInf = format(round(limInf,2), nsmall = 2)
  limSup = format(round(limSup,2), nsmall = 2)
  col1 = col[1]
  col2 = col[2]
  col3 = col[3]
  col4 = col[4]
  
  
  tagList(
    tags$head(
      tags$style(HTML("
      .legend-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        font-size: 12px;
      }
      .legend-table th,
      .legend-table td {
        padding: 6px;
        text-align: left;
        border: none;
      }
      .legend-table .header {
        background-color: #f2f2f2;
        font-weight: bold;
        text-align: center;
      }
      .legend-table thead th {
        background-color: #e0e0e0;
        font-weight: bold;
      }
      .color-box {
        width: 30px;
        height: 20px;
        border: none;
      }
    "))
    ),
    
    # Tabla convertida a tags de Shiny
    tags$table(
      class = "legend-table",
      tags$tbody(
        tags$tr(
          tags$td(paste0(limInf[1], " - ", limSup[1])),
          tags$td(
            tags$div(class = "color-box", style = glue("background-color: {col1};"))
          )
        ),
        tags$tr(
          tags$td(paste0(limInf[2], " - ", limSup[2])),
          tags$td(
            tags$div(class = "color-box", style = glue("background-color: {col2};"))
          )
        ),
        tags$tr(
          tags$td(paste0(limInf[3], " - ", limSup[3])),
          tags$td(
            tags$div(class = "color-box", style = glue("background-color: {col3};"))
          )
        ),
        tags$tr(
          tags$td(paste0(limInf[4], " - ", limSup[4])),
          tags$td(
            tags$div(class = "color-box", style = glue("background-color: {col4};"))
          )
        )
      )
    )
  )
}
 