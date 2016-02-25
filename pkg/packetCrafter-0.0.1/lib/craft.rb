require 'yaml'
require "serialport"

require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

$thePacketArray = Array.new();
$serialPort = SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE);
$pos=0;

$crosspacketBlock = Proc.new{ |theHash|

  theHash.each{ |key, value|
    if key == "has"  #then we have reached the bottom of the structure.
      value.each { |innerhash| #value is an array, the element is a hash.
        
        $crosspacketBlock.call( innerhash );
      }
    elsif key != "name" #no key named has, so parse the repsize and defval into the array.
      
      $thePacketArray[$pos] = sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
      $pos+=1;
      break; #don't ask why, just break
    end
  }
};

#r = 505.to_s(2);

#ara << printf(ara,"%b",505);

#print r;
#print r.class;
#printf("%b", 50);
      
$crosspacketBlock.call( $telecmdpacket );

#test = Array.new( [0b111, 0b001] );
#
#print test;
#print "\n";
#print test[0].class; 

#print $tempArrayRef;
#print $thePacketArray.pack("B*");
print $thePacketArray;

$thePacketBinArray = Array.new();

print "\n";
print "\n";
$thePacketArray.each { |elem|
  elem.chars { |bit| #each element its a string bit array
    
#    print bit
    $thePacketBinArray.push( bit.to_i );
  }
}
    print "\n";
    print $thePacketBinArray;
    print "\n";
    print $thePacketBinArray.length;
    print "\n";
    
    $thePacketBinArray.each { |gg|
      
      print gg.class;
      
    } 
    print "\n";
    print $thePacketBinArray.pack("C*");
    
    $serialPort.write( $thePacketBinArray.pack("C*") );



#$serialPort.write( a );
#$serialPort.write( "\n\r" );


print $thePacketBinArray;
print "\nLength is : #{$thePacketBinArray.length}\n";

#puts $thePacketBinArray.pack("C*");

#puts $thePacketBinArray.length;
$serialPort.write( $thePacketBinArray );

$serialPort.write( $thePacketBinArray.pack("i*" ) );
$serialPort.write "#{$thePacketBinArray.length}\n\r"
pos=pos+1;
#    for temp in (1..$telecmdpacket[key].size) do
##      $packetArray[pos][temp] = 
#    end
    
#    $packetArray[pos][]

pck_hdr_seg.push( pck_id_seg.pack("b3b3b3b3"));
pck_hdr_seg.push( pck_seq_ctrl_seg.pack("b3b3"));
pck_hdr_seg.push( pck_length_seg.pack("b3") );

pck_hdr_seg.each{ |elem|

	print(elem.reprsize);

}

bin = pck_hdr_seg.pack("b3b3b3");
puts bin;

#pck_hdr_ar.each { |x|
#	print "now printing: #{x.to_s(2)}";
#	print("\n\t");
#	print x.to_s(2)(2);	
#	print("\n");

#}