(function() {

  $(document).ready(function() {
    var docs_controller;
    docs_controller = new DocsController({
      container: $("#docsContainer")
    });
    return docs_controller.loadConfig("data/cfmldoc.xml");
  });

}).call(this);
