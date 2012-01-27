$->
  docs_controller = new DocsController({
    container: $("#docsContainer")
  })
  docs_controller.loadConfig("data/toc.xml")