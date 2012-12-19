require "ptools"


class Filesearch
  
 def self.search(path,keyword,filepattern)
     if !File.exist?(path)
        return
     end 

     if File.directory?(path)
        searchInDir(path,keyword,"|",filepattern) 
     else
        grepFile(path,keyword,"|") 
     end
 end 

 def self.searchInDir(dir,keyword,prefix,filepattern)
    puts "#{prefix}___search in dir #{dir}:"
    Dir.chdir(dir)
    files=Dir.glob("*"+keyword+"*")
    if !files.empty?
      puts "   #{prefix}___ Files that filename contains \"#{keyword}:#{files}\""
    end
    Dir.foreach(dir){|x|
    next if x == "."
    next if x == ".."
    Dir.chdir(dir)
    if File.directory?(x)
          searchInDir(Dir.getwd+"/"+x,keyword,"   "+prefix,filepattern)
    elsif
       if File.fnmatch(filepattern,x)
        Dir.chdir(dir) 
        grepFile(Dir.getwd+"/"+x,keyword,prefix)
       end
    end
    }

 end

 def self.grepFile(fpath,keyword,prefix)
   if !File.exist?(fpath) || File.directory?(fpath)
   return
   end
   if !File.binary?(fpath)
    IO.foreach(fpath){|x| 
     if x.index(keyword) != nil
      puts "   #{prefix}#{fpath} contains keyword \"#{keyword}\""
      puts "                 #{x}"
      puts "                 ..."
      break
     end
    } 
   end
 end 

end

if ARGV.empty? || ARGV.length< 3
   puts "right format: ruby -w Filesearch.rb  path keyword filepattern"
else
   Filesearch.search(ARGV[0],ARGV[1],ARGV[2])
end

