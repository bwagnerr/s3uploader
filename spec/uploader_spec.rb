require "./spec/spec_helper"
require "./uploader"

describe Uploader do

  let(:file_list) { ['file1', 'file2'] }

  let(:searcher) { double(FileSearcher, examine: file_list) }
  let(:uploader) { double(S3Uploader, upload: true ) }

  subject { Uploader.new searcher, uploader }

  before do
  end

  context 'when asked to scan files' do

    it 'calls the searcher examine' do
      expect(searcher).to receive :examine
      subject.scan_files
    end

    it 'returns a list of files found, to be uploaded' do
      expect(subject.scan_files).to match_array file_list
    end

  end

  context 'when asked to upload' do

    it 'calls the uploader upload' do
      expect(uploader).to receive :upload
      subject.upload
    end

    it 'returns true if the upload was successful' do
      successful_uploader = double(S3Uploader, upload: nil)
      promoter = Uploader.new searcher, successful_uploader
      expect(promoter.upload).to be_true
    end

    it 'returns false if the upload had problems' do
      fail_uploader = double(S3Uploader)
      fail_uploader.stub(:upload).and_raise(AWS::S3::NoSuchKey.new({}, :key))
      promoter = Uploader.new searcher, fail_uploader
      expect(promoter.upload).to be_false
    end

  end
end
