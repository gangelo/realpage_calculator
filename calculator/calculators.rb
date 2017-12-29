
# For convenience. Load everything in the calculators folder (all calculators and interfaces) 
# excluding this current file.
Dir["calculator/*.rb"].each { |file|
	next if File.basename(file) == File.basename(__FILE__)
	require "./#{file}" 
}