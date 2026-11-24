chat = function(input,session) {
  tagList(
    div(id = "iaDiv",
        withSpinner(uiOutput("chatBox0")), # output para visualizar la presentación del chat
        div(id = "chatBox"), # contenedor vacío para mostrar las consultas y respuestas del chat
        hidden(actionButton("send", "Enviar mensaje")), # botón para enviar mensajes,
        uiOutput("showTextBox"), # output para visualizar la presentación del chat
    )
  )
  
}