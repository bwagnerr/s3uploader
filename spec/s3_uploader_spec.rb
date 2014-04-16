require './spec/spec_helper'
require './s3_uploader'

describe S3Uploader do

  before do
    S3Uploader.any_instance.stub(:connect)
    S3Uploader.any_instance.stub(:create_or_find_bucket)
  end

  subject { S3Uploader.new('test_bucket') }

  let(:files) { {'file1' => 'spec/test_folder/file1', 'file2' => 'spec/test_folder/file2' } }

  context 'when asked to upload' do

    it 'sends the files to s3' do
      expect(AWS::S3::S3Object).to receive :store
      AWS::S3::S3Object.stub(:store)
      subject.upload(files)
    end

  end

end
