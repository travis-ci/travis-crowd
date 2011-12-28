module Paths
  def path_to(name)
    case name
    when 'the home page'
      root_path
    end
  end
end

World(Paths)
