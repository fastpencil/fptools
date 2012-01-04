#!/usr/bin/env ruby -w

require 'drb'

DRb.start_service
service = DRbObject.new nil, 'druby://localhost:2250'
puts service.service_info

