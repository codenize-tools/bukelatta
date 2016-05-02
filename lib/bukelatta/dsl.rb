class Bukelatta::DSL
  class << self
    def convert(exported, options = {})
      Bukelatta::DSL::Converter.convert(exported, options)
    end

    def parse(dsl, path, options = {})
      Bukelatta::DSL::Context.eval(dsl, path, options).result
    end
  end # of class methods
end
