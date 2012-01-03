if(!Function.prototype.bind) {
  Function.prototype.bind = function(binding) {
    return $.proxy(this, binding);
  };
}

var Slides = function(element, options) {
  this.options = options || {};
  this.slides = element.children();
  this.current = $(this.slides[0]).addClass('current');
  this.pagination = new Pagination(element);
};
$.extend(Slides.prototype, {
  run: function() {
    setTimeout(function() {
      this.next();
      this.run();
    }.bind(this), this.options.speed || 5000);
  },
  next: function() {
    this.slides.removeClass('current');
    var next = $(this.current).next('li');
    if(next.length == 0) next =  $(this.slides[0]);
    next.fadeIn(this.options.fade);
    this.current.fadeOut(this.options.fade);
    this.current = next;
    this.pagination.next();
  }
});

var Pagination = function(slides) {
  var element = $('<ul class="slides-pagination"></ul>');
  slides.children().each(function() { element.append('<li></li>') }.bind(this));
  this.dots = element.children();
  this.current = $(this.dots[0]).addClass('current');
  slides.after(element);
};
$.extend(Pagination.prototype, {
  next: function() {
    this.dots.removeClass('current');
    this.current = $(this.current).next('li');
    if(this.current.length == 0) this.current =  $(this.dots[0]);
    this.current.addClass('current');
  }
});

$.fn.slides = function(options) {
  new Slides(this, options).run();
};

var Testimonials = function(element) {
  this.element = element;
  $.get('/testimonials.json', this.render.bind(this));
}
$.extend(Testimonials.prototype, {
  render: function(records) {
    var _this = this; // fuck you, jquery
    $.each(records, function() {
      var element = $(
        '<li>' +
        '  <img src="' + this.image + '">' +
        '  <div>' +
        '    <blockquote>' +
        '      ' + this.quote + '' +
        '    </blockquote>' +
        '    <cite>' +
        '      <a href="' + this.url + '">' + this.name + '</a>,' +
        '      <a href="http://twitter.com/#!/' + this.twitter + '">@' + this.twitter + '</a>' +
        '    </cite>' +
        '  </div>' +
        '</li>'
      );
      _this.element.append(element);
    });
  }
});

$.fn.testimonials = function() {
  new Testimonials(this);
};


