require_relative 'x3p1/fiber'
require_relative 'x3p1/tree'

module X3p1
  module_function

  def fiber(x = 1)
    Fiber.new.call(x)
  end

  def tree(x = 1, count: 1)
    Tree.new.call(x, count)
  end
end
