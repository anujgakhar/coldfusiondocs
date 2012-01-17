(function() {

  this.DocsController = (function() {

    function DocsController(params) {
      var _this = this;
      if (params == null) params = {};
      this.container = params.container || $("#docsContainer");
      this.loadingPanel = params.loadingPanel || this.container.find("#loadingPanel");
      this.spinnerRadius = params.spinnerRadius || 10;
      this.docItems = params.docItems || this.container.find("#docItems");
      this.selectedItemDetails = params.selectedItemDetails || this.container.find("#selectedItemDetails");
      this.externalFrameACF = params.externalFrameACF || this.container.find('#externalFrameACF');
      this.externalFrameRailo = params.externalFrameRailo || this.container.find('#externalFrameRailo');
      this.sideBarContentArea = params.sideBarContentArea || this.container.find('#sideBarMiddle');
      this.searchInput = params.searchInput || this.container.find('#searchInput');
      this.loadingClass = params.loadingClass || "loading";
      this.errorClass = params.errorClass || "error";
      this.errorPanel = params.errorFlash || this.container.find("#errorPanel");
      this.errorMessage = params.errorMessage || this.container.find("#message");
      this.errorMessageOnXML = params.errorMessageOnXML || "Sorry! We cannot load the configuration XML.";
      this.acfConfigLoaded = false;
      this.railoConfigLoaded = false;
      this.acfConfigXML = "";
      this.acfBasePath = "/data/cfml/docs/";
      this.railoBasePath = "http://assets.coldfusiondocs.com/html/railo/";
      this.fixHeight();
      this.showSpinner();
      this.searchInput.bind('keyup change', (function() {
        if (_this.acfConfigLoaded && _this.searchInput.val().length > 2) {
          _this.filterResults();
        }
        return false;
      }));
      $(window).resize(function() {
        return _this.fixHeight();
      });
    }

    DocsController.prototype.fixHeight = function() {
      return this.sideBarContentArea.css('height', $(document).height() - 200);
    };

    DocsController.prototype.showSpinner = function() {
      var spinnerElement;
      this.spinner = new Spinner({
        lines: 12,
        length: 7,
        width: 3,
        radius: this.spinnerRadius,
        color: '#000',
        speed: 1.1,
        trail: 60,
        shadow: true
      }).spin();
      spinnerElement = $(this.spinner.el);
      spinnerElement.attr("id", "spinner");
      spinnerElement.css("margin-top", "" + (-this.spinnerRadius * 4) + "px");
      spinnerElement.css("margin-left", "" + (-this.spinnerRadius) + "px");
      spinnerElement.css("position", "absolute");
      return this.loadingPanel.append(this.spinner.el);
    };

    DocsController.prototype.removeSpinner = function() {
      this.container.removeClass(this.loadingClass);
      return $(this.spinner.el).remove();
    };

    DocsController.prototype.filterResults = function() {
      this.parseXML(this.searchInput.val());
      this.searchImput.focus();
      return false;
    };

    DocsController.prototype.loadConfig = function(url, docset) {
      var _this = this;
      if (docset == null) docset = 'acf';
      this.container.addClass(this.loadingClass);
      this.url = url;
      $.ajax({
        url: url,
        dataType: "xml",
        timeout: 3000,
        cache: false,
        complete: function(jqXHR, textStatus) {
          return _this.removeSpinner();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          _this.errorMessage.html(_this.errorMessageOnXML);
          return _this.container.addClass(_this.errorClass);
        },
        success: function(data) {
          _this.acfConfigLoaded = true;
          _this.acfConfigXML = data;
          return _this.parseXML();
        }
      });
      return false;
    };

    DocsController.prototype.parseXML = function(criteria) {
      var current, href, index, listItem, topic, topicLabel, topicUrl, _i, _len, _ref,
        _this = this;
      if (criteria == null) criteria = "";
      this.config_xml = $(this.acfConfigXML);
      this.topics = this.config_xml.find("topic");
      this.docItems.find('li').remove();
      this.docItems.find("a").unbind('click');
      index = 0;
      _ref = this.topics;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        topic = _ref[_i];
        current = $(topic);
        topicLabel = current.attr("label");
        topicUrl = current.attr("href");
        if (criteria === "" || topicLabel.indexOf(criteria) !== -1) {
          listItem = $('<li/>');
          listItem.attr("data-index", index);
          listItem.attr("data-name", topicLabel);
          listItem.attr("data-url", topicUrl);
          href = $('<a/>');
          href.attr('class', 'docItem').attr('href', '#');
          href.append(topicLabel);
          listItem.append(href);
          this.docItems.append(listItem);
          index += 1;
        }
      }
      this.docItems.find("a").click(function(event) {
        return _this.handleItemClick($(event.target).parent());
      });
      if (criteria === "") {
        return this.handleItemClick(this.docItems.find('li:first'));
      }
    };

    DocsController.prototype.handleItemClick = function(obj) {
      var clickedListItem, fileName, objectLabel, objectUrl;
      if (obj == null) obj = null;
      this.showSpinner();
      this.docItems.find('li').removeClass("selected");
      clickedListItem = $(obj);
      objectUrl = clickedListItem.attr("data-url").split("/");
      objectLabel = clickedListItem.attr("data-name");
      fileName = objectUrl[objectUrl.length - 1];
      this.externalFrameACF.attr("src", this.acfBasePath + fileName);
      this.externalFrameRailo.attr("src", this.railoBasePath + 'tag_' + objectLabel + '.html');
      clickedListItem.addClass("selected");
      return this.removeSpinner();
    };

    return DocsController;

  })();

}).call(this);
