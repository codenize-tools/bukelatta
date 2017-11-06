class Bukelatta::DSL::Context
  include Bukelatta::DSL::TemplateHelper

  def self.eval(dsl, path, options = {})
    self.new(path, options) {
      eval(dsl, binding, path)
    }
  end

  def result
    expand_leaf_array!
    @result.sort_array!
  end

  def initialize(path, options = {}, &block)
    @path = path
    @options = options
    @result = {}

    @context = Hashie::Mash.new(
      :path => path,
      :options => options,
      :templates => {}
    )

    instance_eval(&block)
  end

  def template(name, &block)
    @context.templates[name.to_s] = block
  end

  private

  def require(file)
    policyfile = (file =~ %r|\A/|) ? file : File.expand_path(File.join(File.dirname(@path), file))

    if File.exist?(policyfile)
      instance_eval(File.read(policyfile), policyfile)
    elsif File.exist?(policyfile + '.rb')
      instance_eval(File.read(policyfile + '.rb'), policyfile + '.rb')
    else
      Kernel.require(file)
    end
  end

  def bucket(name)
    name = name.to_s

    if @result[name]
      raise "Bucket `#{name}` is already defined"
    end

    @result[name] = yield
  end

  def expand_leaf_array!
    @result = expand_leaf_array(@result)
  end

  def expand_leaf_array(obj)
    case obj
    when Array
      if obj[0].instance_of?(Array) || obj[0].instance_of?(Hash)
        return obj.map do |o|
          expand_leaf_array(o)
        end
      end
      # Leaf
      if obj.length == 1
        return obj[0]
      end
      return obj
    when Hash
      h = {}
      obj.each do |k, v|
        h[k] = expand_leaf_array(v)
      end
      return h
    end
    return obj
  end
end
