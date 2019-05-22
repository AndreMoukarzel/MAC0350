def print_function(table, id, col, types)
	if id == nil then id = "FIX" end
	func_name = table.slice(/(b\d\d_)?(\w+)/,2)
	print "BEGIN;\n"
	print "CREATE OR REPLACE FUNCTION create_#{func_name}("
	(col.length).times do |i|
		print "arg#{i} #{types[i]}"
		if i<col.length-1 then print ", " end
	end
	print ")\n" 
	print "RETURNS int AS\n" 
	print "$$\n" 
	print "DECLARE\n" 
	print "id int;\n" 
	print "BEGIN\n" 
	print "\tINSERT INTO #{table} (#{col.shift}" 
	col.each {|x| print ", #{x}"}
	print ")\n"
	print "\tVALUES ("
	(col.length+1).times do |i|
		print "$#{i+1}"
		if i<col.length then print ", " end
	end
	print ")\n"
	print "\tRETURNING #{id} into id;\n"
	print "\tRETURN id;\n"
 	print "END;\n"
	print "$$\n"
	print "LANGUAGE plpgsql;\n"
	print "COMMIT;\n\n"
end

def select_function(table, id, col, types)
	if id == nil then id = "FIX" end
	func_name = table.slice(/(b\d\d_)?(\w+)/,1)
	primary_key = col.shift
	primary_key_type = types.shift
	col.each_with_index do |x,i|
		print "BEGIN;\n"
		print "CREATE OR REPLACE FUNCTION select_#{func_name}#{x}(prim_key #{primary_key_type})\n" 
		print "RETURNS #{types[i]} AS\n" 
		print "$$\n"
		print "DECLARE\n" 
		print "value #{types[i]};\n" 
		print "BEGIN\n" 
		print "\tSELECT #{x} INTO value\n" 
		print "\tFROM #{table}\n"
		print "\tWHERE #{primary_key} = $1;\n"
		print "\tRETURN value;\n"
	 	print "END;\n"
		print "$$\n"
		print "LANGUAGE plpgsql;\n"
		print "COMMIT;\n\n"
	end
end

def main()
	ddl = File.read("DDL.sql")
	ddl.gsub! "\n", " "
	ddl.gsub! "\t", " "
	while /CREATE TABLE .+? \(.+?\);/.match(ddl) != nil
		table = ddl.slice!(/CREATE TABLE .+? \(.+?\);/)
		table.gsub! /CONSTRAINT .+\);/, ""
		
		table_name = table.slice!(/CREATE TABLE (.+?) \(/)
		table_name = table_name.slice!(/CREATE TABLE (.+?) \(/,1)
		col = []
		col_type = []
		id = nil
		while /(\s+\w+ [\w\(\)]+),?/.match(table) != nil
			tcol = table.slice!(/\s+(\w+ [\w\(\)]+)[\w\s]*,?/)
			tcol = tcol.slice(/(\w+ [\w\(\)]+)[\w\s]*,?/,1)

			ttype = tcol.slice(/(\w+) ([\w\(\)]+)/,2)
			tcol = tcol.slice(/(\w+) ([\w\(\)]+)/,1)

			if ttype == "SERIAL"
				id = tcol
			else
				col.append(tcol)
				col_type.append(ttype)
			end
		end
		select_function(table_name, id, col, col_type)
	end
end

main()