require 'yaml'
require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

#pck_hdr_seg = CreatePacketSegment(3,1) #reprsize 48 bits
#	pck_id_seg = CreatePacketSegment(4,2);
#  pck_seq_ctrl_seg = CreatePacketSegment(2,2);
#	pck_length_seg = CreatePacketSegment(1,1);

$packetArray = Array.new(2);
$tempArrayRef = $packetArray;
$pos=0;

#A block that takes a Hash and does the appropriate handling.
$gatherBlock = Proc.new{ |theHash|
  
  theHash.each{ |key, value|
    if key=="name"      
  #    $packetArray.push( Array.new() );
      $tempArrayRef[$pos] = theHash['name']; #put the name of the packet segment in the first position, just for reference
      $pos=$pos+1;
  #    $packetArray.push( Array.new( $telecmdpacket[key].size ));
    elsif key == "has" #it's an array of hashes
      print $tempArrayRef;
      
      $tempArrayRef[$pos] = Array.new( theHash[key].size );
      $tempArrayRef = $tempArrayRef[$pos];
      
      print $tempArrayRef;
      
      $pos=0;
      theHash['has'].each { |tempinnerhash|  
        $gatherBlock.call( tempinnerhash );       
      }
    end
  }
};

$gatherBlock.call( $telecmdpacket );
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