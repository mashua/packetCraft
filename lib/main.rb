require_relative 'opts'
#include Curses
require_relative 'craft'

#ParseArguments();
ParseOptions();

printf $serialPort;
printf("\n---Loaded #{$pckCount} packets---\n");
PrintBasicMenu();

while inp = gets
  ParseMainInput(inp);
end

