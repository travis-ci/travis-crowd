require 'rack'
require 'base64'

module ApplicationHelper
  def page_id
    %w(show index new).include?(params[:action]) ? params[:controller] : params[:action]
  end

  def current_user_editable(tag, name)
    content_tag(tag, :class => 'rest-in-place', :'data-attribute' => name) do
      value = current_user.send(name)
      value.present? ? value : '-'
    end
  end

  def cancel_subscription_button(order)
    button_to('Cancel', order, :method => :delete, :'data-disable-with' => 'Cancel', :confirm => 'Are you sure you want to cancel this subscription?')
  end

  def subscription_type(order)
    if order.subscription?
      "#{content_tag(:em, 'per month')} as a recurring payment".html_safe
    else
      "#{content_tag(:em, 'once')}, as a one-off payment".html_safe
    end
  end

  def stats_for(package, type)
    content_tag(:p, class: :stats) do
      if number = stats[package]
        "#{content_tag(:span, number)} #{type}#{number == 1 ? '' : 's'}".html_safe
      else
        "Be the first to #{type == :donor ? 'donate' : 'subscribe'}!"
      end
    end
  end

  def display_bio?(package)
    %w(big huge).include?(package.to_s)
  end

  def display_for(package)
    if company?
      "Display our logo and company pitch. Please submit these separately to contact@travis-ci.org so we can take care of a good design."
    else
      "List me on the Travis CI crowdfunding page."
    end
  end

  def encoded_image(filename)
    type = Rack::Mime.mime_type(File.extname(filename))
    data = Base64.encode64(File.read("public/images/#{filename}"))
    "data:#{type};base64,#{data}"
  end
end
