require 'yaml'
require "serialport"

require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

$thePacketArray = Array.new();
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
#print $tempArrayRef;
#print $thePacketArray.pack("B*");

print "\n";
$thePacketArray.each { |elem|
  
  print elem.class
  printf("element #{elem} is in binary: %b\n",elem.to_s());
  
}

pos=pos+1;
#    for temp in (1..$telecmdpacket[key].size) do
##      $packetArray[pos][temp] = 
#    end
    
#    $packetArray[pos][]
    
    for temp in $packetArray[pos] do
      print temp;
    end
    
    $packetArray[pos].each { |x|  #first array of arrays
        print "#{x}\n" ;
#        print "#{$packetArray[pos][x]}\n"
      
      }
  

pck_id_seg.each { |ar|
  ar[0]=2; #version number
  ar[1]=PCKT_VER_NUM_SZ #version number bits reprsize
}

print pck_id_seg.length;
print pck_id_seg;

pck_id_seg.each { |elem| 
  printf("%0#{elem[1]}b\n", elem[0]);
  
}
#print $telecmdpacket;

#print $telecmdpacket['has'][0]['has'][0].size
#s = pck_id_ar.pack("b#{pck_id_ar.length}");

#print s.reprsize;

#create the packet sequence control
  pck_seq_ctrl_seg.push( rand(0..3).to_s(2), rand(0..100).to_s(2) );

#create the packet length
	pck_length_seg.push( 65536.to_s(2) );	

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