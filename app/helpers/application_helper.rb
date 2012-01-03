module ApplicationHelper
  def link_to_current_user_on(service)
    if handle = current_user.send(:"#{service}_handle")
      case service
      when :twitter
        link_to("@#{handle}", "http://twitter.com/#{handle}")
      when :github
        link_to("http://github.com/#{handle}", "http://github.com/#{handle}")
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

  def display_bio?(package)
    %w(big huge).include?(package.to_s)
  end

  def company?(package)
    %(silver gold platin).include?(package.to_s)
  end

  def display_for(package)
    if company?(package)
      "Display our logo and comany pitch. Please submit these separately to contact@travis-ci.org."
    else
      displays = {
        tiny:   'my Name and homepage, Twitter or Github handle',
        small:  'my Name and homepage, Twitter or Github handle',
        medium: 'my Gravatar, my Name and homepage, Twitter or Github handle',
        big:    'my Gravatar, my Name and homepage, Twitter and Github handle, and the first ~25 characters of my bio',
        huge:   'my Gravatar, my Name and homepage, Twitter and Github handle, and the first ~125 characters of my bio',
      }
      "Display #{displays[package.to_sym]} (#{package} package)."
    end
  end
end
