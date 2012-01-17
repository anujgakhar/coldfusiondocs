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
    @externalFrameACF         = params.externalFrameACF    || @container.find('#externalFrameACF')
    @externalFrameRailo       = params.externalFrameRailo  || @container.find('#externalFrameRailo')
    @sideBarContentArea       = params.sideBarContentArea  || @container.find('#sideBarMiddle')
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
    @acfBasePath              = "/data/cfml/docs/"
    @railoBasePath            = "http://assets.coldfusiondocs.com/html/railo/"

    @fixHeight()
    @showSpinner()

    @searchInput.bind 'keyup change', ( =>
      @filterResults() if @acfConfigLoaded && @searchInput.val().length > 2
      false
    )

    $(window).resize( =>
      @fixHeight()
    )

  fixHeight: ->
    @sideBarContentArea.css('height', $(document).height() - 200)

  showSpinner: ->
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

  removeSpinner: ->
    @container.removeClass(@loadingClass)
    $(@spinner.el).remove()

  filterResults: ->
    @parseXML(@searchInput.val())
    @searchImput.focus()
    false     

# Loads XML data for a supplied URL.
  loadConfig: (url, docset = 'acf') ->
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
    @topics       = @config_xml.find("topic")

    @docItems.find('li').remove()
    @docItems.find("a").unbind('click')

    index = 0 
    for topic in @topics
      current          = $(topic)
      topicLabel       = current.attr("label")
      topicUrl         = current.attr("href")
      if criteria == "" || topicLabel.indexOf(criteria) != -1
        listItem         = $('<li/>')
        listItem.attr("data-index", index)
        listItem.attr("data-name", topicLabel)
        listItem.attr("data-url", topicUrl)
        href             = $('<a/>')
        href.attr('class', 'docItem').attr('href','#')
        href.append(topicLabel) 
        listItem.append(href)
        @docItems.append(listItem)
        index += 1

    @docItems.find("a").click( (event) =>
      @handleItemClick($(event.target).parent())
    )

    #force select first item
    @handleItemClick(@docItems.find('li:first')) if criteria == ""

  handleItemClick: (obj = null) ->
    @showSpinner()
    @docItems.find('li').removeClass("selected")
    clickedListItem = $(obj)
    objectUrl = clickedListItem.attr("data-url").split("/")
    objectLabel = clickedListItem.attr("data-name") 
    fileName = objectUrl[objectUrl.length - 1]
    @externalFrameACF.attr("src", @acfBasePath + fileName)
    @externalFrameRailo.attr("src", @railoBasePath + 'tag_' + objectLabel + '.html')
    clickedListItem.addClass("selected")
    @removeSpinner()