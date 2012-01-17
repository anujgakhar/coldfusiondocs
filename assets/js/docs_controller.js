(function() {

  this.DocsController = (function() {

    function DocsController(params) {
      var spinnerElement,
        _this = this;
      if (params == null) params = {};
      this.container = params.container || $("#docsContainer");
      this.loadingPanel = params.loadingPanel || this.container.find("#loadingPanel");
      this.spinnerRadius = params.spinnerRadius || 10;
      this.docItems = params.docItems || this.container.find("#docItems");
      this.selectedItemDetails = params.selectedItemDetails || this.container.find("#selectedItemDetails");
      this.externalFrame = params.externalFrame || this.container.find('#externalFrame');
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
      this.acfBasePath = "http://assets.coldfusiondocs.com/html/cfml/";
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
      this.loadingPanel.append(this.spinner.el);
      this.sideBarContentArea.css('height', $(document).height() - 199);
      this.searchInput.bind('keyup mouseup change', (function() {
        if (_this.acfConfigLoaded) _this.filterResults();
        return false;
      }));
    }

    DocsController.prototype.filterResults = function() {
      this.parseXML(this.searchInput.val());
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
      var current, docUrl, href, index, listItem, obj, objName, _i, _len, _ref,
        _this = this;
      if (criteria == null) criteria = "";
      this.config_xml = $(this.acfConfigXML);
      this.objects = this.config_xml.find("object");
      this.docItems.find('li').remove();
      index = 0;
      _ref = this.objects;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        obj = _ref[_i];
        current = $(obj);
        objName = current.attr("name");
        docUrl = current.find("docURL").text();
        if (criteria === "" || objName.indexOf(criteria) !== -1) {
          listItem = $('<li/>');
          listItem.attr("data-index", index);
          listItem.attr("data-name", objName);
          listItem.attr("data-url", docUrl);
          href = $('<a/>');
          href.attr('class', 'docItem').attr('href', '#');
          href.bind('click', this.listItemClick);
          href.append(objName);
          listItem.append(href);
          this.docItems.append(listItem);
          index += 1;
        }
      }
      return this.docItems.find("a").click(function(event) {
        var clickedListItem, fileName, objectUrl;
        clickedListItem = $(event.target).parent();
        objectUrl = clickedListItem.attr("data-url").split("/");
        fileName = objectUrl[objectUrl.length - 1];
        return _this.externalFrame.attr("src", _this.acfBasePath + fileName);
      });
    };

    DocsController.prototype.removeSpinner = function() {
      this.container.removeClass(this.loadingClass);
      return $(this.spinner.el).remove();
    };

    return DocsController;

  })();

}).call(this);
