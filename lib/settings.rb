require 'hashr'
require 'yaml'

class Settings < Hashr
  extend Hashr::EnvDefaults

  self.env_namespace = 'travis'

  define :stripe => { secret_key: '', public_key: '' }

  def load(filename, env = nil)
    settings = File.exists?(filename) ? YAML.load(File.read(filename)) : {}
    settings = settings[env.to_s] || {} if env
    settings.each { |key, value| self[key] = value }
    self
  end

  def export_env!
    export_env.each { |key, value| ENV[key] = value }
  end

  def export_env
    collector = lambda do |hash, stack|
      hash.map do |key, value|
        stack.push(key.to_s.upcase)
        result = value.is_a?(Hash) ? collector.call(value, stack) : [stack.join('_'), value]
        result.tap { stack.pop }
      end
    end
    Hash[*collector.call(self, [self.class.env_namespace].compact).flatten]
  end
end
