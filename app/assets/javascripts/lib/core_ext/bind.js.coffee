if !Function.prototype.bind
  Function.prototype.bind = (binding) ->
    $.proxy(this, binding)
