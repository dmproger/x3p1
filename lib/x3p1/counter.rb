module X3p1
  module Counter
    Stop = Class.new Exception

    module_function

    def apply(object, on:, count:)
      object.singleton_class.include Module.new {
        attr_accessor :counter, :counter_max

        define_method(on) do |*params, **options|
          raise Stop if counter >= counter_max
          self.counter += 1
          super(*params, **options)
        end
      }
      object.counter = 0
      object.counter_max = count
      object
    end
  end
end
