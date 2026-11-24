comparisonChart = function (input,output,session,datosFiltrados,indicatorsList,labels_provincia,labels_region,labels_sexo, diferenciaTasas) {
  if (is.null(nrow(datosFiltrados()))) {
    return(
      tagList(
        HTML("<hr/><strong>Debe seleccionar un grupo de causas para visualizar los gráficos</strong><hr/>"),
      )
    )}
  
  
  if (!is.null(modalCauses(
    input$causas,
    input$indicador
  ))) {
    texto = modalCauses(
      input$causas,
      input$indicador)
    
    return(
      tagList(
        HTML(
          glue("<hr/><strong>{texto}</strong><hr/>")),
      )
    )
  }
  
  if (nrow(datosFiltrados())==0) {return()}
  
  pal = rev(paletteer_d("ggsci::default_igv"))
  
  if (input$geo == "Jurisdicciones") {
    geoVar = "provincia"
    area = input$area
    labelsArea = labels_provincia
  } else {
    geoVar = "region"
    area = input$area
    labelsArea = labels_region
  }
  
  datosGrafico = datosFiltrados()
  datosGrafico$geoVar = datosGrafico[[geoVar]]
  datosGrafico = datosGrafico[datosGrafico$geoVar %in% input$area,]
  datosGrafico$values = round(datosGrafico[[input$indicador]],1)
  indicador = names(indicatorsList()[indicatorsList() == input$indicador])
  
  charts = list()
  
  
  
  for (sx in c(0,1,2)) {
    
    if (sx == 0) {
      serieRates = datosGrafico[datosGrafico$sexo != 0 & datosGrafico$geoVar == input$area[1],] %>% 
        dplyr::select(geoVar, ano, sexo, values) %>% setNames(c("geoVar", "ano", "sexo","values")) %>%
        pivot_wider(names_from = sexo, values_from = values) %>%
        mutate(`Razón mujeres / varones` = `2` / `1` * 100)
      
      
      serieRates$`Razón mujeres / varones` = round(serieRates$`Razón mujeres / varones`,1)
      
      serieName = if (input$geo == "Jurisdicciones") {names(labels_provincia[labels_provincia==input$area[1]])} else {
        names(labels_region[labels_region==input$area[1]])
      }
      
      
      chartRate = highchart() %>%
        hc_xAxis(
          categories = serieRates$ano,
          title = list(text = "Año")
        ) %>% 
        hc_yAxis(
          title = list(text = names(indicatorsList()[indicatorsList() == input$indicador]))
        ) %>%
        hc_add_series(name = serieName, data = serieRates$`Razón mujeres / varones`, color = pal[1]) %>%
        hc_plotOptions(
          series = list(
            label = list(
              enabled = TRUE, # Key setting to activate the labels
              connectorAllowed = TRUE # Allows Highcharts to use a connector line if needed
              # You can add further styling here, e.g., 'style = list(fontWeight = "bold")'
            ),
            # Often, when using end labels, you want to hide the standard legend
            showInLegend = FALSE 
          )
        ) %>%
        hc_legend(
          layout = "vertical",
          align = "right",
          verticalAlign = "top") %>% 
        hc_title(
          text = names(indicatorsList()[indicatorsList() == input$indicador]),
          align = "left") %>%
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
      
      for (k in input$area[-1]) {
        dataRates = datosGrafico[datosGrafico$sexo != 0 & datosGrafico$geoVar == k,] %>% 
          dplyr::select(ano, sexo, values) %>% setNames(c("ano", "sexo","values")) %>%
          pivot_wider(names_from = sexo, values_from = values) %>%
          mutate(`Razón mujeres / varones` = `2` / `1` * 100)
        
        dataRates$`Razón mujeres / varones` = round(dataRates$`Razón mujeres / varones`,1)
        
        dataRates$geoVar =names(labelsArea[labelsArea==k])
        #index = (as.numeric(which(labelsArea[!names(labelsArea) %in% c("Total país", "Sin especificar", "Otro país")] == k))) + 1
        index = which(input$area == k)
        
        chartRate = chartRate %>% 
          hc_add_series(name = names(labelsArea[labelsArea == k]), data = dataRates$`Razón mujeres / varones`, color = pal[index], visible = TRUE)
        
        
      }
      charts[["rates"]] = chartRate
    }
    
    serie1 = datosGrafico[datosGrafico$sexo == sx & datosGrafico$geoVar == labelsArea[1],] %>% 
      dplyr::select(ano, values) %>% setNames(c("ano", "values"))
    
    chart = highchart() %>%
      hc_xAxis(
        categories = serie1$ano,
        title = list(text = "Año")
      ) %>% 
      hc_yAxis(
        title = list(text = names(indicatorsList()[indicatorsList() == input$indicador]))
      ) %>%
      hc_add_series(name = names(labelsArea[1]), data = serie1$values, color = pal[1]) %>%
      hc_plotOptions(
        series = list(
          label = list(
            enabled = TRUE, # Key setting to activate the labels
            connectorAllowed = TRUE # Allows Highcharts to use a connector line if needed
            # You can add further styling here, e.g., 'style = list(fontWeight = "bold")'
          ),
          # Often, when using end labels, you want to hide the standard legend
          showInLegend = FALSE 
        )
      ) %>%
      hc_legend(
        layout = "vertical",
        align = "right",
        verticalAlign = "top") %>% 
      hc_title(
          text = names(indicatorsList()[indicatorsList() == input$indicador]),
          align = "left"
          
          
        ) %>%
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
        
      
    
    for (i in labelsArea[labelsArea %in% unique(datosGrafico$geoVar) & !names(labelsArea) %in% c("Total país", "Sin especificar", "Otro país")]) {
      dataChart = datosGrafico[datosGrafico$sexo == sx & datosGrafico$geoVar == i,]
      
      dataChart$geoVar =names(labelsArea[labelsArea==i])
      
      #index = (as.numeric(which(labelsArea[!names(labelsArea) %in% c("Total país", "Sin especificar", "Otro país")] == i))) + 1
      index = which(input$area == i)
      
      chart = chart %>% 
        hc_add_series(name = names(labelsArea[labelsArea == i]), data = dataChart$values, color = pal[index], visible = TRUE)
      
      
    }
    
    charts[[paste0("chart","_",sx)]] = chart
  }
  
  return(
    list(
      tags = tagList(
        br(),
        br(),
        fluidRow(
          column(
            12,
            h4("Razón mujeres / varones * 100", style = "margin:0 !important"),
            br(),
            charts$rates %>% hc_size(height = "450px")
          )
        ),
        fluidRow(
          column(
            12,
            h4("Ambos sexos", style = "margin:0 !important"),
            br(),
            charts$chart_0 %>% hc_size(height = "450px")
          )
        ),
        fluidRow(
          column(12,
                 hr(style = "border-top: 1px solid #bdbdbd"))
        ),
        fluidRow(
          column(
            6,
            h4("Varones", style = "margin:0 !important"),
            br(),
            charts$chart_1 %>% hc_size(height = "80%")
          ),
          column(
            6,
            h4("Mujeres", style = "margin:0 !important"),
            br(),
            charts$chart_2 %>% hc_size(height = "80%")
          )
        )
      )
    )
  )
  
  
  
  
  
  
  
}



