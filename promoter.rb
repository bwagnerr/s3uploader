#!/usr/bin/env ruby

require './spec/spec_helper'
require_relative 'file_searcher'
require_relative 's3_uploader'

class Promoter
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
  uploader = S3Uploader.new bucket
  promoter = Promoter.new filesearcher, uploader
  promoter.scan_files
  if promoter.upload
    puts "Upload Successful"
    exit 0
  else
    puts "Failed Uploading"
    exit 1
  end
end
