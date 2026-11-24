gemini_chat_v1 <- function(prompt,
                           history = list(),
                           model = "2.5-flash",
                           temperature = 1,
                           maxOutputTokens = 8192,
                           topK = 40,
                           topP = 0.95,
                           seed = 1234) {
  
  validate_params <- get("validate_params", asNamespace("gemini.R"))
  addHistory <- get("addHistory", asNamespace("gemini.R"))
  
  if (!validate_params(prompt, model, temperature, topP, topK,
                       seed, api_key = TRUE)) {
    return(NULL)
  }
  
  api_key <- Sys.getenv("GEMINI_API_KEY")
  
  history <- addHistory(history, role = "user", item = prompt)
  
  url <- paste0(
    "https://generativelanguage.googleapis.com/v1/models/",
    "gemini-", model,
    ":generateContent?key=",
    api_key
  )
  
  generation_config <- list(
    temperature = temperature,
    maxOutputTokens = maxOutputTokens,
    topP = topP,
    topK = topK
  )
  
  # Solo mandamos seed si el usuario lo define explícitamente
  if (!missing(seed) && is.integer(seed)) {
    generation_config$seed <- seed
  }
  
  request_body <- list(
    contents = history,
    generationConfig = generation_config
  )
  
  sb <- cli::cli_status("Gemini is answering...")
  
  tryCatch({
    req <- httr2::request(url) |>
      httr2::req_body_json(request_body)
    
    resp <- httr2::req_perform(req)
    
    cli::cli_status_clear(id = sb)
    
    if (resp$status_code != 200) {
      cli::cli_alert_danger(
        paste0("Error in generate request: Status code ", resp$status_code)
      )
      return(NULL)
    }
    
    candidates <- httr2::resp_body_json(resp)$candidates
    outputs <- unlist(lapply(candidates, function(x) x$content$parts))
    
    if (length(outputs) > 0) {
      history <- addHistory(history, role = "model", item = outputs[[1]])
    }
    
    list(
      outputs = outputs,
      history = history
    )
    
  }, error = function(e) {
    cli::cli_status_clear(id = sb)
    list(
      outputs = list(text = "**Límite de consultas sobrepasado**"),
      history = history
    )
  })
}