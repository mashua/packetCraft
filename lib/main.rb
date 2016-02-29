require_relative 'craft'

#include Curses

ParseArguments();
printf("\n---Loaded #{$pckCount} packets---\n");
PrintBasicMenu();

while inp = gets
  ParseMainInput(inp)
end

