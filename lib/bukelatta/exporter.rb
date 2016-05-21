class Bukelatta::Exporter
  include Bukelatta::Utils::Helper

  def self.export(client, options = {})
    self.new(client, options).export
  end

  def initialize(client, options = {})
    @client = client
    @options = options
    @resource = Aws::S3::Resource.new(client: @client)
  end

  def export
    export_buckets
  end

  private

  def export_buckets
    result = {}
    buckets = @resource.buckets
    concurrency = @options[:request_concurrency]

    Parallel.each(buckets, in_threads: concurrency) do |bucket|
      next unless matched?(bucket.name)

      policy = export_bucket_policy(bucket)
      result[bucket.name] = policy
    end

    result.sort_array!
  end

  def export_bucket_policy(bucket)
    bucket.auto_redirect do |b|
      JSON.parse(b.policy.policy.string)
    end
  rescue Aws::S3::Errors::NoSuchBucketPolicy
    nil
  end
end
