infoBox = function (title, text, iconType, iconColor, linkTo, outputName, juriSel, trafficLightState = NULL) {
  tags$a(
    div(
      class = "grid-item",
      style = "background: rgba(170, 202, 228, 0.3);
               padding: 10px; 
               border-radius: 10px;
               backdrop-filter: blur(10px);
               transition: transform 0.3s ease, box-shadow 0.3s ease;
               cursor: pointer;
               display: flex;
               flex-direction: row;
               height: 100%; 
               max-height: 35vh;
               gap: 10px;",
      
      # Columna del semáforo (si se proporciona el estado)
      if (!is.null(trafficLightState)) {
        div(
          style = "display: flex;
                   align-items: flex-start;
                   justify-content: center;
                   min-width: 45px;
                   padding-top: 5px;",
          trafficLight(trafficLightState)
        )
      },
      
      # Columna principal con contenido
      div(
        style = "flex-grow: 1; 
                 display: flex; 
                 flex-direction: column; 
                 min-width: 0;",
        
        # Contenedor del título
        div(
          h4(title, style = "margin: 0;")
        ),
        
        # Contenedor del texto y el gráfico
        div(
          style = "text-align: left; 
                   font-size: 0.9em; 
                   line-height: 1.2; 
                   padding-top: 1vh; 
                   flex-grow: 1; 
                   display: flex; 
                   flex-direction: column;
                   justify-content: flex-start; 
                   align-items: stretch;
                   min-height: 0;",
          
          # Texto
          div(HTML(glue('<style>
  .color-box {
    display: inline-block; 
    width: 1em; 
    height: 1em; 
    margin-right: 5px; 
    vertical-align: middle; 
  }
</style>
<div>
  <span style="margin-right: 20px;">
    Total país
    <span class="color-box" style="background-color: #bdbdbd;"></span>
  </span>
  <br>
  <span style="margin-right: 20px;">
    $juriSel$
    <span class="color-box" style="background-color: #264671;"></span>
  </span>
  <br>
  <span>
    Otras jurisdicciones
    <span class="color-box" style="background-color: #ee7f00;"></span>
  </span>
</div>', .open ="$", .close = "$")), style = "margin: 0; padding-bottom: 2px;"),
          
          highchartOutput(outputName)
        )
      )
    )
  )
}