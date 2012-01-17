worker_processes 4
timeout 5

preload_app true
before_fork { |_,_| ActiveRecord::Base.connection.disconnect! }
after_fork { |_,_| ActiveRecord::Base.establish_connection }
