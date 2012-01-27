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
    @sideBarContentArea       = params.sideBarContentArea  || @container.find('#sideBarMiddle')
    @searchInput              = params.searchInput         || @container.find('#searchInput')
    @versionFilter            = params.versionFilter       || @container.find("input:checkbox[name='versionFilter']")

    # Configurable CSS Classes
    @loadingClass             = params.loadingClass        || "loading"
    @errorClass               = params.errorClass          || "error"

    # Errors
    @errorPanel               = params.errorFlash          || @container.find("#errorPanel")
    @errorMessage             = params.errorMessage        || @container.find("#message")
    @errorMessageOnXML        = params.errorMessageOnXML   || "Sorry! We cannot load the configuration XML."

    #Non-configurable attributes
    @configLoaded             = false
    @configXML                = ""
    @docsBasePath             = "http://assets.coldfusiondocs.com/html/cf9/"
    @selectedVersionFilter    = []

    @fixHeight()
    @showSpinner()

    @searchInput.bind 'keyup change', ( =>
      if @configLoaded && (@searchInput.val().length > 2 || @searchInput.val().length == 0)
        @filterResults() 
      false
    )

    @versionFilter.bind 'change', ( =>
      @selectedVersionFilter = []
      @versionFilter.each (index, element) =>
        elem = $(element)
        isChecked = if elem.prop('checked') then true else false
        @saveVersionFilterState(elem.val(), isChecked) 
      @filterResults()
    )
    
    $(window).resize( =>
      @fixHeight()
    )

  saveVersionFilterState: (version, isChecked) ->
    if isChecked  
      @selectedVersionFilter.push version

  fixHeight: ->
    @sideBarContentArea.css('height', $(document).height() - 225)

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
    @criteria = @searchInput.val()
    @docItems.find("li").hide()
    @docItems.find("li[data-label*=" + @criteria + "][data-addedin*=" + @selectedVersionFilter.toString() + "]").show()
    @searchInput.focus()
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
           @externalFrame.attr("src", "")
           @errorMessage.html(@errorMessageOnXML)
           @container.addClass(@errorClass)
        success: (data) =>
           @configLoaded = true
           @configXML    = data
           @parseXML()
    })
    false

  parseXML: (criteria = "") ->
    @config_xml   = $(@configXML)
    @topics       = @config_xml.find("topic")

    @docItems.find('li').remove()
    @docItems.find("a").unbind('click')

    index = 0 
    for topic in @topics
      current          = $(topic)
      topicLabel       = current.attr("label")
      topicUrl         = current.attr("href")
      topicAddedIn     = current.attr("addedin") || "0"
      if criteria == "" || topicLabel.indexOf(criteria) != -1
        listItem         = $('<li/>')
        listItem.attr("data-index", index)
        listItem.attr("data-label", topicLabel)
        listItem.attr("data-url", topicUrl)
        listItem.attr("data-addedin", topicAddedIn)
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
    if criteria == "" && @docItems.find("li:first")
      @handleItemClick(@docItems.find('li:first')) 

  handleItemClick: (obj = null) ->
    @showSpinner()
    @docItems.find('li').removeClass("active")
    clickedListItem = $(obj)
    objectUrl = clickedListItem.attr("data-url").split("/")
    objectLabel = clickedListItem.attr("data-name") 
    fileName = objectUrl[objectUrl.length - 1]
    @externalFrame.attr("src", @docsBasePath + fileName)
    clickedListItem.addClass("active")
    @removeSpinner()