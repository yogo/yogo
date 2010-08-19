module Odhelper
  # check_ws_absence
  # 
  # Check string for the absence of tabs, line feeds and carriage returns and
  # return true if they are absent and false with error message otherwise
  # Used as a validation method example:
  # validates_with_block :check_ws_absence(self.VarName, "VarName")
  #
  def check_ws_absence(param_string, name)
    if !param_string.nil?
      if param_string.match('\t').nil? && param_string.match('\n').nil? && param_string.match('\r').nil? 
        return true
      else
        return [false, name +" must not contain any tabs, line feeds or carriage returns in it."]
      end
    else
      return [false, name +" must not be nil!"]
    end
  end
end