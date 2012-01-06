module ApplicationHelper
  def link_to_current_user_on(service)
    if handle = current_user.send(:"#{service}_handle")
      case service
      when :twitter
        link_to(handle, "http://twitter.com/#{handle}")
      when :github
        link_to(handle, "http://github.com/#{handle}")
      end
    else
      '-'
    end
  end

  def link_to_current_user_homepage
    if url = current_user.homepage
      link_to(url, url)
    else
      '-'
    end
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
