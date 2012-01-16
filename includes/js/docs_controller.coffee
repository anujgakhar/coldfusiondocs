class @DocsController
	
  constructor: (params={}) ->
	# Containing Element.
    @container                = params.container           || $("#docsContainer")

    # Loading GUI         
    @loadingPanel             = params.loadingPanel        || @container.find("#loadingPanel")
    @spinnerRadius            = params.spinnerRadius       || 10

    # Configurable CSS Classes
    @loadingClass             = params.loadingClass        || "loading"
    @errorClass               = params.errorClass          || "error"

    # Errors
    @errorPanel               = params.errorFlash          || @container.find("#errorPanel")
    @errorMessage             = params.errorMessage        || @container.find("#message")
    @errorMessageOnXML        = params.errorMessageOnXML   || "Sorry! We cannot load the configuration XML."

    # Configure and position spinner.
    @spinner = new Spinner(
      lines:      12              # The number of lines to draw
      length:     7               # The length of each line
      width:      3               # The line thickness
      radius:     @spinnerRadius  # The radius of the inner circle
      color:      '#000'          # #rgb or #rrggbb
      speed:      1.1             # Rounds per second
      trail:      60              # Afterglow percentage
      shadow:     true            # Whether to render a shadow
    ).spin()
    spinnerElement = $(@spinner.el)
    spinnerElement.attr("id","spinner")
    spinnerElement.css("margin-top", "#{-@spinnerRadius*4}px")
    spinnerElement.css("margin-left", "#{-@spinnerRadius}px")
    spinnerElement.css("position", "absolute")
    @loadingPanel.append(@spinner.el)

  # Loads XML data for a supplied URL.
  loadConfig: (url) ->
    @container.addClass(@loadingClass)
    @url = url
    $.ajax({
        url: url
        dataType: "xml"
        error: (jqXHR, textStatus, errorThrown) =>
           @errorMessage.html(@errorMessageOnXML)
           @container.addClass(@errorClass)
           @removeSpinner()
        success: (data) =>
           @config_xml             = $(data)
           @slides                 = @config_xml.find("slides > slide")
           @posters                = @config_xml.find("posters url")
    })
    false

  removeSpinner: ->
    @container.removeClass(@loadingClass)
    $(@spinner.el).remove()