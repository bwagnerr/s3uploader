#!/usr/bin/env ruby

require_relative 'file_searcher'
require_relative 's3_uploader'

class Uploader
  def initialize(filesearcher, uploader)
    @searcher = filesearcher
    @uploader = uploader
  end


  def scan_files
    @files = @searcher.examine
  end

  def upload
    @uploader.upload
    return true
  rescue StandardError => ex
    puts ex.message
    return false
  end
end

if __FILE__ == $0
  usage = "\nUsage: path_to_script <bucket> <path>\n"

  abort "Error: The bucket name must be provided to upload to s3 #{usage}" if ARGV[0].nil?
  abort "Error: The folder path must be provided to upload to s3 #{usage}" if ARGV[1].nil?

  bucket = ARGV[0]
  path = ARGV[1]

  filesearcher = FileSearcher.new path
  s3uploader = S3Uploader.new bucket
  uploader = Uploader.new filesearcher, s3uploader
  uploader.scan_files
  if uploader.upload
    puts "Upload Successful"
    exit 0
  else
    puts "Failed Uploading"
    exit 1
  end
end
