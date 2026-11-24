hotSpots = function (trienio, causa) {
  ##### PREPARACION DE DATOS #####
  # cargar poblaciones por departamentos
  load("data/population/pobDeptosCenso.rda")
  
  # carga mapa de polígonos de departamentos
  load("data/maps/mapaSimple.rda")
  
  # carga dataset de tasas de mortalidad de población estandar
  load("data/population/tasasEstandarizadas.rda")
  load("data/indicators/NBIDEPTOS.rda")
  
  # crea lista para guardar resultados
  resultados = list()
  
  # carga lista de causas de mortalidad
  load("data/mortalityCauses.rda")
  mortalityCauses = mortalityCauses %>% pivot_longer(cols= 1:ncol(mortalityCauses),names_to = "LISTA") %>% dplyr::filter(is.na(value)==F) %>% distinct(LISTA, value)
  
  # identifica lista de la causa seleccionada
  lista = max(mortalityCauses$LISTA[mortalityCauses$value==causa] )
  
  # identifica el año del censo y los años de las defucniones según el trienio seleccionado
  if (trienio == 1) {
    anoCenso = "2001"
    anosDef = 2000:2002
    anosDef = substring(anosDef,3,4)
  } else if (trienio == 2) {
    anoCenso = "2010"
    anosDef = 2009:2011
    anosDef = substring(anosDef,3,4)
  } else if (trienio == 3) {
    anoCenso = "2022"
    anosDef = 2021:2023
    anosDef = substring(anosDef,3,4)
  }
  
  labelsDeptos = pobDeptosCenso[pobDeptosCenso$ANO == anoCenso & pobDeptosCenso$SEXO == 2,] %>% dplyr::select(in1 = CODIGODEPTO, NOMDPTO)
  
  # formatea df de población:
  # - filtra mujeres
  # - agrupa edades
  
  pobDeptosCenso = pobDeptosCenso %>% dplyr::filter(SEXO == 2) %>% pivot_longer(cols = 5:(ncol(pobDeptosCenso)-1), names_to = "GRUPEDAD", values_to = "POBLACION")
  
  pobDeptosCenso$GRUPEDAD[pobDeptosCenso$GRUPEDAD %in% c("POB7579","POB8084","POB8589","POB9094","POB95MAS")] = "POB75MAS"
  
  pobDeptosCenso = pobDeptosCenso %>% mutate(GRUPEDAD_DEPTOS = case_when(
    GRUPEDAD == "POB0004" ~ "POB0004",
    GRUPEDAD == "POB0509" ~ "POB0514",
    GRUPEDAD == "POB1014" ~ "POB0514",
    GRUPEDAD == "POB1519" ~ "POB1524",
    GRUPEDAD == "POB2024" ~ "POB1524",
    GRUPEDAD == "POB2529" ~ "POB2534",
    GRUPEDAD == "POB3034" ~ "POB2534",
    GRUPEDAD == "POB3539" ~ "POB3544",
    GRUPEDAD == "POB4044" ~ "POB3544",
    GRUPEDAD == "POB4549" ~ "POB4554",
    GRUPEDAD == "POB5054" ~ "POB4554",
    GRUPEDAD == "POB5559" ~ "POB5564",
    GRUPEDAD == "POB6064" ~ "POB5564",
    GRUPEDAD == "POB6569" ~ "POB6574",
    GRUPEDAD == "POB7074" ~ "POB6574",
    GRUPEDAD == "POB75MAS" ~ "POB75MAS"
  )) %>% 
    dplyr::filter(is.na(GRUPEDAD_DEPTOS) == F) %>%
    group_by(ANO, CODIGODEPTO, SEXO, GRUPEDAD_DEPTOS) %>%
    summarise(POBLACION = sum(POBLACION))
  
  # carga defunciones del trienio seleccionado
  if (trienio == 1) {
    load("data/population/defTri1.rda")
  } else if (trienio == 2) {
    load("data/population/defTri2.rda")
  } else if (trienio == 3) {
    load("data/population/defTri3.rda")
  }
  
  # filtra según la causa seleccionada
  
  if (is.null(causa)) {return()}
  if (causa != "0000 TODAS LAS CAUSAS") {
    muertes = defTri %>% dplyr::filter(get(lista) == causa)
  } else {
    muertes = defTri
  }
  
  # formatea df de muertes
  muertes = muertes %>% 
    group_by(CODIGODEPTO, SEXO, GRUPEDAD_DEPTOS) %>%
    summarise(DEFUNCIONES= n())
  
  # crea tabla con información de población y muertes por departamento
  pobDeptosCenso$CODIGODEPTO = as.character(pobDeptosCenso$CODIGODEPTO)
  tablaDeptos = 
    pobDeptosCenso[pobDeptosCenso$ANO==anoCenso & pobDeptosCenso$SEXO %in% c(1,2),] %>% 
    left_join(muertes, by = c("CODIGODEPTO","GRUPEDAD_DEPTOS","SEXO"))
  tablaDeptos$DEFUNCIONES[is.na(tablaDeptos$DEFUNCIONES)] = 0
  
  # crea tabla de tasas de mortalidad estandar
  tasasEstandar = tasasEstandar[tasasEstandar$CAUSA == causa,]
  
  # crea tabla con RMEs y NBI por depto
  RMEtable = data.frame()
  for (i in unique(tablaDeptos$CODIGODEPTO)) {
    #for (i = "70126") {
    RME = ageadjust.indirect(
      count = tablaDeptos$DEFUNCIONES[tablaDeptos$CODIGODEPTO == i],
      pop = tablaDeptos$POBLACION[tablaDeptos$CODIGODEPTO == i]*3,
      stdcount = tasasEstandar$DEFUNCIONES,
      stdpop = tasasEstandar$POBLACION,
      stdrate = NULL, 
      conf.level = 0.95
    )
    
    NBI = list(
      NBI_MUJERES = NBIDEPTOS$`MUJER NBI SI`[NBIDEPTOS$REDCODE==i & NBIDEPTOS$AÑO == anoCenso],
      DENOM_NBI = NBIDEPTOS$`TOTAL MUJERES`[NBIDEPTOS$REDCODE==i & NBIDEPTOS$AÑO == anoCenso]
    )
    
    NBI$PROPNBI_MUJERES = NBI$NBI_MUJERES/NBI$DENOM_NBI
    
    append = data.frame(
      CODIGODEPTO = i,
      RME = RME$sir[["sir"]],
      STDRATE = RME$rate[["adj.rate"]],
      DEFUNCIONES = sum(tablaDeptos$DEFUNCIONES[tablaDeptos$CODIGODEPTO == i]),
      POBLACION = sum(tablaDeptos$POBLACION[tablaDeptos$CODIGODEPTO == i])*3,
      ESPERADAS = RME$sir[["exp"]],
      NBI_MUJERES = NBI$NBI_MUJERES,
      DENOM_NBI_MUJERES = NBI$DENOM_NBI,
      PROP_NBI_MUJERES = NBI$PROPNBI_MUJERES
    )
    
    RMEtable = rbind(
      RMEtable,
      append
    )
    
  }
  
  datosMapa = RMEtable %>% dplyr::select(CODIGODEPTO, POBLACION, RME, DEFUNCIONES, ESPERADAS, STDRATE, NBI_MUJERES, DENOM_NBI_MUJERES, PROP_NBI_MUJERES)
  colnames(datosMapa)[1]="in1"
  
  # suma indicadores al mapa
  mapa = mapa %>% left_join(datosMapa)
  
  
  ##### MAPA RME #####
  incProgress(0.25)
  # crea paleta de colores para cuartiles
  paleta = data.frame(
    cuartiles = c("Q1","Q2","Q3","Q4"),
    color = c("#ffffd4","#fed98e","#fe9929","#cc4c02")
  )
  
  # función para calcular cuartiles
  cuartiles = function(df, variable) {
    datos = df[[variable]]
    quintiles <- quantile(datos, probs = c(0, 0.25, 0.5, 0.75, 1))
    rangos_cuartiles <- cut(datos, quintiles, labels = c("Q1", "Q2", "Q3", "Q4"), include.lowest = TRUE)
    rangos_cuartiles
  }
  
  # asigna colores a los cuartiles
  cuartiles = data.frame(
    cuartiles = cuartiles(mapa, "RME")
  ) %>% left_join(paleta)
  
  # agrega cuartiles a mapa
  mapa$cuartiles = cuartiles$cuartiles
  mapa$color = cuartiles$color
  
  # calcula mínimos y máximos de cuartiles para crear la leyenda del mapa
  minMax = data.frame(
    cuartiles = c("Q1","Q2","Q3","Q4"),
    minimo = c(
      min(mapa$RME[mapa$cuartiles=="Q1"]),
      min(mapa$RME[mapa$cuartiles=="Q2"]),
      min(mapa$RME[mapa$cuartiles=="Q3"]),
      min(mapa$RME[mapa$cuartiles=="Q4"])),
    maximo = c(
      max(mapa$RME[mapa$cuartiles=="Q1"]),
      max(mapa$RME[mapa$cuartiles=="Q2"]),
      max(mapa$RME[mapa$cuartiles=="Q3"]),
      max(mapa$RME[mapa$cuartiles=="Q4"]))
    
  )
  
  # crea texto de la leyenda
  minMax$rango = paste0(
    format(minMax$minimo, digits = 3, big.mark = ".", decimal.mark = ","),
    " - ",
    format(minMax$maximo, digits = 3, big.mark = ".", decimal.mark = ",")
  )
  
  # crea mapa de RMEs por cuartiles
  MAPA_RME <-leaflet(mapa %>% left_join(labelsDeptos)) %>%
    addPolygons(color = "#f0f0f0" ,
                weight = 0, 
                opacity = 1.0,
                fillOpacity = 0.8,
                fillColor = ~color,    # Color de llenado
                group = cuartiles,
                layerId = ~mapa$in1,                  
                label = ~paste0("Area: ", NOMDPTO, ", RME: ", round(mapa$RME,1)), # etiqueta cuando pasas el cursor
                labelOptions = labelOptions(direction = "auto")) %>%
    addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
             attribution = "Argenmap v2 - Instituto Geográfico Nacional") %>%
    addLegend(
      position = "bottomleft", colors = paleta$color, labels = minMax$rango, title = "Razones de mortalidad estandarizadas")
  
  # agrega mapa a la lista de resultados
  resultados[["RME"]] = MAPA_RME
  
  ##### ANALISIS LISA #####
  
  # crea matriz de vecindad
  #vecinos <- poly2nb(mapa[mapa$in1!="94000",], queen = TRUE)  # queen=TRUE incluye contactos en vértices
  load("data/maps/vecinos.rda")
  
  
  # crea matriz de pesos espaciales
  pesos_espaciales <- nb2listw(vecinos, style = "W", zero.policy = TRUE)
  load("data/maps/pesos_espaciales.rda")
  
  # calcula test de Moran
  resultado_moran <- moran.test(mapa$RME[mapa$in1!="94000"], pesos_espaciales)
  
  # agrega resultados de test a la lista de resultados
  resultados[["LISA"]][["MORAN TEST"]] = resultado_moran
  
  
  ##### GRAFICO DE AUTOCORRELACION ESPACIAL #####
  
  # calcular spatial lag de las RMEs
  lag_rme <- lag.listw(pesos_espaciales, mapa$RME[mapa$in1!="94000"], zero.policy = TRUE)
  
  # calcula los promedios
  mean_rme <- mean(mapa$RME[mapa$in1!="94000"], na.rm = TRUE)
  mean_lag_rme <- mean(lag_rme, na.rm = TRUE)
  
  # ajusta el modelo lineal (para la recta de mínimos cuadrados en el gráfico)
  modelo_lm <- lm(lag_rme ~ mapa$RME[mapa$in1!="94000"])
  intercepto <- coef(modelo_lm)[1]
  pendiente <- coef(modelo_lm)[2]
  min_rme <- min(mapa$RME[mapa$in1!="94000"], na.rm = TRUE)
  max_rme <- max(mapa$RME[mapa$in1!="94000"], na.rm = TRUE)
  recta_x <- c(min_rme, max_rme)
  recta_y <- intercepto + pendiente * recta_x
  
  # crea el gráfico de autocorrelación espacial con apexcharter
  grafico_moran = apex(data = mapa[mapa$in1!="94000",], aes(x = RME, y = lag_rme), type = "scatter", colors = c("#656565")) %>%
    add_line(
      aes(
        x = recta_x,
        y = recta_y
      )
    ) %>%
    ax_chart(toolbar = list(show = F)) %>%
    ax_legend(show = F) %>%
    
    ax_markers(
      strokeColor = "#D1B5E5", 
      size = 4,
      color = "#EBE1F3"
    ) %>%
    ax_xaxis(
      axisBorder = list(show = TRUE),
      plotLines = list(
        list(
          value = mean_rme,
          color = "#30658E",
          lineWidth = 1,
          dashArray = 5
        )
      )
    ) %>%
    ax_yaxis(
      axisBorder = list(show = TRUE),
      plotLines = list(
        list(
          value = mean_lag_rme,
          color = "gray",
          lineWidth = 1,
          dashArray = 5
        )
      )
    ) %>%
    ax_colors("black") %>% 
    ax_tooltip(
      shared = TRUE,
      y = list(
        title = list(
          formatter = JS("function(seriesName) {
          if (seriesName === 'lag_rme') {
            return 'Spatial lag';
          }
          return seriesName; // Keep original name for other series if any
        }")
        )
      )
    )
  
  # agrega el gráfico a resultados
  resultados[["LISA"]][["SPATIAL CORRELATION PLOT"]] = grafico_moran 
  
  
  ##### MAPA NBI #####
  incProgress(0.25)
  # crea paleta de colores para cuartiles
  paleta = data.frame(
    cuartiles = c("Q1","Q2","Q3","Q4"),
    color = c("#f2f0f7","#cbc9e2","#9e9ac8","#6a51a3")
  )
  
  # función para calcular cuartiles
  cuartiles = function(df, variable) {
    datos = df[[variable]]
    quintiles <- quantile(datos, probs = c(0, 0.25, 0.5, 0.75, 1))
    rangos_cuartiles <- cut(datos, quintiles, labels = c("Q1", "Q2", "Q3", "Q4"), include.lowest = TRUE)
    rangos_cuartiles
  }
  
  # asigna colores a los cuartiles
  cuartiles = data.frame(
    cuartiles = cuartiles(mapa, "PROP_NBI_MUJERES")
  ) %>% left_join(paleta)
  
  # agrega cuartiles a mapa
  mapa$cuartiles = cuartiles$cuartiles
  mapa$color = cuartiles$color
  
  # calcula mínimos y máximos de cuartiles para crear la leyenda del mapa
  minMax = data.frame(
    cuartiles = c("Q1","Q2","Q3","Q4"),
    minimo = c(
      min(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q1"]),
      min(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q2"]),
      min(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q3"]),
      min(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q4"])),
    maximo = c(
      max(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q1"]),
      max(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q2"]),
      max(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q3"]),
      max(mapa$PROP_NBI_MUJERES[mapa$cuartiles=="Q4"]))
    
  )
  
  # crea texto de la leyenda
  minMax$rango = paste0(
    format(round(minMax$minimo*100,1), big.mark = ".", decimal.mark = ","),
    " - ",
    format(round(minMax$maximo*100,1), big.mark = ".", decimal.mark = ",")
  )
  
  
  mapa = mapa %>% left_join(labelsDeptos)
  
  # crea mapa de RMEs por cuartiles
  MAPA_NBI <-leaflet(mapa) %>%
    addPolygons(color = "#f0f0f0" ,
                weight = 0, 
                opacity = 1.0,
                fillOpacity = 0.8,
                fillColor = ~color,    # Color de llenado
                group = cuartiles,
                layerId = ~mapa$in1,                  
                label = ~paste0("Area: ", mapa$NOMDPTO, ", NBI en mujeres: ", round(mapa$PROP_NBI_MUJERES*100,3)), # etiqueta cuando pasas el cursor
                labelOptions = labelOptions(direction = "auto")) %>%
    addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
             attribution = "Argenmap v2 - Instituto Geográfico Nacional") %>%
    addLegend(
      position = "bottomleft", colors = paleta$color, labels = minMax$rango, title = "Porcentaje de mujeres residentes en hogares con NBI")
  
  # agrega mapa a la lista de resultados
  resultados[["NBI"]] = MAPA_NBI
  
  
  
  resultados[["RME y NBI"]] = hchart(
    mapa,
    "scatter", # Tipo de gráfico de dispersión
    hcaes(
      x = PROP_NBI_MUJERES, # Variable en el eje X
      y = RME,             # Variable en el eje Y
      group = cuartiles,     # Agrupar por cuartil para asignar colores
      name = in1  # Usar el nombre del departamento en el tooltip
    )
  ) %>%
    hc_yAxis(title = list(text = "Razón de Mortalidad Estandarizada (RME)")) %>%
    hc_tooltip(
      pointFormat = paste0(
        "<b>Departamento:</b> {point.name}<br>",
        "<b>% Mujeres con NBI:</b> {point.PROP_NBI_MUJERES:.2f}%<br>", # .2f para 2 decimales
        "<b>RME:</b> {point.RME:.1f}<br>", # .1f para 1 decimal
        "<b>Cuartil:</b> {point.cuartil}"
      )
    ) 
  
  spearmanTest = cor.test(mapa$PROP_NBI_MUJERES, mapa$RME, method = "spearman")
  resultados[["SPEARMAN"]] = spearmanTest
  
  ##### MAPA DE LISA CLUSTERING #####
  incProgress(0.25)
  
  # calcula Moran local
  lisa <- localmoran(mapa$RME[mapa$in1!="94000"], pesos_espaciales)
  moran_mc <- moran.mc(mapa$RME[mapa$in1!="94000"], pesos_espaciales, nsim = 999)
  mapa$Ii[mapa$in1!="94000"] <- lisa[, 1]  # valor del índice local
  mapa$p_valor[mapa$in1!="94000"] <- lisa[, 5]  # p-valor asociado
  
  # data frame con datos LISA
  lisa = data.frame(attr(lisa,"quadr"))
  mapa$lisa[mapa$in1!="94000"] = as.character(lisa$median)
  mapa$lisa[mapa$p_valor <0.05] = "No sig"
  
  # crea paleta de colores
  paleta_colores <- colorFactor(
    palette = c("#e34a33","#fdbb84","#a6bddb","#2b8cbe","white"),  
    domain = as.factor(mapa$lisa)
  )
  mapaProv = geoAr::get_geo("ARGENTINA", "provincia")
  # crea mapa
  MAPA_LISA <- leaflet(mapa) %>%
    addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
             attribution = "Argenmap v2 - Instituto Geográfico Nacional") %>% # Añade el mapa base
    addPolygons(
      fillColor = ~paleta_colores(lisa), # Asigna color según la categoría en 'lisa'
      color = "black",                     # Color del borde de los polígonos
      weight = 0,                          # Grosor del borde
      opacity = 1,                         # Opacidad del borde
      fillOpacity = 0.8,                   # Opacidad del relleno
      label = ~paste0("Área: ", mapa$NOMDPTO, ", Categoría LISA: ", lisa) # Popup opcional al hacer clic
    ) %>%
    addLegend(
      position = "bottomleft",
      pal = paleta_colores,
      values = ~lisa,
      title = "Categoría LISA",
      opacity = 1
    ) %>% addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
                   attribution = "Argenmap v2 - Instituto Geográfico Nacional")
  
  # agrega mapa a resultados
  resultados$LISA[["MAPA"]] = MAPA_LISA
  
  ##### LISA EN GGPLOT #####
  
  
  
  mapa$lisa[is.na(mapa$lisa)] = "No sig"
  
  # # con los niveles de tu factor 'lisa' definido arriba.
  # colores_lisa_manual <- c(
  #   "High-High" = "#FF0000",   # Rojo para Hot-Spots
  #   "Low-Low" = "#0000FF",   # Azul para Cold-Spots
  #   "High-Low" = "#a7adf9",   # Verde
  #   "Low-High" = "#f4ada8",   # Púrpura
  #   "No sig" = "#464646"    # Gris
  # )
  # 
  # 
  # # --- CÓDIGO GGPLOT2 PARA COLOREAR SEGÚN LISA ---
  # 
  # 
  # 
  # mapa_ggplot_lisa <- ggplot() +
  #   # 1. Capa de polígonos principales (departamentos/áreas de análisis)
  #   geom_sf(
  #     data = mapa, # Asegúrate de que este es tu sf object con la columna 'lisa'
  #     aes(fill = lisa),    # ¡Aquí se mapea el color de relleno a la variable 'lisa'!
  #     
  #     linewidth = 0,     # Grosor del borde del polígono de departamento
  #     alpha = 0.6          # Opacidad del relleno
  #   ) +
  #   # 2. Capa de polígonos secundarios (límites provinciales, sin relleno)
  #   geom_sf(
  #     data = mapaProv, # Asegúrate de que este es tu sf object para los límites provinciales
  #     fill = NA,           # Sin relleno para ver la capa de abajo
  #     color = "black",     # Color del borde de la provincia
  #     linewidth = 0.6        # Grosor del borde de la provincia
  #   ) +
  #   # 3. Definir la escala de color para el relleno.
  #   # Aquí especificamos los colores que corresponden a cada nivel de 'lisa'.
  #   scale_fill_manual(
  #     values = colores_lisa_manual, # Usa el vector de colores que definiste
  #     name = "Categoría LISA",      # Título de la leyenda
  #     na.value = "white",           # Color si hubiera valores NA en 'lisa'
  #     #drop = FALSE                  # Asegura que todos los niveles del factor aparezcan en la leyenda, incluso si no están en los datos
  #   ) +
  #   # 4. Mejoras estéticas y etiquetas
  #   theme_void() + # Elimina el fondo gris y los ejes para un mapa limpio
  #   theme(
  #     legend.position = "right", # Posiciona la leyenda abajo
  #     legend.title = element_text(face = "bold"),
  #     #plot.title = element_text(hjust = 0.5, face = "bold", size = 10), # Tamaño de letra reducido a 14
  #     # Ajuste para el subtítulo:
  #     #plot.subtitle = element_text(hjust = 0.5, size = 8, color = "darkgrey"), # Tamaño de letra 10 y color gris
  #     
  #   ) #+
  # # labs(
  # #   title = "Mapa de Categorías LISA de Mortalidad (Trienio 2021-2023)",
  # #   subtitle = paste0(substring(causa,6,6),
  # #                     str_to_lower(substring(causa,7,nchar(causa))))
  # # )
  # 
  # 
  # resultados$LISA[["MAPA_GGPLOT"]] = mapa_ggplot_lisa
  # 
  # 
  ##### MAPA DE LISA CLUSTERING BIVARIADO #####
  incProgress(0.25)
  
  # se excluye TDF del análisis por no tener vecinos
  mapa_lisa_bv = subset(mapa, in1 !="94000")
  sf::sf_use_s2(F)
  nb <- poly2nb(mapa_lisa_bv, queen = TRUE)
  sf::sf_use_s2(T)
  
  
  # calcula Moran local
  lisa_bivariado <- localmoran_bv(
    x = mapa_lisa_bv$PROP_NBI_MUJERES[mapa_lisa_bv$in1!="94000"],
    y = mapa_lisa_bv$RME[mapa_lisa_bv$in1!="94000"],
    listw = nb2listw(nb, style = "W", zero.policy = T),
    nsim = 10
  )
  
  # data frame con datos LISA
  lisa_bivariado = data.frame(attr(lisa_bivariado,"quadr"))
  mapa_lisa_bv$lisa = as.character(lisa_bivariado$median)
  mapa_lisa_bv$lisa[mapa_lisa_bv$p_valor <0.05] = "No sig"
  
  # crea paleta de colores
  paleta_colores <- colorFactor(
    palette = c("#e34a33","#fdbb84","#a6bddb","#2b8cbe","white"),
    domain = as.factor(mapa_lisa_bv$lisa)
  )
  # 
  # crea mapa
  
  
  MAPA_LISA_BV <- leaflet(mapa_lisa_bv %>% left_join(labelsDeptos)) %>%
    addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
             attribution = "Argenmap v2 - Instituto Geográfico Nacional") %>% # Añade el mapa base
    addPolygons(
      fillColor = ~paleta_colores(lisa), # Asigna color según la categoría en 'lisa'
      color = "black",                     # Color del borde de los polígonos
      weight = 0,                          # Grosor del borde
      opacity = 1,                         # Opacidad del borde
      fillOpacity = 0.8,                   # Opacidad del relleno
      label = ~paste0(
        "Área: ", mapa$NOMDPTO, ", ",
        "NBI: ", round(mapa$PROP_NBI_MUJERES*100,3), ", ",
        "RME: ", round(mapa$RME,3), ", ",
        
        "Categoría LISA bivariado: ", lisa) # Popup opcional al hacer clic
    ) %>%
    addLegend(
      position = "bottomleft",
      pal = paleta_colores,
      values = ~lisa,
      title = "Categoría LISA bivariado",
      opacity = 1
    ) %>% addTiles("https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png",
                   attribution = "Argenmap v2 - Instituto Geográfico Nacional")
  
  # agrega mapa a resultados
  resultados$LISA[["MAPA BIVARIADO"]] = MAPA_LISA_BV
  
  
  # agrega a resultados panel completo
  
    return(
      tagList(
        tags$div(
          # Usaremos un div contenedor que organiza el contenido verticalmente
          style = 'display: flex; flex-direction: column; gap: 20px;', # Añadimos un pequeño espacio entre filas
          
          # ----------------------------------------------------
          # 1. Primera Fila: Mapa RME y Mapa LISA (2 columnas)
          # ----------------------------------------------------
          tags$div(
            style = 'display: grid; grid-template-columns: 1fr 1fr; gap: 15px;',
            
            # Columna 1: Mapa RME
            tags$div(
              tags$h4("Mapa RME (Mortalidad)", style = "text-align: center;"),
              tags$hr(),
              resultados$RME
            ),
            
            # Columna 2: Mapa LISA Univariado
            tags$div(
              tags$h4("Mapa LISA Univariado", style = "text-align: center;"),
              tags$hr(),
              resultados$LISA$MAPA
            )
          ),
          
          # ----------------------------------------------------
          # 2. Segunda Fila: Mapa NBI y Mapa LISA Bivariado (2 columnas)
          # ----------------------------------------------------
          tags$div(
            style = 'display: grid; grid-template-columns: 1fr 1fr; gap: 15px;',
            
            # Columna 1: Mapa NBI
            tags$div(
              tags$h4("Mapa NBI (Necesidades Básicas Insatisfechas)", style = "text-align: center;"),
              tags$hr(),
              resultados$NBI
            ),
            
            # Columna 2: Mapa LISA Bivariado
            tags$div(
              tags$h4("Mapa LISA Bivariado", style = "text-align: center;"),
              tags$hr(),
              resultados$LISA[["MAPA BIVARIADO"]]
            )
          ),
          
          # ----------------------------------------------------
          # 3. Tercera Fila: Tabla, Gráfico RME vs. NBI y Spatial Correlation Plot (3 columnas)
          # ----------------------------------------------------
          tags$div(
            style = 'display: grid; grid-template-columns: 1fr 1fr ; gap: 15px;',
            
            # Columna 2: Gráfico RME vs. NBI (Scatter plot)
            tags$div(
              tags$h4("RME vs. NBI", style = "text-align: center;"),
              tags$hr(),
              resultados[["RME y NBI"]]
            ),
            
            # Columna 3: Spatial Correlation Plot (Moran Scatter Plot)
            tags$div(
              tags$h4("Spatial Correlation Plot", style = "text-align: center;"),
              tags$hr(),
              resultados$LISA$`SPATIAL CORRELATION PLOT`
            )
          )
        )
      )
    )
      
    
  
  
  
}

