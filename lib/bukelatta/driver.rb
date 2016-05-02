class Bukelatta::Driver
  include Bukelatta::Utils::Helper
  include Bukelatta::Logger::Helper

  def initialize(client, options = {})
    @client = client
    @resource = Aws::S3::Resource.new(client: @client)
    @options = options
  end

  def create_policy(bucket_name, policy)
    log(:info, "Create Bucket `#{bucket_name}` Policy", color: :cyan)

    unless @options[:dry_run]
      bucket = @resource.region_bucket(bucket_name)
      bucket.policy.put(policy: JSON.dump(policy))
    end
  end

  def delete_policy(bucket_name)
    log(:info, "Delete Bucket `#{bucket_name}` Policy", color: :red)

    unless @options[:dry_run]
      bucket = @resource.region_bucket(bucket_name)
      bucket.policy.delete
    end
  end

  def update_policy(bucket_name, policy, old_policy)
    log(:info, "Update Bucket `#{bucket_name}` Policy", color: :green)
    log(:info, diff(old_policy, policy, color: @options[:color]), color: false)

    unless @options[:dry_run]
      bucket = @resource.region_bucket(bucket_name)
      bucket.policy.put(policy: JSON.dump(policy))
    end
  end
end
