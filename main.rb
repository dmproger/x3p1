require 'byebug'
require_relative 'lib/x3p1'

puts 'set TREE or FIBER for results' unless ENV['TREE'] || ENV['FIBER']

if ENV['TREE']
  values = X3p1.tree(ENV['X']&.to_i || 1, count: ENV['COUNT']&.to_i || 1)

  output = values
  output = ENV['SORT'] ? output.sort : output
  output = (show = ENV['SHOW']&.to_i) ? output[0..show - 1] : output

  puts <<-STR
#{output}
-----
show: #{output.count}, min: #{output.min}, max: #{output.max}
-----
max value: #{values.max}
STR
end

if ENV['FIBER']
  values = X3p1.fiber(ENV['X']&.to_i || 1)

  output = values
  output = ENV['SORT'] ? output.sort : output
  output = (show = ENV['SHOW']&.to_i) ? output[0..show - 1] : output

  puts <<-STR
#{output}
-----
count: #{values.count}
-----
max value: #{values.max}
STR
end
