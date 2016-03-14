# packetCraft.
#
# Copyright (C) 2016 by Apostolos D. Masiakos (amasiakos@gmail.com)
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#  *  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#  *  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#---------------------------------------------------------------------------

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
PCKT_APPDT_SZ = rand(4091) 
PCKT_SPR_SZ = rand(50)
PCKT_PERCTL_SZ = 16	
	#Packet Data Field Header
CCSDS_SEC_HDR_FLG_SZ = 1;
TC_PCK_PUS_VER_NUM_SZ = 3;
ACK_SZ = 4;
SRVC_TYPE_SZ = 8;
SRVC_STYPE_SZ = 8;
SRC_ID_SZ = 3
SPARE_SZ =  1 #reprsize TO PAD THE MESSAGE TO ARCHITECTURE SPECIFIC reprsize, optional


#Telecommand packet structure in Array of Hashes
$telecmdpackets = [{'name' => 'TelecommandWholePacket1',
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
                                                            'defval' => 126 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLenght',
                                              'reprsize'  => 16,
                                              'defval' => 125
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
                                                            'defval' => 125
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 55
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
                            ]},
                  {'name' => 'TelecommandWholePacket2',
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
                  },
                  {'name' => 'TelecommandWholePacket3',
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
                  }
]#telecommand packet array ends here

$schedule_packets = [{'name' => 'SchedulePacket1',
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
                                                            'defval' => 126 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLenght',
                                              'reprsize'  => 16,
                                              'defval' => 125
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
                                                            'defval' => 125
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 55
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
                              }]
                          }]
                             
