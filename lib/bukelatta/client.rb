class Bukelatta::Client
  include Bukelatta::Utils::Helper
  include Bukelatta::Logger::Helper

  def initialize(options = {})
    @options = options
    @client = @options[:client] || Aws::S3::Client.new
    @resource = Aws::S3::Resource.new(client: @client)
    @driver = Bukelatta::Driver.new(@client, @options)
  end

  def export
    Bukelatta::Exporter.export(@client, @options)
  end

  def apply(file)
    walk(file)
  end

  private

  def walk(file)
    expected = load_file(file)
    actual = Bukelatta::Exporter.export(@client, @options)

    updated = walk_buckets(expected, actual)

    if @options[:dry_run]
      false
    else
      updated
    end
  end

  def walk_buckets(expected, actual)
    updated = false

    expected.each do |bucket_name,  expected_policy|
      next unless matched?(bucket_name)

      actual_policy = actual[bucket_name]

      if actual_policy
        updated = walk_policy(bucket_name, expected_policy, actual_policy) || updated
      elsif actual.has_key?(bucket_name)
        actual.delete(bucket_name)

        if expected_policy
          @driver.create_policy(bucket_name, expected_policy)
          updated = true
        end
      else
        log(:warn, "No such bucket: #{bucket_name}")
      end
    end
  end

  def walk_policy(bucket_name, expected_policy, actual_policy)
    if expected_policy
      if expected_policy != actual_policy
        @driver.update_policy(bucket_name, expected_policy, actual_policy)
        updated = true
      end
    else
      @driver.delete_policy(bucket_name)
      updated = true
    end
  end

  def load_file(file)
    if file.kind_of?(String)
      open(file) do |f|
        Bukelatta::DSL.parse(f.read, file)
      end
    elsif file.respond_to?(:read)
      Bukelatta::DSL.parse(file.read, file.path)
    else
      raise TypeError, "can't convert #{file} into File"
    end
  end
end
