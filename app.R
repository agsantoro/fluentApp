# Cargar las librerías necesarias
library(shiny)
library(shiny.fluent)
library(shiny.router)
library(leaflet)
library(dplyr)
library(apexcharter)
library(shinyjs)
library(shinytreeview)
library(glue)
library(shinyalert)
library(apexcharter)
library(highcharter)
library(paletteer)
library(shinycssloaders)
library(shinyWidgets)
library(reactable)
library(writexl)

source("R/calc/indicatorsList.R")
source("R/components/menuBox.R")
source("R/components/plotBox.R")
source("R/components/infoBox.R")
source("R/charts/comparisonChart.R")
source("R/charts/gapsChart.R")
source("R/calc/ratesRatio.R")
source("R/calc/ratesDifferences.R")
source("R/calc/rmsCalculate.R")
source("R/components/modalText.R")
source("R/components/mapsLeyend.R")
source("R/components/trafficLight.R")
source("R/components/mapBox.R")
source("R/charts/hotSpots.R")
source("R/components/modalCauses.R")

source("R/pages/landing_page.R")
source("R/pages/chart_page.R")
source("R/pages/gaps_page.R")
source("R/pages/map_page.R")
source("R/pages/juri_page.R")
source("R/pages/hotspots_page.R")
source("R/pages/download_page.R")

load("data/labels/labels_provincia.rda")
load("data/labels/labels_sexo.rda")
load("data/labels/labels_region.rda")

firstTime <<- 0

# Definir las páginas

ui <- fluidPage(
  shinyjs::useShinyjs(),
  
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap",
      rel = "stylesheet"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Oswald:wght@200..700&display=swap"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Oswald:wght@200..700&display=swap"
    ),
    
    
    
    
  ),
  tags$style(
    
    "body {font-family: 'Roboto', sans-serif !important;}
        
        .tlist-group {
        font-size: 0.7em !important;}
        
        /* Animación para el h3 */
        @keyframes slideInLeft {
        from {
            transform: translateX(-100px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
        }
    
    .Reactable {
    font-size: 0.93em;
    color: #636363;
    }
    
    .rt-pagination {
    color: black;
    }
    
    .list-group-item {
      font-size: 0.8em;
    }
    .animate-left {
        animation: slideInLeft 1s ease-out;
    }
    
        /* Animación de latido */
    @keyframes heartbeat {
        0%, 100% {
            transform: scale(1);
        }
        10%, 30% {
            transform: scale(1.15);
        }
        20%, 40% {
            transform: scale(1);
        }
    }
    
  
  
  
  
    /* Ícono fijo abajo a la derecha */
    .fixed-icon {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        background: rgba(70, 130, 180, 0.7);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        z-index: 1000;
        animation: heartbeat 2s ease-in-out infinite;
    }
    
        .fixed-icon:hover {
            background: rgba(70, 130, 180, 0.9);
        }
        
        .fixed-icon i {
            color: white;
            font-size: 28px;
        }
        
        /* Modal elegante (original) */
.elegant-modal {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 40px;
    border-radius: 15px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
    max-width: 600px;
    width: 90%;
    z-index: 1001;
    max-height: 90vh;
    overflow-y: auto;
}

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }
        
        .modal-header {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            border-bottom: 2px solid #4682b4;
            padding-bottom: 15px;
        }
        
        .modal-content-text {
            font-size: 16px;
            line-height: 1.8;
            color: #555;
            text-align: justify;
        }
        
        .close-btn {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 30px;
            color: #999;
            cursor: pointer;
        }
        
        .close-btn:hover {
            color: #333;
        }
        
        "

  ),
  title = "Mortalidad y género",
  
  # Overlay del modal (se usa uno solo para ambos modales)
  div(class = "modal-overlay", id = "modalOverlay"),
  
  # 1. Modal elegante (Original)
  div(class = "elegant-modal", id = "elegantModal",
      span(class = "close-btn", id = "closeBtn", "×"),
      div(class = "modal-header", uiOutput("modalTitle")),
      div(class = "modal-content-text",
          uiOutput("modalContent")
      )
  ),
  
  div(class = "fixed-icon", id = "fixedIcon",
      tags$i(class = "fas fa-info")
  ),
  
  tags$script(HTML("
 $(document).ready(function() {
$('#fixedIcon').on('click', function() {
$('#elegantModal').show();
$('#modalOverlay').show();
});

$('#closeBtn, #modalOverlay').on('click', function() {
$('#elegantModal').hide();
$('#modalOverlay').hide();
});
});
")),
  
  # Contenido principal sin margen adicional para páginas completas
  router_ui(
    route("/", landing_page),
    route("chart", chart_page),
    route("gaps", gaps_page),
    route("map", map_page),
    route("juri", juri_page),
    route("hotspots", hotspots_page),
    route("download", download_page)
    
  )
)

server <- function(input, output, session) {
  
  
  
  
  if (firstTime == 0) {
    click("fixedIcon")
    firstTime <<- 1
  }
  
  observeEvent(input$byCausas_DL, {
    if (input$byCausas_DL == "Sí") {
      show("causas_DL", anim = T, animType = "fade")
    } else {
      hide("causas_DL", anim = T, animType = "fade")
    }
  })
  
  
  
  router_server()
  tableDownloadData = reactiveVal(data.frame())
  
  updateRadioButtons(session, "juriJuri" ,choices = labels_provincia[2:25])
  
  output$modalContent = renderUI({
    current_page = get_page()
    modalText(current_page)$content
  })
  
  output$modalTitle = renderUI({
    current_page = get_page()
    modalText(current_page)$title
  })
  
  outputOptions(output, "modalContent", suspendWhenHidden = FALSE)
  outputOptions(output, "modalTitle", suspendWhenHidden = FALSE)
  
  
  
  observeEvent(input$geo, {
    if (input$geo == "Jurisdicciones") {
      updateSelectInput(session,"area",choices = labels_provincia, selected = "01")
    } else {
      updateSelectInput(session,"area",choices = labels_region, selected = labels_region[1])
    }
  })
  
  observeEvent(input$geoGaps, {
    if (input$geoGaps == "Jurisdicciones") {
      updateSelectInput(session,"areaGaps",choices = labels_provincia, selected = "01")
    } else {
      updateSelectInput(session,"areaGaps",choices = labels_region, selected = labels_region[1])
    }
  })
  
  observeEvent(input$geo_DL, {
    if (input$geo_DL == "Jurisdicciones") {
      updateSelectInput(session,"area_DL",choices = labels_provincia, selected = "01")
    } else {
      updateSelectInput(session,"area_DL",choices = labels_region, selected = labels_region[1])
    }
  })
  
  
  datosFiltrados = reactive({
    if (get_page() == "chart") {
      causaSeleccionada = input$causas
      
      if (input$geo == "Jurisdicciones") {
        dataset = dataMortProv
        area = "provincia"
      } else {
        area = "region"
        dataset = dataMortReg
      }
      
      if (length(causaSeleccionada)>0){
        data = dataset %>% dplyr::filter(causa == causaSeleccionada)
      }
    } else if (get_page() == "gaps") {
      causaSeleccionada = input$causasGaps
      
      if (input$geoGaps == "Jurisdicciones") {
        dataset = dataMortProv
        area = "provincia"
      } else {
        area = "region"
        dataset = dataMortReg
      }
      
      if (length(causaSeleccionada)>0){
        data = dataset %>% dplyr::filter(causa == causaSeleccionada)
      }
    }
    
     else {data=data.frame()}
    
    data
    
  })
  
  # output$comparisonChart = renderApexchart({
  #   browser()
  #   comparisonChart()[[1]]
  # 
  # })
  
  # output$map = renderLeaflet({
  #   leaflet() %>% addTiles() %>%
  #     setView(lng = 144, lat = -37, zoom = 09)
  # })
  
  
  output$grafico = renderUI({
    
    if (get_page(session = shiny::getDefaultReactiveDomain()) == "chart") {
      
      compChart = comparisonChart(
        input,
        output,
        session,
        datosFiltrados,
        indicatorsList,
        labels_provincia,
        labels_region,
        labels_sexo,
        diferenciaTasas)
      
      compChart[[1]]
      
    }
  })
  
  output$gaps = renderUI({
    if (length(input$causas)>0) {
      gapsChart(
        input,
        output,
        session,
        datosFiltrados,
        labels_provincia,
        labels_region,
        labels_sexo,
        ratesRatio,
        ratesDifferences
      )
    } else {
      HTML("<strong>Advertencia: </strong><br>Debe seleccionar al menos un grupo de causas de muerte")
    }
    
  })
  
  output$mapa = renderUI({
    
    if (is.null(input$causasMap)) {
      return(
        tagList(
          HTML("<hr/><strong>Debe seleccionar un grupo de causas para visualizar los mapas</strong><hr/>"),
        )
      )
    }
    
    if (get_page()=="map") {
      hide("fixedIcon", anim = T, animType = "fade")
      withProgress(message = 'Generando mapas',
                   detail = 'Esta acción puede tardar...', value = 0, {
                     incProgress(0.1)
                     #trienio = input$trienio
                     causa = input$causasMap
                     #browser()
                     data1 = rmsCalculate(input,output,"1", causa, "cuartiles","2")
                     incProgress(0.1)
                     data2 = rmsCalculate(input,output,"2", causa, "cuartiles","2")
                     incProgress(0.1)
                     data3 = rmsCalculate(input,output,"3", causa, "cuartiles","2")
                     incProgress(0.1)
                     datosMapa = list(
                       "data1" = data1,
                       "data2" = data2,
                       "data3" = data3
                     )
                     
                     incProgress(0.1)
                     valores = c(
                       data1$RME,
                       data2$RME,
                       data3$RME)
                     
                     colores_cuartiles_ggplot <- c(
                       "1" = "#f2f0f7",
                       "2" = "#cbc9e2",
                       "3" = "#9e9ac8",
                       "4" = "#6a51a3")
                     
                     # función para calcular cuartiles
                     cuartiles = function(df, variable) {
                       datos = df[[variable]]
                       quintiles <- quantile(datos, probs = c(0, 0.25, 0.5, 0.75, 1))
                       rangos_cuartiles <- cut(datos, quintiles, labels = c("Q1", "Q2", "Q3", "Q4"), include.lowest = TRUE)
                       rangos_cuartiles
                     }
                     
                     incProgress(0.2)
                     cuartiles = cuartiles(
                       data.frame(valores=valores),
                       "valores"
                     )
                     
                     cuartiles = cbind(valores, cuartiles)
                     cuartiles = cuartiles %>% as.data.frame()
                     cuartiles = cuartiles %>% arrange(valores)
                     incProgress(0.1)
                     minMax = data.frame(
                       cuartil = c("1","2","3","4"),
                       min = c(min(cuartiles$valores[cuartiles$cuartiles==1]),
                               min(cuartiles$valores[cuartiles$cuartiles==2]),
                               min(cuartiles$valores[cuartiles$cuartiles==3]),
                               min(cuartiles$valores[cuartiles$cuartiles==4])),
                       max = c(max(cuartiles$valores[cuartiles$cuartiles==1]),
                               max(cuartiles$valores[cuartiles$cuartiles==2]),
                               max(cuartiles$valores[cuartiles$cuartiles==3]),
                               max(cuartiles$valores[cuartiles$cuartiles==4]))
                     )
                     
                     valor_min <- min(valores)
                     valor_max <- max(valores)
                     incProgress(0.1)
                     datosMapa$data1 = datosMapa$data1 %>% left_join(cuartiles, by = c("RME"="valores"))
                     datosMapa$data2 = datosMapa$data2 %>% left_join(cuartiles, by = c("RME"="valores"))
                     datosMapa$data3 = datosMapa$data3 %>% left_join(cuartiles, by = c("RME"="valores"))
                     
                     mapa_por_trienio <- function(trienio) {
                       
                       dataset = paste0("data",trienio)
                       
                       shpMapa <- datosMapa[[dataset]]
                       
                       shpMapa = shpMapa %>% left_join(data.frame(cuartiles = as.numeric(names(colores_cuartiles_ggplot)), color = colores_cuartiles_ggplot))
                       incProgress(0.1)
                       mapa_principal <- ggplot(data = shpMapa) +
                         geom_sf(aes(fill = color), color = "grey", size = 0.2, alpha = 0.8) +
                         scale_fill_identity() +
                         geom_segment(aes(x = -58.4, xend = -56.0,
                                          y = -34.5, yend = -34.5),
                                      color = "grey", linewidth = 0.3) +
                         theme_void()
                       
                       submapa <- ggplot(data = shpMapa[shpMapa$in1 == "02000", ]) +
                         geom_sf(aes(fill = color), color = "grey", size = 0.5, alpha = 0.8) +
                         scale_fill_identity() +
                         theme_void() +
                         theme(
                           panel.border = element_rect(color = "#bdbdbd", fill = NA, linewidth = 0.1)
                         )
                       
                       # Combinar con inset
                       mapa_principal + inset_element(submapa,
                                                      left = 0.85, right = 0.95,
                                                      bottom = 0.58, top = 0.63)
                       
                       
                       
                       
                     }
                     
                     
                     mapas = lapply(c("1","2","3"), mapa_por_trienio)
                     
                     
                     incProgress(0.1)
                     output$mapa1 = renderPlot({
                       mapas[[1]]
                     })
                     
                     output$mapa2 = renderPlot({
                       mapas[[2]]
                     })
                     incProgress(0.1)
                     output$mapa3 = renderPlot({
                       mapas[[3]]
                     })
                     
                     limInf = minMax$min
                     limSup = minMax$max
                     colores = colores_cuartiles_ggplot
                     
                     causaSel = stringr::str_to_lower(substring(causa,6,nchar(causa)))
                     titulo = glue("Evolución de la mortalidad por {causaSel} en áreas menores")
                     
                     show("fixedIcon", anim = T, animType = "fade")
                     
                     tagList(
                       tags$style(HTML("
                                     .map-container {
                                         text-align: center;
                                         padding: 20px;
                                         border-right: 1px solid #ddd;
                                     }
                                     .map-container:last-child {
                                         border-right: none;
                                     }
                                     .map-title {
                                         font-size: 24px;
                                         font-weight: bold;
                                         margin-bottom: 20px;
                                         color: #2C5F8B;
                                     }
                                     .vs-badge {
                                         display: inline-block;
                                         background-color: white;
                                         border: 2px solid #ddd;
                                         border-radius: 50%;
                                         width: 40px;
                                         height: 40px;
                                         line-height: 36px;
                                         text-align: center;
                                         font-weight: bold;
                                         margin-top: 20px;
                                         color: #666;
                                     }
                                     
                                     
                                     ")),
                       fluidRow(
                         column(12,
                                div(
                                  h3(titulo),
                                  style = "padding: 4px; color: #EE7F00;
                                  "),
                                align = "center"),
                                
                       ),
                       tags$div(
                         style = "display: flex; width: 100%;",
                         
                         tags$div(
                           class = "map-container",
                           style = "flex: 1;",
                           tags$div(class = "map-title", "Trienio 2000-2002"),
                           plotOutput("mapa1", height = "400px"),
                           tags$div(class = "vs-badge", "1")
                         ),
                         
                         tags$div(
                           class = "map-container",
                           style = "flex: 1;",
                           tags$div(class = "map-title", "Trienio 2009-2011"),
                           plotOutput("mapa2", height = "400px"),
                           tags$div(class = "vs-badge", "2")
                         ),
                         
                         tags$div(
                           class = "map-container",
                           style = "flex: 1;",
                           tags$div(class = "map-title", "Trienio 2021-2023"),
                           plotOutput("mapa3", height = "400px"),
                           tags$div(class = "vs-badge", "3")
                         )
                       ),
                       hr(),
                       column(
                         3,
                         tags$h6("Referencias"),
                         mapsLeyend(limInf,limSup, colores)
                       )
                     )
                     
                     
                     
                     
                     
                     
                   })
      
    } else {
      return()
    }
    

  
  })
  
  tlValue = reactiveValues()
  
  
  output$graficoJuris = renderUI({
    if (input$juriJuri == "" |
        length(input$causasJuri) == 0) {return()}
    
    load("data/dataMortProv.rda")
    
    indicadorSel = indicatorsList()[c(2,3,7:9)]
    tlColors = c()
    if (length(input$area)>1) {return()}
    
    
      for (i in 1:length(indicadorSel)) {
        
        
        
        local({
          for (sx in 1:2) {
            local({
            
              maxY = dataMortProv %>% dplyr::filter(
                ano == "2023",
                causa == input$causasJuri
              ) %>% dplyr::select(all_of(indicadorSel[i]))
              
              maxY = max(as.matrix(maxY))
              
              jurisSel = input$juriJuri
          causaSel = input$causasJuri
          anoSel = "2023"
          sexoSel = as.character(sx)
          
          datos = dataMortProv %>% dplyr::filter(
            causa == causaSel,
            ano == anoSel,
            sexo == sexoSel) %>%
            dplyr::select(
              ano, provincia ,causa, sexo, all_of(indicadorSel[i]))
          
          datos = datos %>% arrange((desc(.[[ncol(datos)]])))
          
          
          
          
          
          datos$color = NA
          datos$color = "#ee7f00"
          datos$color[datos$provincia == "01"] = "#bdbdbd"
          datos$color[datos$provincia == input$juriJuri] = "#264671"
          datos$color[datos$provincia == input$juriJuri]
          datos$value = round(datos[[names(indicadorSel[i])]],1)
          datos$provLabel = NA
          
          for (k in 1:nrow(datos)) {
            datos$provLabel[k] = names(labels_provincia[labels_provincia==datos$provincia[k]])
          }
          
          
          graficoJuris =
            datos %>%
            hchart(type = 'column', hcaes(x = provLabel, y = !!sym(names(indicadorSel[i])) , color = color), name = "") %>%
            #hc_title(text = "Example Bar Chart") %>%
            hc_xAxis(
              categories = datos$provLabel,
              labels = list(enabled = FALSE), # Oculta las categorías
              title = list(text = "Jurisdicciones") # Muestra el título
            ) %>%
            hc_yAxis(visible = F,
                     max = maxY) %>%
            #hc_add_series(data = datos[[names(indicadorSel[i])]], name = "") %>%
            hc_legend(enabled = FALSE) %>%
            hc_plotOptions(
              column = list(
                # Eliminates space between individual columns
                pointPadding = 0.1,
                # Eliminates space at the edges and between column groups
                groupPadding = 0.1,
                # Optional: Makes bars touch the x-axis line
                borderWidth = 0
              )
            ) %>%
            hc_tooltip(
              headerFormat = '<b>{point.x}</b><br>',
              pointFormat = '<b>{point.y:,.1f}</b>'
            )
          
          valorProv = datos$value[datos$provincia == input$juriJuri]
          rank = max(which(sort(datos$value[datos$provincia!="01"])==valorProv))
          colorTrafficLight = NA
          
          if (rank %in% c(1:8)) {colorTrafficLight = "green"} else if (rank %in% c(9:16)) {colorTrafficLight = "yellow"} else {colorTrafficLight = "red"}
          
          tlColors = c(tlColors, colorTrafficLight)
          tlValue[[paste0(i,"_",sx)]] = colorTrafficLight
          output[[glue("graf_{i}_{sx}")]] = renderHighchart({
            graficoJuris})
          
            })
          }
          
        })    
          
      }
    
      

    
    
    
    
    tagList(
      fluidRow(
        column(6,
               h3("Varones", style = "color: #AE94D8;"),
               hr(),
               align = "center"),
        column(6,
               h3("Mujeres", style = "color: #AE94D8;"),
               hr(),
               align = "center")
      ),
      
        lapply(seq_along(indicadorSel), function (j) {
          fluidRow(
            column(6,
                   div(style = "padding: 8px;",
                       infoBox(
                         title = paste(names(indicadorSel[j])),
                               text = paste0("graf","_",j),
                               iconType = "globe",
                               iconColor = "#bcbddc",
                               linkTo = "",
                               outputName = glue("graf_{j}_1"),
                               juriSel = names(labels_provincia[labels_provincia==input$juriJuri]),
                               trafficLightState = tlValue[[paste(paste0(j,"_","1"))]])
                   )
                  ),
            column(6,
                   div(style = "padding: 8px;",
                       infoBox(

                         title = paste(names(indicadorSel[j])),
                               text = paste0("graf","_",j),
                               iconType = "globe",
                               iconColor = "#bcbddc",
                               linkTo = "",
                               outputName = glue("graf_{j}_2"),
                               juriSel = names(labels_provincia[labels_provincia==input$juriJuri]),
                               trafficLightState = tlValue[[paste0(j,"_","2")]])
                   )
                   )
                   
            
          
          
          )
        })
        
      )
      
    
    
  })
  
  output$hotSpots = renderUI({
    if (get_page() =="hotspots") {
      hide("fixedIcon", anim = T, animType = "fade")
      withProgress(message = 'Generando mapas',
                   detail = 'Esta acción puede tardar...', value = 0, {
                     resultados = hotSpots(input$trienio_HS,input$causas_HS)
                   })
      show("fixedIcon", anim = T, animType = "fade")
      resultados
    }
    
    
  })
  
  output$tableDownload = renderUI({
    if (get_page() != "download") {return()}
    geo = input$geo_DL
    
    if (geo == "Jurisdicciones") {
      data = dataMortProv
      geoVar = "provincia"
      labels = labels_provincia
    } else {
      data = dataMortReg
      geoVar = "region"
      labels = labels_region
    }
    
    indSel = input$indicador_DL
    areaSel = input$area_DL
    causaSel = if (input$byCausas_DL == "Sí") {
      input$causas_DL
    } else {
      "0000 TODAS LAS CAUSAS"
    }
    
    if (is.null(data) | is.null(input$area_DL)) {return()}
    data = data %>% dplyr::select(ano, UQ(geoVar), sexo, causa, UQ(indSel))
    data = data %>% dplyr::filter(
      get(geoVar) %in% areaSel,
      causa %in% causaSel,
      ano %in% min(input$anos_DL):max(input$anos_DL))
    
    
    if (geoVar == "provincia") {
      for (i in 1:nrow(data)) {
        data$provincia[i] = names(labels_provincia[labels_provincia==data$provincia[i]])
      }
    } else {
        for (i in 1:nrow(data)) {
          data$region[i] = names(labels_region[labels_region==data$region[i]])
        }
      }
    
    data$sexo[data$sexo == "0"] = "Ambos sexos"
    data$sexo[data$sexo == "1"] = "Varones"
    data$sexo[data$sexo == "2"] = "Mujeres"
    
    colnames(data)[1:4] = c("Año", "Área geográfica", "Sexo", "Grupo de causas")
    
    for (i in colnames(data)) {
      if (i %in% indicatorsList()) {
        colnames(data)[colnames(data) == i] = names(indicatorsList()[indicatorsList()== i])
      }
    }
    
    
    data = data %>% mutate(
      across(starts_with("Cantidad"), ~ sprintf("%.0f", .x)),
      across(starts_with("Tasa"), ~ sprintf("%.1f", .x))
    )
    
    columnNames <- names(data)
    columnRight <- columnNames[5:length(columnNames)]
    
    col_defs <- lapply(columnNames, function(col_name) {
      colDef(
        align = "right", 
        style = list(justifyContent = "flex-end")
      )
    })
    
    names(col_defs) <- columnNames
    
    tableDownloadData(data)
    
    tagList(
      reactable(
        data,
        groupBy = "Año",
        columns = col_defs
      )
    )
    
  })
    
  output$tableDownloadFile <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      data = tableDownloadData()
      writexl::write_xlsx(data, file)
    }
  )
  

  
}
  

shinyApp(ui, server)
