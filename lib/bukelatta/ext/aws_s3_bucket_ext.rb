module Bukelatta::Ext
  module AwsS3BucketExt
    def auto_redirect
      ret = nil
      bckt = self

      begin
        ret = yield(bckt)
      rescue Aws::S3::Errors::PermanentRedirect => e
        res_body = MultiXml.parse(e.context.http_response.body.read)
        edpnt = res_body['Error']['Endpoint']
        clnt = Aws::S3::Client.new(endpoint: "https://#{edpnt}")
        rsrc = Aws::S3::Resource.new(client: clnt)
        bckt = rsrc.bucket(bckt.name)
        retry
      end

      ret
    end
  end
end

Aws::S3::Bucket.include(Bukelatta::Ext::AwsS3BucketExt)
