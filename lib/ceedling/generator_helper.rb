# =========================================================================
#   Ceedling - Test-Centered Build System for C
#   ThrowTheSwitch.org
#   Copyright (c) 2010-24 Mike Karlesky, Mark VanderVoord, & Greg Williams
#   SPDX-License-Identifier: MIT
# =========================================================================

require 'ceedling/constants'
require 'ceedling/exceptions'


class GeneratorHelper

  constructor :loginator


  def test_results_error_handler(executable, shell_result)
    notice = ''
    error  = false
    
    if (shell_result[:output].nil? or shell_result[:output].strip.empty?)
      error = true
      # mirror style of generic tool_executor failure output
      notice  = "Test executable \"#{File.basename(executable)}\" failed.\n" +
                "> Produced no output to $stdout.\n"
    elsif ((shell_result[:output] =~ TEST_STDOUT_STATISTICS_PATTERN).nil?)
      error = true
      # mirror style of generic tool_executor failure output
      notice  = "Test executable \"#{File.basename(executable)}\" failed.\n" +
                "> Produced no final test result counts in $stdout:\n" +
                "#{shell_result[:output].strip}\n"
    end
    
    if (error)
      # since we told the tool executor to ignore the exit code, handle it explicitly here
      notice += "> And exited with status: [#{shell_result[:exit_code]}] (count of failed tests).\n" if (shell_result[:exit_code] != nil)
      notice += "> And then likely crashed.\n"                                                       if (shell_result[:exit_code] == nil)

      notice += "> This is often a symptom of a bad memory access in source or test code.\n\n"

      raise CeedlingException.new( notice )
    end
  end
  
end
