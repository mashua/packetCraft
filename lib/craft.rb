require 'yaml'
require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

#Telecommand packet structure
#Packet Header
 	
#PacketHeader, total reprsize is 48bits, ALL reprsizeS IN BITS
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

#reprsizeS DEFINITIONS
#Packet Data Field, variable reprsize
PCKT_DFH_SZ = rand(50)
PCKT_APPDT_SZ = rand(2500) 
PCKT_SPR_SZ = rand(50)
PCKT_PERCTL_SZ = 16	
	#Packet Data Field Header
CCSDS_SEC_HDR_FLG_SZ = 1;
TC_PCK_PUS_VER_NUM_SZ = 3;
ACK_SZ = 4;
SRVC_TYPE_SZ = 8;
SRVC_STYPE_SZ = 8;
SRC_ID_SZ = 3
SPARE_SZ =  1 #reprsize TO PADD THE MESSAGE TO ARCHITECTURE SPECIFIC reprsize, optional



#Each packet segment will be at first an array of arrays.
#The inner arrays in most cases will be two dimensional as they will contain the value and the bit numbers that represent this length.
# => All elements of the packet will be in the format { {<bitvalues>}, {<padreprsize>} }
# =>                                                  { {1}, {0001}} #for a pad reprsize o 4 bits.

pck_hdr_seg = CreatePacketSegment(3,1) #reprsize 48 bits
	pck_id_seg = CreatePacketSegment(4,2);
  pck_seq_ctrl_seg = CreatePacketSegment(2,2);
	pck_length_seg = CreatePacketSegment(1,1);

pck_id_seg.each { |ar|
  ar[0]=2; #version number
  ar[1]=PCKT_VER_NUM_SZ #version number bits reprsize
}

print pck_id_seg.length;
print pck_id_seg;

pck_id_seg.each { |elem| 
  printf("%0#{elem[1]}b\n", elem[0]);
  
}

telecmdpacket = { 'name' => 'TelecommandWholePacket',
                  'reprsize' => 65535,
                  'has' => [ {  'name'  => 'PacketHeader',
                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
                                              'reprsize' => 16,
                                              'has'  => [ { 'name' => 'VersionNumber',
                                                            'reprsize' => 3,
                                                            'defval' => 0
                                                          },
                                                          { 'name' => 'Type',
                                                            'reprsize' => 1,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'DataFieldHeaderFlag',
                                                            'reprsize' => 1,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'ApplicationProcessID',
                                                            'reprsize' => 11,
                                                            'defval' => 5
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
                                              'reprsize'  => 48,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 11 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 1 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLenght',
                                              'reprsize'  => 16,
                                              'defval' => 65542
                                            }
                                          ]
                              }, 
                              { 'name'  => 'PacketDataField',
                                'reprsize'  => 33,
                                'has'   =>[ { 'name' => 'DataFieldHeader',
                                              'reprsize' => 24+SRC_ID_SZ+SPARE_SZ,
                                              'has'  => [ { 'name' => 'CCSDSSecondaryHeaderFlag',
                                                            'reprsize' => 1,
                                                            'defval' => 0 #non-CCSDS secondary header
                                                          },
                                                          { 'name' => 'TC Packet PUS Version Number',
                                                            'reprsize' => 3,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'Ack',
                                                            'reprsize' => 4,
                                                            'defval' => 0xb1111 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 255
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 255
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ, #rand(50) needs 6 bits
                                                            'defval' => 5
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 12,
                                              'defval' => PCKT_APPDT_SZ
                                            }
                                          ]
                              }
                            ]
}
print telecmdpacket['has'][0]['has'][0]['has'][3]['reprsize']
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