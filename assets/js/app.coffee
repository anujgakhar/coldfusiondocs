$(document).ready( ->
  docs_controller = new DocsController({
    container: $("#docsContainer")
  })
  docs_controller.loadConfig("data/toc.xml")
  
  $('#about').modal({
   keyboard: false
  })
)