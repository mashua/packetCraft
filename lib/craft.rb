require_relative 'utils'

#Telecommand packet structure
#Packet Header
 	
#PacketHeader, total size is 48bits, ALL SIZES IN BITS
PCKT_HEADER_SZ = 48;
	#Packet ID
PCKT_ID_SZ = 16;
PCKT_VER_NUM_SZ = 3;
PCKT_TYPE_SZ = 1;
PCKT_DFHF_SZ = 1;	#packet DATA FIELD HEADER FLAG
PCKT_APID_SZ = 11; 
	#Packet Sequence control
PCKT_SEQ_FL_SZ = 2;
PCKT_SEQ_CNT_SZ = 14;
	#Packet Length
PCKT_LGTH_SZ = 16;	#this is number of octets contained in
					#packet data field

#SIZES DEFINITIONS
#Packet Data Field, variable size
PCKT_DFH_SZ = rand(50)
PCKT_APPDT_SZ = rand(50)
PCKT_SPR_SZ = rand(50)
PCKT_PERCTL_SZ = 16	
	#Packet Data Field Header
CCSDS_SEC_HDR_FLG_SZ = 1;
TC_PCK_PUS_VER_NUM_SZ = 3;
ACK_SZ = 4;
SRVC_TYPE_SZ = 8;
SRVC_STYPE_SZ = 8;
SRC_ID_SZ = rand(50)
#SPARE_SZ =  rand(50) #SIZE TO PADD THE MESSAGE TO ARCHITECTURE SPECIFIC SIZE, optional

# => All elements of the packet will be in the format { {<bitvalues>}, {<padsize>} }
# =>                                                  { {1}, {0001}}

pck_hdr_ar = Array.new(); #size 48 bits
	pck_id_seg = CreatePacketSegment(4,2);
  
  pck_id_seg.push(0).push(3); #VersionNumber=0, element size=3

	pck_seq_ctrl = Array.new();
	pck_length = Array.new();

#create the packetID
#pck_id_ar.push( 0.to_s(2), 1.to_s(2), 1.to_s(2), rand(10).to_s(2) );
pck_id_seg.push( 0, 1, 1, rand(10) );

print pck_id_seg.length;
print pck_id_seg;

pck_id_seg.each { |elem| printf("%0#{s}b\n", elem);  }



#s = pck_id_ar.pack("b#{pck_id_ar.length}");

#print s.size;

#create the packet sequence control
  pck_seq_ctrl.push( rand(0..3).to_s(2), rand(0..100).to_s(2) );

#create the packet length
	pck_length.push( 65536.to_s(2) );	

pck_hdr_ar.push( pck_id_seg.pack("b3b3b3b3"));
pck_hdr_ar.push( pck_seq_ctrl.pack("b3b3"));
pck_hdr_ar.push( pck_length.pack("b3") );

pck_hdr_ar.each{ |elem|

	print(elem.size);

}

bin = pck_hdr_ar.pack("b3b3b3");
puts bin;

#pck_hdr_ar.each { |x|
#	print "now printing: #{x.to_s(2)}";
#	print("\n\t");
#	print x.to_s(2)(2);	
#	print("\n");

#}