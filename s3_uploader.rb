require 'aws/s3'
require 'dotenv'

Dotenv.load

class S3Uploader

  def initialize bucket_name
    @bucket_name = bucket_name
    connect
    create_or_find_bucket
  end

  def connect
    AWS::S3::Base.establish_connection!(
      access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
      secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
    )
  end

  def create_or_find_bucket
    @bucket ||= AWS::S3::Bucket.find(@bucket_name)
  rescue AWS::S3::NoSuchBucket => ex
    @bucket ||= AWS::S3::Bucket.create(@bucket_name)
  end

  def upload files
    files.each_pair do |relative_path, absolute_path|
      file = File.read(absolute_path)
      AWS::S3::S3Object.store file, @bucket_name
    end
  end

end
