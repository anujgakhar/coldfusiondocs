(function() {

  this.DocsController = (function() {

    function DocsController(params) {
      var spinnerElement;
      if (params == null) params = {};
      this.container = params.container || $("#docsContainer");
      this.loadingPanel = params.loadingPanel || this.container.find("#loadingPanel");
      this.spinnerRadius = params.spinnerRadius || 10;
      this.loadingClass = params.loadingClass || "loading";
      this.errorClass = params.errorClass || "error";
      this.errorPanel = params.errorFlash || this.container.find("#errorPanel");
      this.errorMessage = params.errorMessage || this.container.find("#message");
      this.errorMessageOnXML = params.errorMessageOnXML || "Sorry! We cannot load the configuration XML.";
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
        error: function(jqXHR, textStatus, errorThrown) {
          _this.errorMessage.html(_this.errorMessageOnXML);
          _this.container.addClass(_this.errorClass);
          return _this.removeSpinner();
        },
        success: function(data) {
          _this.config_xml = $(data);
          _this.slides = _this.config_xml.find("slides > slide");
          return _this.posters = _this.config_xml.find("posters url");
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
