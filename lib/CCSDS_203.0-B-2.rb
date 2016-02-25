#CCSDS 203.0-B-2

#telecommand specific definitions
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


#Telecommand packet structure in YAML
$telecmdpacket = {'name' => 'TelecommandWholePacket',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
                                              'has'  => [ { 'name' => 'VersionNumber',
                                                            'reprsize' => 3,
                                                            'defval' => 2
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
#                                              'reprsize'  => 16,
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
                                              'defval' => 512
                                            }
                                          ]
                              }, 
                              { 'name'  => 'PacketDataField',
#                                'reprsize'  => 33,
                                'has'   =>[ { 'name' => 'DataFieldHeader',
#                                              'reprsize' => 24+SRC_ID_SZ+SPARE_SZ,
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
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 6,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', #used for padding, see page: 45
                                              'reprsize' => PCKT_PERCTL_SZ,
                                              'defval' => 3
                                            }
                                          ]
                              }
                            ]
}#telecommand packet ends here
