class Bukelatta::DSL::Converter
  include Bukelatta::Utils::Helper

  def self.convert(exported, options = {})
    self.new(exported, options).convert
  end

  def initialize(exported, options = {})
    @exported = exported
    @options = options
  end

  def convert
    output_buckets(@exported)
  end

  private

  def output_buckets(policy_by_bucket)
    buckets = []

    policy_by_bucket.sort_by(&:first).each do |bucket_name, policy|
      if not policy or not matched?(bucket_name)
        next
      end

      buckets << output_bucket(bucket_name, policy)
    end

    buckets.join("\n")
  end

  def output_bucket(bucket_name, policy)
    policy = policy.pretty_inspect.gsub(/^/, '  ').strip

    <<-EOS
bucket #{bucket_name.inspect} do
  #{policy}
end
    EOS
  end
end
