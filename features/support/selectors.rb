module Selectors
  def selector_for(element)
    case element
    when 'the packages list'
      '#packages'
    when 'the subscriptions list'
      '#subscriptions'
    end
  end
end

World(Selectors)
