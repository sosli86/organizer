# Source: https://www.rubyguides.com/2015/06/ruby-regex/

# Returns dot_index

def get_dot_index(str)
	str =~ /[.]/
end

# Returns true if there are NaNs before the .

def has_nan(str, dot_index)
	@name = str[0, dot_index]
	!@name.match?(/\A-?\d+\Z/)
end

def get_numbered_filenames()
	@numbered_filenames = Array.new
	@dot_index = 0
	@max_dot = 0
	Dir.foreach("./") do |entry|
		if !get_dot_index(entry).nil? && !has_nan(entry, get_dot_index(entry))
			@dot_index = get_dot_index(entry)
			if !has_nan(entry, @dot_index)
				if @dot_index > @max_dot
					@max_dot = @dot_index
				end
				@numbered_filenames.append(entry)
			end
		end
	end
	return [ @numbered_filenames, @max_dot ]
end

def get_corrected_filenames(arr)
	@numbered_filenames = arr[0]
	@corrected_filenames = Array.new
	@max_dot = arr[1]
	puts @max_dot
	@dot_index = 0
	@dot_diff = 0
	for i in 0..@numbered_filenames.length-1
		@dot_index = get_dot_index(@numbered_filenames[i])
		@dot_diff = @max_dot - @dot_index
		@corrected_filenames[i] = ""
		if @dot_diff > 0
			for j in 0..@dot_diff-1
				@corrected_filenames[i] << "0"
			end
		end
		@corrected_filenames[i] << @numbered_filenames[i]
	end
	return @corrected_filenames
end

def write_corrected_filenames(original, corrected)
	for i in 0..original.length-1
		file.rename( original[i], corrected[i] )
	end
end

numbered_filenames = get_numbered_filenames
corrected_filenames = get_corrected_filenames(numbered_filenames)

for i in 0..numbered_filenames[0].length-1
	File.rename( numbered_filenames[0][i], corrected_filenames[i] )
end

#for i in 0..numbered_filenames[0].length-1
#	print(numbered_filenames[0][i], " ", corrected_filenames[i], "\n")
#end
