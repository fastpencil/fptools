module Html
end

current_path = File.dirname(__FILE__)
Dir[File.join(current_path,'html','*.rb')].each do |file|
  puts file
  require file
end


