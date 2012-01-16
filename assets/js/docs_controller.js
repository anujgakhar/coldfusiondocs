(function() {

  this.DocsController = (function() {

    function DocsController(params) {
      var spinnerElement;
      if (params == null) params = {};
      this.container = params.container || $("#docsContainer");
      this.loadingPanel = params.loadingPanel || this.container.find("#loadingPanel");
      this.spinnerRadius = params.spinnerRadius || 10;
      this.docItems = params.docItems || this.container.find("#docItems");
      this.loadingClass = params.loadingClass || "loading";
      this.errorClass = params.errorClass || "error";
      this.errorPanel = params.errorFlash || this.container.find("#errorPanel");
      this.errorMessage = params.errorMessage || this.container.find("#message");
      this.errorMessageOnXML = params.errorMessageOnXML || "Sorry! We cannot load the configuration XML.";
      this.acfConfigLoaded = false;
      this.railoConfigLoaded = false;
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
    }

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
          var category, categoryName, current, index, listItem, _i, _len, _ref, _results;
          _this.config_xml = $(data);
          _this.categories = _this.config_xml.find("categories > category");
          _this.acfConfigLoaded = true;
          _this.docItems.find('li').remove();
          index = 0;
          _ref = _this.categories;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            category = _ref[_i];
            current = $(category);
            categoryName = current.attr("name");
            listItem = $('<li/>');
            listItem.attr("data-index", index);
            listItem.attr("data-name", categoryName);
            listItem.append($('<a>').attr('href', '#').attr('class', 'docItem')).append(categoryName);
            _this.docItems.append(listItem);
            _results.push(index += 1);
          }
          return _results;
        }
      });
      return false;
    };

    DocsController.prototype.removeSpinner = function() {
      this.container.removeClass(this.loadingClass);
      return $(this.spinner.el).remove();
    };

    return DocsController;

  })();

}).call(this);
