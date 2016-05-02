module Bukelatta::Ext
  module AwsS3ResourceExt
    DEFULT_CONCURRENCY = 8

    def buckets(options = {})
      concurrency = options[:concurrency] || DEFULT_CONCURRENCY

      Parallel.map(super(), in_threads: concurrency) do |b|
        region_bucket0(b)
      end
    end

    def region_bucket(name)
      b = self.bucket(name)
      region_bucket0(b)
    end

    private

    def region_bucket0(b)
      begin
        b.objects.limit(1).first
        b
      rescue Aws::S3::Errors::PermanentRedirect => e
        responce_body = e.context.http_response.body.read
        responce_body = MultiXml.parse(responce_body)
        endpoint = responce_body['Error']['Endpoint']
        client = Aws::S3::Client.new(endpoint: "https://#{endpoint}")
        resource = Aws::S3::Resource.new(client: client)
        resource.bucket(b.name)
      end
    end
  end
end

Aws::S3::Resource.prepend(Bukelatta::Ext::AwsS3ResourceExt)
