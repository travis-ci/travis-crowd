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

var Donator = function(package, data) {
  this.package = package;
  this.data = data;
}
$.extend(Donator.prototype, {
  render: function() {
    var tag = $('<li></li>');
    if(this.isBoxed()) {
      tag.append($('<img src="' + this.data.gravatar_url + '">'));
      tag.append(this.heading());
      if(this.isDescription()) {
        tag.append($('<p>' + this.truncate(this.data.description) + '</p>'));
      }
      tag.append(this.links().join(', '))
    } else {
      tag.append(this.heading());
    }
    return tag;
  },
  heading: function() {
    return '<h4>' + this.links().shift() + '</h4>';
  },
  links: function() {
    if(this._links) return this._links;
    this._links = [];
    if(this.data.homepage) this._links.push('<a href="' + this.data.homepage + '">' + this.data.name + '</a>');
    if(this.data.twitter_handle) this._links.push('<a href="http://twitter.com/' + this.data.twitter_handle + '">@' + this.data.twitter_handle + '</a>');
    if(this.data.github_handle) this._links.push('<a href="http://github.com/' + this.data.github_handle + '">' + this.data.github_handle + '</a>');
    return this._links;
  },
  isBoxed: function() {
    return ['medium', 'big', 'huge'].indexOf(this.package) != -1;
  },
  isDescription: function() {
    return ['big', 'huge'].indexOf(this.package) != -1;
  },
  lengths: {
    big: 25,
    huge: 125
  },
  truncate: function(string) {
    var length = this.lengths[this.package];
    if(string.length > length) {
      return string.slice(0, length) + '&hellip;'
    } else {
      return string;
    }
  }
});

var Donators = function(package, donators) {
  this.package = package;
  this.donators = donators;
}
$.extend(Donators.prototype, {
  render: function() {
    var _this = this;
    var list = $('<ul></ul>');
    $.each(this.donators, function(ix, donator) {
      list.append(new Donator(_this.package, donator).render());
    });
    return list;
  },
});
$.fn.donators = function() {
  var _this = this;
  $.get('/donators.json', function(data) {
    $.each(data, function(package, donators) {
      var element = $('<li class="' + package + '"></li>');
      element.append(new Donators(package, donators).render());
      _this.prepend(element);
    });
  }, 'json');
};
