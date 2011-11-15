module Epub
end

current_path = File.dirname(__FILE__)
Dir[File.join(current_path,'epub','*.rb')].each do |file|
  puts file
  require file
end

