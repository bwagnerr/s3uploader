require './spec/spec_helper'
require './file_searcher'

describe FileSearcher do

  subject { FileSearcher.new('spec/test_folder') }

  let(:files) { {'file1' => 'mega/path/to/file1', 'file2' => 'mega/path/to/file2' } }

  context 'when asked to examine' do

    it 'return a hash of files with absolute and relative path' do
      expect(subject.examine.keys).to match_array files.keys
    end

  end

end
