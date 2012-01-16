class @DocsController
	
  constructor: (params={}) ->
	# Containing Element.
    @container                = params.container           || $("#docsContainer")

    # Loading GUI         
    @loadingPanel             = params.loadingPanel        || @container.find("#loadingPanel")
    @spinnerRadius            = params.spinnerRadius       || 10

	# Item Container
    @docItems                 = params.docItems            || @container.find("#docItems")

    # Configurable CSS Classes
    @loadingClass             = params.loadingClass        || "loading"
    @errorClass               = params.errorClass          || "error"

    # Errors
    @errorPanel               = params.errorFlash          || @container.find("#errorPanel")
    @errorMessage             = params.errorMessage        || @container.find("#message")
    @errorMessageOnXML        = params.errorMessageOnXML   || "Sorry! We cannot load the configuration XML."

    #Non-configurable attributes
    @acfConfigLoaded          = false
    @railoConfigLoaded        = false

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
        timeout: 3000
        cache: false
        complete: (jqXHR, textStatus) =>
           @removeSpinner()
        error: (jqXHR, textStatus, errorThrown) =>
           @errorMessage.html(@errorMessageOnXML)
           @container.addClass(@errorClass)
        success: (data) =>
           @config_xml      = $(data)
           @categories      = @config_xml.find("categories > category")
           @acfConfigLoaded = true
           
           @docItems.find('li').remove()

           index = 0 
           for category in @categories
             current          = $(category)
             categoryName     = current.find("name").text()
             listItem         = $('<li/>')
             listItem.attr("data-index", index)
             listItem.attr("data-name", categoryName)
             listItem.append($('<a>').attr('href','#').attr('class','docItem')).append(categoryName)
             @docItems.append(listItem)
             index += 1
    })
    false

  removeSpinner: ->
    @container.removeClass(@loadingClass)
    $(@spinner.el).remove()