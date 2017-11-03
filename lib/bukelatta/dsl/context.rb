class Bukelatta::DSL::Context
  include Bukelatta::DSL::TemplateHelper

  def self.eval(dsl, path, options = {})
    self.new(path, options) {
      eval(dsl, binding, path)
    }
  end

  def result
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

    @result[name] = Hashie.stringify_keys yield(name)
  end
end
