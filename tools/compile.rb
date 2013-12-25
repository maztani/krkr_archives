require "Find"

Dir.chdir("C:\\krkr\\biscrat-krkr-utils\\tools\\")

PreprocessFile = File.absolute_path("./include/preprocessSetting.tjs")
IncludePath = File.absolute_path("include/")

def clean(dir)
	Find.find(dir){|f|
		next unless FileTest.file?(f)
		if File.basename(f)[0] != "."
			File.delete(f)
		end
	}
end

def compile(dest, src, param)
	Find.find(src){|f|
		next unless FileTest.file?(f)
		f = File.absolute_path(f)
		cmd = "m4 -E -P #{param} -I\"#{IncludePath}\" \"#{PreprocessFile}\" \"#{f}\""
		puts " == PREPROCESS(#{f}) =="
		puts cmd
		result = `#{cmd}`
		
		if $? != 0
			puts " == PREPROCESS ERROR =="
			return false
		end
		File.write("#{dest}#{File.basename f}", result)
	}
end

clean_flag = false
debug_flag = false
release_flag = false
ARGV.each {|arg|
	p arg
	if arg == "-clean"
		clean_flag = true
	end
	if arg == "-debug"
		debug_flag = true
		
	end
	if arg == "-release"
		release_flag = true
	end
}


if debug_flag
	if clean_flag
		clean("../data/debug/")
	end
	compile( "../data/debug/", "../src/", "-D__DEBUG=1 -D__RELEASE=0")
end
if release_flag
	if clean_flag
		clean("../data/release/")
	end
	compile( "../data/release/", "../src/", "-D__DEBUG=0 -D__RELEASE=1")
end
