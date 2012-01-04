$LOAD_PATH.unshift("lib")

task 'write_init_d', [:out_to] do |task, args|
  require 'rubygems'
  require 'fptools'

  File.open(args[:out_to], 'w') do |out|
    Fptools::InitD.create(out, {})
  end
end
