#!/usr/bin/ruby

require 'minitest/autorun'
require_relative "organizer"

class OrganizerTest < Minitest::Test
	def test_get_dot_index
		assert get_dot_index("000.0") != nil
		assert get_dot_index("000.0") == 3
	end

	def test_has_nan
		assert !has_nan("000.0", 3)
		assert has_nan("foo.0", 3)
	end

	def test_get_numbered_filenames
		for i in 0...101 do
			File.new("#{i}.foo", "w")
		end
		numbered_filenames = get_numbered_filenames
		assert numbered_filenames[0].length == 101
		assert numbered_filenames[1] == 3
		for i in 0...101 do
			File.delete("#{i}.foo")
		end
	end

	def test_get_corrected_filenames
		File.new("1.foo", "w")
		File.new("100.foo", "w")
		numbered_filenames = get_numbered_filenames
		corrected_filenames = get_corrected_filenames(numbered_filenames)
		for i in 0..1 do
			assert corrected_filenames[i].length == 7
		end
		File.delete("1.foo")
		File.delete("100.foo")
	end

	def test_write_corrected_filenames
		File.new("1.foo", "w")
		File.new("100.foo", "w")
		numbered_filenames = get_numbered_filenames
		corrected_filenames = get_corrected_filenames(numbered_filenames)
		write_corrected_filenames(numbered_filenames, corrected_filenames)
		Dir.foreach("./") do |entry|
			if !get_dot_index(entry).nil?
				if !has_nan(entry, get_dot_index(entry))
					puts entry
					assert entry.length == 7
				end
			end
		end
		File.delete("001.foo")
		File.delete("100.foo")
	end
end
