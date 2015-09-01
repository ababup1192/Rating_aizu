class FileManagement
  def initialize(rating_dir,file_extension,delimiter,output_file)
    @rating_dir = rating_dir
    @file_extension = file_extension
    @delimiter = delimiter
    @output_file = output_file
  end
  def get_mailing_list(file_path)
    arr = []
    begin
      open(file_path) {|file|
        while l = file.gets
          l =~ /^(\w\d*)$/
          if !$1.nil?
            arr << $1
          end
        end
      }
      arr
    rescue
      arr
    end
  end
  def read_result
    hash = {}
    begin
      open("#{rating_dir}/#{output_file}"){ |file|
        while l = file.gets
          if (l =~ /^(\w\d*)(.?)(\d*$)/) == 0
            @delimiter = $2
            hash.store($1,$3.to_i)
          end
        end
      }
      hash
    rescue
      hash
    end
  end
  def write_result(point_hash)
    result = ""
    point_hash.each do |key,point|
      result += "#{key}#{@delimiter}#{point}\n"
    end
    begin
      open("#{@rating_dir}/#{output_file}", "w"){ |f|
        f.write result
      }
      result
    rescue
      result
    end
  end
  attr_accessor :rating_dir,:file_extension,:delimiter,:output_file
end
