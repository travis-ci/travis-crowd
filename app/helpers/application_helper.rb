module ApplicationHelper
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
      "#{content_tag(:span, 'per month', :class => :kind)} as a recurring payment".html_safe
    else
      "#{content_tag(:span, 'once', :class => :kind)}, as a one-off payment".html_safe
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
end
