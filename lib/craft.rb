require 'serialport'
require 'curses'
#require 'xmlsimple'
require 'yaml'

require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'


#holds a reference to an array who contains the individual
#packets string representation, like: parsed yaml
$indPacketsStrArray = Array.new();

#holds a two-dimensional reference to an array who contains the individual
#packets binary string representation, like: "01001"
$indPacketsBinStrArray = Array.new();

#hols a two-dimensional reference to an array who contains the individual
#packets binary representation, like: 01001
$indPacketsBinArray = Array.new();

#holds a reference to the total loaded packets binary string representation
$totalPacketsBinStrArray = Array.new();

#holds a reference to an array who contains the individual
#packets binary representation in one sequence, like: 01001
$totalPacketsBinArray = Array.new();

begin 

  $serialPort = SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE);

rescue
  print("Serial port error!continuing...\n");
end

$pos=0;
$pckCount=0;

#parse the Packet structure
$crosspacketBlock = Proc.new{ |theHash, level|
#  $thePacketArray.clear();

  theHash.each{ |key, value|
    if key == "has"  #then we have reached the bottom of the structure.
      value.each { |innerhash| #value is an array, the element is a hash.
        $crosspacketBlock.call( innerhash, level );
      }
    elsif key != "name" #no key named has, so parse the repsize and defval into the array.
                              #sprinf, prints a bitstring
      $totalPacketsBinStrArray[$pos] = sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
      $indPacketsBinStrArray[level][$pos]=sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
      $pos+=1;
      break; #don't ask why, just break
    end
  }
};


$telecmdpackets.each { |innerHash|
  $indPacketsBinStrArray<<Array.new();#new array to hold reference to the new binary string representation of the packet.
  $indPacketsStrArray[$pckCount] = $crosspacketBlock.call( innerHash,$pckCount );
#    print "\n\npacket no:#{$pckCount+1} is:\n\n#{$indPacketsStrArray[$pckCount]}\n" ;
  $indPacketsBinStrArray[$pckCount].compact!;
#    print "\nwith string binary representation of:\n #{$indPacketsBinStrArray[$pckCount]}\n" ;
  $pckCount=$pckCount+1;
}

#printf("\n---Loaded #{$pckCount} packets---\n")
#print $totalPacketsBinStrArray
#print "\n\n\n";

#prepare the whole packet binary array
$totalPacketsBinStrArray.each { |elem|
  elem.chars { |bit| #each element its a bit string
    $totalPacketsBinArray.push( bit.to_i );
  }
}

#prepare the individual packets binary arrays
#print $indPacketsBinStrArray;

$indPacketsBinStrArray.each_with_index { |elem,index| #elem is an array with string elements,eg: "010"
 $indPacketsBinArray<<Array.new();
  elem.each { |innerArray| #each element its a bit string array
    innerArray.chars { |bit|
      $indPacketsBinArray[index].push( bit.to_i );
    }
  }
}
#print $indPacketsBinArray
#print $totalPacketsBinArray

#print $indPacketsStrArray;
#    print "\n";
#    print $totalPacketsBinArray;
#    print "\n";
#    print $totalPacketsBinArray.length;
#    print "\n";
#    print $totalPacketsBinArray.pack("C*");
#    print "\n";
#    $indPacketsBinArray.each_index { |unusedlocal|
#      print "\n";
#      print $indPacketsBinArray[unusedlocal].pack("C*");
#      print "\n";
#  
#    }
  
    
#    $serialPort.write( $totalPacketsBinArray.pack("C*") );
#
#$serialPort.write( $totalPacketsBinArray );
#
#$serialPort.write( $totalPacketsBinArray.pack("i*" ) );
#$serialPort.write "#{$totalPacketsBinArray.length}\n\r"
#
#puts "ddd"