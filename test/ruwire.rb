#!/usr/bin/ruby

require 'jackaudio'

j = Jackaudio::BlockingAudioIO.new("jackruby",2,2)
j.start
ports  = j.getAllPortNames
ports.each do {|p| puts p}
