# Bukelatta

Bukelatta is a tool to manage S3 Bucket Policy.

It defines the state of S3 Bucket Policy using DSL, and updates S3 Bucket Policy according to DSL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bukelatta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bukelatta

## Usage

```sh
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
bukelatta -e -o Policyfile  # export Bucket Policy
vi Policyfile
bukelatta -a --dry-run
bukelatta -a                # apply `Policyfile`
```

## Help

```
Usage: bukelatta [options]
    -k, --access-key ACCESS_KEY
    -s, --secret-key SECRET_KEY
    -r, --region REGION
        --profile PROFILE
        --credentials-path PATH
    -a, --apply
    -f, --file FILE
        --dry-run
    -e, --export
    -o, --output FILE
        --split
        --target REGEXP
        --no-color
        --debug
        --request-concurrency N
```

## Policyfile example

```ruby
require 'other/policyfile'

bucket "foo-bucket" do
  {"Version"=>"2012-10-17",
   "Id"=>"AWSConsole-AccessLogs-Policy-XXX",
   "Statement"=>
    [{"Sid"=>"AWSConsoleStmt-XXX",
      "Effect"=>"Allow",
      "Principal"=>{"AWS"=>"arn:aws:iam::XXX:root"},
      "Action"=>"s3:PutObject",
      "Resource"=>
       "arn:aws:s3:::foo-bucket/AWSLogs/XXX/*"}]}
end

bucket "bar-bucket" do
  {"Version"=>"2012-10-17",
   "Statement"=>
    [{"Sid"=>"AddPerm",
      "Effect"=>"Allow",
      "Principal"=>"*",
      "Action"=>"s3:GetObject",
      "Resource"=>"arn:aws:s3:::bar-bucket/*"}]}
end
```

## Similar tools
* [Codenize.tools](http://codenize.tools/)
