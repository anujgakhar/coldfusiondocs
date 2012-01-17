class @DocsController
	
  constructor: (params={}) ->
	# Containing Element.
    @container                = params.container           || $("#docsContainer")

    # Loading GUI         
    @loadingPanel             = params.loadingPanel        || @container.find("#loadingPanel")
    @spinnerRadius            = params.spinnerRadius       || 10

	# Content Container
    @docItems                 = params.docItems            || @container.find("#docItems")
    @selectedItemDetails      = params.selectedItemDetails || @container.find("#selectedItemDetails")
    @externalFrame            = params.externalFrame       || @container.find('#externalFrame')
    @docItemsContainer        = params.docItemsContainer   || @container.find('#docItemsContainer')
    @searchInput              = params.searchInput         || @container.find('#searchInput')

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
    @acfConfigXML             = ""
    @acfBasePath              = "http://assets.coldfusiondocs.com/html/cfml/"

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
    @docItemsContainer.css('height', screen.height - 100)
    @selectedItemDetails.css('height', screen.height - 100)

    @searchInput.bind 'keyup mouseup change', ( =>
      @filterResults() if @acfConfigLoaded
      false
    )

  filterResults: ->
    @parseXML(@searchInput.val())
    false     

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
           @acfConfigLoaded = true
           @acfConfigXML = data
           @parseXML()
    })
    false

  parseXML: (criteria = "") ->
    @config_xml   = $(@acfConfigXML)
    @objects      = @config_xml.find("object")
    console.log criteria
    @docItems.find('li').remove()
    index = 0 
    for obj in @objects
      current          = $(obj)
      objName     = current.attr("name")
      docUrl           = current.find("docURL").text()
      if criteria == "" || objName.indexOf(criteria) != -1
        listItem         = $('<li/>')
        listItem.attr("data-index", index)
        listItem.attr("data-name", objName)
        listItem.attr("data-url", docUrl)
        href             = $('<a/>')
        href.attr('class', 'docItem').attr('href','#')
        href.bind 'click', @listItemClick
        href.append(objName) 
        listItem.append(href)
        @docItems.append(listItem)
        index += 1

    @docItems.find("a").click( (event) =>
      clickedListItem = $(event.target).parent()
      objectUrl = clickedListItem.attr("data-url").split("/") 
      fileName = objectUrl[objectUrl.length - 1]
      @externalFrame.attr("src", @acfBasePath + fileName)
    )
	
  removeSpinner: ->
    @container.removeClass(@loadingClass)
    $(@spinner.el).remove()  
