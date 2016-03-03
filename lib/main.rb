require_relative 'opts'
#include Curses
require_relative 'craft'

#temp_ar = byteStuff($indPacketsBinArray[0]);
#
#byteDestuff(temp_ar);

ParseOptions();
ClaimSerialPort( $cmdlnoptions[:serialport]);

printf("\n---Loaded #{$pckCount} packets---\n");
PrintBasicMenu();

while inp = gets
  ParseMainInput(inp);
end

