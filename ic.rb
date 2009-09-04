#!/usr/bin/env ruby
# written for ruby 1.8.7


INCLUDES_NAME = 'working_includes.c'
WORKING_NAME = 'working.c'
TEST_NAME = 'test.c'

PREFIX = IO.read('boilerplate_start.c')
SUFFIX = IO.read('boilerplate_end.c')

# init
[WORKING_NAME, INCLUDES_NAME].each {|x| File.delete x if File.exists? x}

def execute(str)
    File.delete 'a.out' if File.exists? 'a.out'
    
    test_includes = File.exists?(INCLUDES_NAME) ? IO.read(INCLUDES_NAME) : ''
    test = File.exists?(WORKING_NAME) ? IO.read(WORKING_NAME) : ''
    
    # move disabling/enabling of stdout
    test.sub!(/^\s*stdout\s*=\s*fake_stdout;.*$/, '')
    test.sub!(/^\s*stdout\s*=\s*real_stdout;.*$/, "stdout = fake_stdout;\n")
    test << "stdout = real_stdout;\n"
    
#SO MESSY.  I'M SO SORRY!!
    def write_test_c(test, test_includes)
      test_file = File.new(TEST_NAME, 'w')
      test_file.puts(test_includes)
      test_file.puts(PREFIX)
      test_file.puts(test)
      test_file.puts(SUFFIX)
      test_file.close
    end

    if str.start_with? '#include'
      test_includes << str << "\n"
    else
      test_with_a = test.dup
      test_with_a << 'a = ' << str << "\nprintf(\"[%d]\", a);\n"
    end
    
    write_test_c(test_with_a, test_includes)
    
    compile_output = `gcc test.c 2>&1`
    if($?.exitstatus != 0)
      test << str << "\n"
      write_test_c(test, test_includes)
      compile_output = `gcc test.c 2>&1`
    end
    
    
    
    if($?.exitstatus == 0)
      #run app
      prog_output = `./a.out 2>&1`
      if ($?.exitstatus == 0)  
        if str.start_with? '#include'
          includes_file = File.new(INCLUDES_NAME, 'w')
          includes_file.print(test_includes)
          includes_file.close
        else
          working_file = File.new(WORKING_NAME, 'w')
          working_file.print(test)
          working_file.close
        end
        
        puts '=> "'<< prog_output <<'"'
      else
        puts '~> runtime error: ' << prog_output
      end
    else
      puts '~> compilation error: ' << compile_output
    end
end


buff = ""
# main loop
while(true)
  print '>> '
  buff << gets
  buff.strip!
  exit(0) if buff.downcase == 'exit'
  execute(buff)
  buff = ''
end

