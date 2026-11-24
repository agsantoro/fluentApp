gapsChart = function (input,output,session,datosFiltrados,labels_provincia,labels_region,labels_sexo, cocienteTasas, diferenciaTasas) {
  if (get_page() != "gaps") {return()}
  if (is.null(input$causasGaps)) {
    return(
      tagList(
        HTML("<hr/><strong>Debe seleccionar un grupo de causas para visualizar el gráfico</strong><hr/>"),
      )
    )
    
  }
  
  
  
  if (!is.null(modalCauses(
    input$causasGaps,
    input$indicadorGaps
  ))) {
    texto = modalCauses(
      input$causasGaps,
      input$indicadorGaps)
    
    return(
      tagList(
        HTML(
          glue("<hr/><strong>{texto}</strong><hr/>")),
      )
    )
  }
  
  if (input$geoGaps == "Jurisdicciones") {
    geoVar = "provincia"
    area = input$areaGaps
  } else {
    geoVar = "region"
    area = input$areaGaps
  }
  
  # setea máximo eje y
  
  if (is.null(nrow(datosFiltrados()))) {return()}
  if (is.null(nrow(datosFiltrados()))) {return()}
  if (nrow(datosFiltrados())>0) {
    if (input$indicadorGaps %in% indicatorsList()[c(1,4,5,6)]) {
      valores = (datosFiltrados() %>% dplyr::filter(get(geoVar) %in% input$area & sexo %in% c(1,2)))[[input$indicadorGaps]]
      maxY = max(valores)
      min = 0
    } else {
      
      
      maxY = max(datosFiltrados()[[input$indicadorGaps]][datosFiltrados()[[geoVar]] %in% area])
      min = 0.95 * min(datosFiltrados()[[input$indicadorGaps]][datosFiltrados()[[geoVar]] %in% area])
      if (min < 0) {min = 0}
    }
    
    maxY = ceiling((maxY))
  }
  
  lapply(area, function (i) {
    datosGrafico = datosFiltrados()
      datosGrafico = datosGrafico[datosGrafico[geoVar] == i,]
      
      # probar agregar como serie en eje
      serieCocienteTasas = cocienteTasas(input, datosFiltrados = datosGrafico)
      #serieDiferenciaTasas = diferenciaTasas(datosFiltrados = datosGrafico)
      # crea gráfico de área
      output[[glue("graficoArea_{i}")]] = renderHighchart({
        if (input$geoGaps == "Jurisdicciones") {
          tituloArea = names(labels_provincia)[labels_provincia == i]
        } else {
          tituloArea = names(labels_region)[labels_region == i]
        } 
        tituloCausa = input$causasGaps
        tituloCausa = substring(stringr::str_to_title(tituloCausa),6, nchar(tituloCausa))
        
        
        if (nrow(datosGrafico)==0) {
        } else {
          
          for (i in 1:nrow(datosGrafico)) {
            datosGrafico$sexo[i] = names(labels_sexo[labels_sexo==datosGrafico$sexo[i]])
          }
          
          #Gráfico doble eje y
          
          indicador = names(indicatorsList()[indicatorsList() == input$indicadorGaps])
          datosGrafico$values = datosGrafico[[input$indicadorGaps]]
          if (input$indicadorGaps %in% indicatorsList()[c(1,4,5,6)]) {
            hchart(type = "line", datosGrafico[datosGrafico$sexo %in% c("Varones","Mujeres"),], hcaes(x = ano, y = values, group = sexo)) %>%
              hc_tooltip(valueDecimals = 2) %>%
              hc_title(text = glue("{tituloArea} - {indicador} por {tituloCausa}"),
                       style = list(
                         fontSize = 14
                       )) %>%
              hc_credits(enabled = TRUE,
                         text = "Fuente: elaboración propia a partir de datos de la DEIS-MSAL.") %>%
              hc_exporting(enabled = F) %>% 
              hc_yAxis(
                title = list(text = indicador)
              )
          } else 
            #if
            #(input$indicadorGaps == "tmape") 
            {
              hchart(type = "line", datosGrafico, hcaes(x = ano, y = values, group = sexo)) %>%
              hc_add_series(data = serieCocienteTasas, yAxis = 1, visible = F, name = "Cociente de tasas") %>%
              hc_tooltip(valueDecimals = 2) %>%
              hc_yAxis_multiples(
                list(title = list(text = indicador),
                     opposite = FALSE,
                     min = min),
                list(title = list(
                  text = "Cociente"),
                  opposite = TRUE,
                  min = 0)) %>%
              hc_xAxis(title = list(text = "Año")) %>%
              hc_title(text = glue("{tituloArea} - {indicador} por {tituloCausa}"),
                       style = list(
                         fontSize = 14
                       )) %>%
              hc_credits(enabled = TRUE,
                         text = "Fuente: elaboración propia a partir de datos de la DEIS-MSAL.") %>%
              hc_exporting(
                enabled = TRUE,
                # Configuración del botón de exportación (contextButton)
                buttons = list(
                  contextButton = list(
                    # La propiedad 'theme' controla el estilo del botón
                    theme = list(
                      # Establecer el fondo (fill) en transparente
                      fill = "transparent", 
                      # Opcional: Establecer el color del borde en transparente
                      'stroke-width' = 0,
                      stroke = "transparent",
                      # Opcional: Asegurarse que el ícono (menu-icon) sea visible
                      states = list(
                        hover = list(
                          fill = "rgba(0, 0, 0, 0.1)" # Color suave al pasar el mouse
                        )
                      )
                    )
                  )
                )
              )
            
           } #else {
          #   hchart(type = "line", datosGrafico, hcaes(x = ano, y = values, group = sexo)) %>%
          #     hc_tooltip(valueDecimals = 2) %>%
          #     hc_xAxis(title = list(text = "Año")) %>%
          #     hc_title(text = glue("{tituloArea} - {indicador} por {tituloCausa}"),
          #              style = list(
          #                fontSize = 14
          #              )) %>%
          #     hc_credits(enabled = TRUE,
          #                text = "Fuente: elaboración propia a partir de datos de la DEIS-MSAL.") %>%
          #     hc_exporting(
          #       enabled = TRUE,
          #       # Configuración del botón de exportación (contextButton)
          #       buttons = list(
          #         contextButton = list(
          #           # La propiedad 'theme' controla el estilo del botón
          #           theme = list(
          #             # Establecer el fondo (fill) en transparente
          #             fill = "transparent", 
          #             # Opcional: Establecer el color del borde en transparente
          #             'stroke-width' = 0,
          #             stroke = "transparent",
          #             # Opcional: Asegurarse que el ícono (menu-icon) sea visible
          #             states = list(
          #               hover = list(
          #                 fill = "rgba(0, 0, 0, 0.1)" # Color suave al pasar el mouse
          #               )
          #             )
          #           )
          #         )
          #       )
          #     )
          #   
          # }
          
          
          
          
          
          
          
          # hchart(datosGrafico, "line", hcaes(x = ano, y = tmape, group = sexo)) %>%
          #   hc_yAxis_multiples(
          #     list(lineWidth = 3),
          #     list(showLastLabel = FALSE, opposite = TRUE)
          #   ) %>%
          #   hc_add_series(data = serieCocienteTasas, type = "line", yAxis = 1, visible = F)
          
        }
      })
      
      tagList({
        column(12,
               div(
                 highchartOutput(glue("graficoArea_{i}"))))
      })
      
    
    })
}
    


  