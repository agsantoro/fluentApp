#Cociente de tasas
ratesRatio <- function(input, datosFiltrados) {
  calculocociente <- datosFiltrados[[input$indicadorGaps]][datosFiltrados$sexo == "2"] / datosFiltrados[[input$indicadorGaps]][datosFiltrados$sexo == "1"]
  
  return(calculocociente)
}
