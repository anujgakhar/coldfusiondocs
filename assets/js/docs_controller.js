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
      this.externalFrame = params.externalFrame || this.container.find('#externalFrame');
      this.sideBarContentArea = params.sideBarContentArea || this.container.find('#sideBarMiddle');
      this.searchInput = params.searchInput || this.container.find('#searchInput');
      this.versionFilter = params.versionFilter || this.container.find("input:checkbox[name='versionFilter']");
      this.loadingClass = params.loadingClass || "loading";
      this.errorClass = params.errorClass || "error";
      this.errorPanel = params.errorFlash || this.container.find("#errorPanel");
      this.errorMessage = params.errorMessage || this.container.find("#message");
      this.errorMessageOnXML = params.errorMessageOnXML || "Sorry! We cannot load the configuration XML.";
      this.configLoaded = false;
      this.configXML = "";
      this.docsBasePath = "http://assets.coldfusiondocs.com/html/cf9/";
      this.selectedVersionFilter = [];
      this.fixHeight();
      this.showSpinner();
      this.searchInput.bind('keyup change', (function() {
        if (_this.configLoaded && (_this.searchInput.val().length > 2 || _this.searchInput.val().length === 0)) {
          _this.filterResults();
        }
        return false;
      }));
      this.versionFilter.bind('change', (function() {
        _this.selectedVersionFilter = [];
        _this.versionFilter.each(function(index, element) {
          var elem, isChecked;
          elem = $(element);
          isChecked = elem.prop('checked') ? true : false;
          return _this.saveVersionFilterState(elem.val(), isChecked);
        });
        return _this.filterResults();
      }));
      $(window).resize(function() {
        return _this.fixHeight();
      });
    }

    DocsController.prototype.saveVersionFilterState = function(version, isChecked) {
      if (isChecked) return this.selectedVersionFilter.push(version);
    };

    DocsController.prototype.fixHeight = function() {
      return this.sideBarContentArea.css('height', $(document).height() - 225);
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
      var vFilter, _i, _len, _ref;
      this.docItems.find("li").hide();
      this.filters = [];
      this.searchCriteria = "li[data-label*=" + this.searchInput.val() + "]";
      _ref = this.selectedVersionFilter;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vFilter = _ref[_i];
        this.searchString = this.searchCriteria;
        this.searchString = this.searchString.concat("[data-addedin=" + vFilter + "]");
        this.filters.push(this.searchString);
      }
      if (this.selectedVersionFilter.length === 0) {
        this.filters.push(this.searchCriteria);
      }
      this.docItems.find(this.filters.join(",")).show();
      return false;
    };

    DocsController.prototype.loadConfig = function(url) {
      var _this = this;
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
          _this.externalFrame.attr("src", "");
          _this.errorMessage.html(_this.errorMessageOnXML);
          return _this.container.addClass(_this.errorClass);
        },
        success: function(data) {
          _this.configLoaded = true;
          _this.configXML = data;
          return _this.parseXML();
        }
      });
      return false;
    };

    DocsController.prototype.parseXML = function(criteria) {
      var current, href, index, listItem, topic, topicAddedIn, topicLabel, topicUrl, _i, _len, _ref,
        _this = this;
      if (criteria == null) criteria = "";
      this.config_xml = $(this.configXML);
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
        topicAddedIn = current.attr("addedin") || "0";
        if (criteria === "" || topicLabel.indexOf(criteria) !== -1) {
          listItem = $('<li/>');
          listItem.attr("data-index", index);
          listItem.attr("data-label", topicLabel);
          listItem.attr("data-url", topicUrl);
          listItem.attr("data-addedin", topicAddedIn);
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
      if (criteria === "" && this.docItems.find("li:first")) {
        return this.handleItemClick(this.docItems.find('li:first'));
      }
    };

    DocsController.prototype.handleItemClick = function(obj) {
      var clickedListItem, fileName, topicUrl;
      if (obj == null) obj = null;
      this.showSpinner();
      this.docItems.find('li').removeClass("active");
      clickedListItem = $(obj);
      topicUrl = clickedListItem.attr("data-url").split("/");
      fileName = topicUrl[topicUrl.length - 1];
      this.externalFrame.attr("src", this.docsBasePath + fileName);
      clickedListItem.addClass("active");
      return this.removeSpinner();
    };

    return DocsController;

  })();

}).call(this);
