$(document).ready( ->
  docs_controller = new DocsController({
    container: $("#docsContainer")
  })
  
  docs_controller.loadConfig("data/cfmldoc.xml")
)