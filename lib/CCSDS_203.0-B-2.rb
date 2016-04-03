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
 	
  #PacketHeader
PCKT_HEADER_SZ  = 48;
	#Packet ID
PCKT_ID_SZ      = 16;
PCKT_VER_NUM_SZ = 3;
PCKT_TYPE_SZ    = 1;
PCKT_DFHF_SZ    = 1;	#packet DATA FIELD HEADER FLAG
PCKT_APID_SZ    = 11; 
	#Packet Sequence control
PCKT_SEQ_CTRL_SZ=16;
PCKT_SEQ_FL_SZ  = 2;
PCKT_SEQ_CNT_SZ = 14;
	#Packet Length
PCKT_LGTH_SZ    = 16;
  #Packet Data Field
PCKT_DFH_SZ = rand(50)
PCKT_APPDT_SZ = rand(4091) 
PCKT_SPR_SZ     = 0
PCKT_PERCTL_SZ  = 16	
	#Packet Data Field Header
PCKT_DATA_FIELD_HEADER_SZ = 32
CCSDS_SEC_HDR_FLG_SZ  = 1;
TC_PCK_PUS_VER_NUM_SZ = 3;
ACK_SZ = 4;
SRVC_TYPE_SZ  = 8;
SRVC_STYPE_SZ = 8;
SRC_ID_SZ = 8
SPARE_SZ  = 0


#Telecommand packet structure in Array of Hashes
$telecmdpackets = [{'name' => 'TestServicePacket',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 17
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 2, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                # then you must declare their multitude on the 'reprsize' field.
                                                                # if you enter an array of values, then just don't put zero, if you leave it
                                                                # zero, the field will be ignored and you'll end up with no payload on the message. 
#                                              'defval' => 50999
#                                              'defval' => 0b0000000100000000000000000000000000001000    #enter the packet payload here (binary or decimal values, for the moment)
                                              'defval' => []
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages.
                                          ]
                              }
                            ]},
                  {'name' => 'TestServicePacketOpenBlue',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 8
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 40, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                # then you must declare their multitude on the 'reprsize' field.
                                                                # if you enter an array of values, then just don't put zero, if you leave it
                                                                # zero, the field will be ignored and you'll end up with no payload on the message. 
#                                              'defval' => 50999
#                                              'defval' => 0b0000000100000000000000000000000000001000    #enter the packet payload here (binary or decimal values, for the moment)
                                              'defval' => [1,0,0,0,15]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages.
                                          ]
                              }
                            ]},
                  {'name' => 'TestServicePacketCloseBlue',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 8
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 1
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 40, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                # then you must declare their multitude on the 'reprsize' field.
                                                                # if you enter an array of values, then just don't put zero, if you leave it
                                                                # zero, the field will be ignored and you'll end up with no payload on the message. 
#                                              'defval' => 50999
                                              'defval' => [0,0,0,0,15]    #enter the packet payload here (binary or decimal values, for the moment)
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            } 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketLightUpOrangeLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,10,0,33, 24,1,192,185,0,10,16,8,1,6,1,0,0,0,13,0,121]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketLightUpRedLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,15,0,33, 24,1,192,185,0,10,16,8,1,6,1,0,0,0,14,0,122]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketLightUpGreenLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,20,0,33, 24,1,192,185,0,10,16,8,1,6,1,0,0,0,12,0,120]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketLightUpBlueLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,25,0,33, 24,1,192,185,0,10,16,8,1,6,1,0,0,0,15,0,123]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketSwitchOffOrangeLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,30,0,33, 24,1,192,185,0,10,16,8,1,6,0,0,0,0,13,0,120]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketSwitchOffRedLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,35,0,33, 24,1,192,185,0,10,16,8,1,6,0,0,0,0,14,0,123]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketSwitchOffGreenLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,40,0,33, 24,1,192,185,0,10,16,8,1,6,0,0,0,0,12,0,121]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  },
                  {'name' => 'SchedulePacketSwitchOffBlueLed',
#                  'reprsize' => 65542, #page: 44, max packet octets
                  'has' => [ {  'name'  => 'PacketHeader',
#                                'reprsize'  => 48,
                                'has'   =>[ { 'name' => 'PacketID',
#                                              'reprsize' => 16,
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
                                                            'defval' => 1
                                                          }
                                                        ]
                                            },
                                            { 'name'  => 'PacketSequenceControl',
#                                              'reprsize'  => 16,
                                              'has' => [ {  'name' => 'SequenceFlags',
                                                            'reprsize' => 2,
                                                            'defval' => 3 #stand-alone packet
                                                          },
                                                          { 'name' => 'SequenceCount',
                                                            'reprsize' => 14,
                                                            'defval' => 185 #packet sequence number
                                                          }                                                
                                                       ]
                                            },
                                            { 'name'  => 'PacketLength', #packet length in octet value (defval) is: 
                                                                         #      (packetdatafieldheader ((32bits)+
                                                                         #      PacketErrorCtrl (16bits)+
                                                                         #      Application Data (n bits)-8) / 8
                                              'reprsize'  => 16,
                                              'defval' => 66             # this value will be calculated dynamicaly at-runtime.
                                                                         # just put a value here, but zero.
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
                                                            'defval' => 0 #see note on page: 45
                                                          },
                                                          { 'name' => 'Service Type', #which service this telecommand is related
                                                            'reprsize' => 8,
                                                            'defval' => 11
                                                          },
                                                          { 'name' => 'Service Subtype',
                                                            'reprsize' => 8,
                                                            'defval' => 4
                                                          },
                                                          { 'name' => 'SourceID',
                                                            'reprsize' => SRC_ID_SZ,
                                                            'defval' => 6
                                                          },
                                                          { 'name' => 'Spare',
                                                            'reprsize' => SPARE_SZ,
                                                            'defval' => 0
                                                          }
                                                         ]
                                            },
                                            { 'name' => 'ApplicationData',
                                              'reprsize' => 232, # if you enter binary values at the 'defval' field in the form of 0b001110101..., 
                                                                 # then you must declare their multitude on the 'reprsize' field.
                                                                 # if you enter an array of values, then just don't put zero, if you leave it
                                                                 # zero, the field will be ignored and you'll end up with no payload on the message.
                                              #'defval' => 0b0000000100000001000000000000000000000001000001000010011110111100100001101010101000000011111001110001100000000001110000001011100100000000000010100001000000001000000000010000011000000001000000000000000000000000000010000000000001111100 #0000000100000000000000000000000000001000
                                              'defval' => [1,1,0,0,1,4,0,0,0,45,0,33, 24,1,192,185,0,10,16,8,1,6,0,0,0,0,15,0,122]
                                            },
                                            { 'name' => 'Spare', #used for padding, see page: 45
                                              'reprsize' => 0,
                                              'defval' => PCKT_SPR_SZ
                                            },
                                            { 'name' => 'PacketErrorControl', 
                                              'reprsize' => PCKT_PERCTL_SZ, #16 bits for packet error control.
                                              'defval' => 5                 #this field will be calculated on packet load-time 
                                            }                               #as of an XOR operation, used as CRC(8) for the messages. 
                                          ]
                              }
                            ]
                  }
]#telecommand packet array ends here