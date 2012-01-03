expansions = {
  jquery: %w(
    http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js
    https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js
  ),
  stripe: %w(
    
  )
}

expansions.each do |name, scripts|
  ActionView::Helpers::AssetTagHelper::register_javascript_expansion :name => scripts
end

