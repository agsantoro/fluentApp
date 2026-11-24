load("data/tablaCausas.RDA")

modalCauses = function (
    inputCausa,
    inputIndicador
) {
  
  if (inputIndicador %in% indicatorsList()[c(5,8)] & inputCausa %in% tablaCausas$causa[tablaCausas$tipo == "Prevenible"]) {
    texto = 'Este grupo de causas no contiene causas de mortalidad clasificadas como prevenibles'
  } else if (inputIndicador %in% indicatorsList()[c(6,9)] & inputCausa %in% tablaCausas$causa[tablaCausas$tipo == "Tratable"]) {
    texto = 'Este grupo de causas no contiene causas de mortalidad clasificadas como tratables'
  } else if (inputIndicador %in% indicatorsList()[c(4,7)] & inputCausa %in% tablaCausas$causa[tablaCausas$tipo == "Prematura"]) {
    texto = 'Este grupo de causas no contiene causas de mortalidad clasificadas como prematuras'
  } else {
    return()
  }
  
  texto
  
}