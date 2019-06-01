def main()
	ddl = File.read("DML_UPDATE_GROUP.sql")
	ddl.gsub! "\n", " "
	ddl.gsub! "\t", " "
	while /BEGIN; CREATE OR REPLACE FUNCTION .+?\(.+?\).+? COMMIT;/.match(ddl) != nil
		table = ddl.slice!(/BEGIN; CREATE OR REPLACE FUNCTION .+?\(.+?\).+?COMMIT;/)
		func = table.slice!(/BEGIN; CREATE OR REPLACE FUNCTION (.+?\(.+\)).+? COMMIT;/,1)
		puts func
	end
end

main()