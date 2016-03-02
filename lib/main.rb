require_relative 'opts'
#include Curses
require_relative 'craft'

ParseOptions();
ClaimSerialPort( $cmdlnoptions[:serialport]);

printf("\n---Loaded #{$pckCount} packets---\n");
PrintBasicMenu();

while inp = gets
  ParseMainInput(inp);
end

