require 'pathname'

class FileSearcher

  def initialize path
    @original_path = Pathname(path).realdirpath
    @search_path = Pathname(path).realdirpath.join('**/**')
  end

  def examine
    files = {}
    Dir[@search_path].each do |file|
      absolute_path = Pathname(file)
      relative_path = absolute_path.relative_path_from(@original_path)
      files[relative_path.to_s] = absolute_path.to_s unless absolute_path.directory?
    end
    files
  end

end
