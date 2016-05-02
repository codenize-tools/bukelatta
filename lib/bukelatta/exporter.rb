class Bukelatta::Exporter
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

  def export_buckets
    result = {}
    concurrency = @options[:request_concurrency]

    buckets = @resource.buckets(concurrency: concurrency)

    Parallel.each(buckets, in_threads: concurrency) do |bucket|
      policy = export_bucket_policy(bucket)
      result[bucket.name] = policy
    end

    result.sort_array!
  end

  def export_bucket_policy(bucket)
    policy = JSON.parse(bucket.policy.policy.string)
  rescue Aws::S3::Errors::NoSuchBucketPolicy
    nil
  end
end
