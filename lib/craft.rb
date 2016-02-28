require 'serialport'
#require 'curses'
#require 'xmlsimple'
require 'yaml'

require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

$telecmdsarray = Array.new();
$thePacketArray = Array.new();
$serialPort = SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE);
$pos=0;
$pckCount=0;


#Curses.init_screen()
#
#my_str = "Welcome to packetCraft, a utility to tx crafted packets. "
#bwin = Curses::Window.new( 10, (my_str.length + 10),
#                          (Curses.lines - 10) / 2,
#                          (Curses.cols - (my_str.length + 10)) / 2 )



#bwin = Curses::Window.new( 0,0,0,0);
#
#
#bwin.box("|", "--")
#bwin.refresh
#win = bwin.subwin( 6, my_str.length + 6,
#                  (Curses.lines - 6) / 2,
#                  (Curses.cols - (my_str.length + 6)) / 2 )
#win.setpos(2,3)
#win.addstr(my_str)
## or even
#win << "\nORLY"
#win << "\nYES!! " + my_str
#win.refresh
#win.getch
#win.close

#parse the Packet structure
$crosspacketBlock = Proc.new{ |theHash|
#  $thePacketArray.clear();
  theHash.each{ |key, value|
    if key == "has"  #then we have reached the bottom of the structure.
      value.each { |innerhash| #value is an array, the element is a hash.
        $crosspacketBlock.call( innerhash );
      }
    elsif key != "name" #no key named has, so parse the repsize and defval into the array.
                              #sprinf, prints a bitstring
      $thePacketArray[$pos] = sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
      $pos+=1;
      break; #don't ask why, just break
    end
  }
};

$telecmdpackets.each { |innerHash|
  
  $telecmdsarray[$pckCount] = $crosspacketBlock.call( innerHash );
  
  print "\n\npacket no:#{$pckCount+1} is:\n\n#{$telecmdsarray[$pckCount]}\n" ;
  
  $pckCount=$pckCount+1;
}

printf("Loaded #{$pckCount} telecommands\n")

$telecmdsarray.each{ |innerTlcmd|
  
  print innerTlcmd;
  print "\n";
}

$thePacketBinArray = Array.new();

print "\n";
print "\n";
$thePacketArray.each { |elem|
  elem.chars { |bit| #each element its a bit string array
    $thePacketBinArray.push( bit.to_i );
  }
}
    print "\n";
    print $thePacketBinArray;
    print "\n";
    print $thePacketBinArray.length;
    print "\n";
    print $thePacketBinArray.pack("C*");
    
    $serialPort.write( $thePacketBinArray.pack("C*") );

print $thePacketBinArray;
print "\nLength is : #{$thePacketBinArray.length}\n";

#puts $thePacketBinArray.pack("C*");

#puts $thePacketBinArray.length;
$serialPort.write( $thePacketBinArray );

$serialPort.write( $thePacketBinArray.pack("i*" ) );
$serialPort.write "#{$thePacketBinArray.length}\n\r"

puts "ddd"