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

require 'serialport'
#require 'curses'
#require 'xmlsimple'
require 'yaml'

require_relative 'utils'
require_relative 'CCSDS_203.0-B-2'

$telecmdpackets = Array.new();

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
      if theHash['reprsize'] == 0
        #don't add anything
      else
          if theHash['defval'].class == Array
            temp_ar = decByteArraytoBits(theHash['defval']);
            temp_ar.each{ |elem|
              $totalPacketsBinStrArray[$pos] =  elem;
              $indPacketsBinStrArray[level][$pos] = elem;
              $pos+=1;
            }
            break; #don't ask why, just break.
          else
            $totalPacketsBinStrArray[$pos] = sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
            $indPacketsBinStrArray[level][$pos]=sprintf("%0#{theHash['reprsize']}b", theHash['defval']);
            $pos+=1;
            break; #don't ask why, just break.
          end
      end
    end
  }
};

entries = Dir.entries( File.dirname(__FILE__).concat("/packets/load/"));
entries.delete('.');
entries.delete('..');
entries.sort_by! { |a| a[0] }

entries.each_with_index { |item,index|
#  unless item == '.' || item == '..'
    $telecmdpackets << YLoadTelecmdPacketFFile( File.dirname(__FILE__).concat("/packets/load/") , item);
#  end
}

$telecmdpackets.each { |innerHash|
  $indPacketsBinStrArray<<Array.new();#new array to hold reference to the new binary string representation of the packet.
  $indPacketsStrArray[$pckCount] = $crosspacketBlock.call( innerHash,$pckCount );
  $indPacketsBinStrArray[$pckCount].compact!;
  $pckCount=$pckCount+1;
}

#prepare the whole packet binary array
$totalPacketsBinStrArray.each { |elem|
  elem.chars { |bit| #each element its a bit string
    $totalPacketsBinArray.push( bit.to_i );
  }
}

#prepare the individual packet binary arrays
$indPacketsBinStrArray.each_with_index { |elem,index| #elem is an array with string elements,eg: "0101101"
 $indPacketsBinArray<<Array.new();
  elem.each { |innerArray| #each element its a bit string array
    innerArray.chars { |bit|
      $indPacketsBinArray[index].push( bit.to_i );
    }
  }
}

#calculate each packet PacketLength field and replace it in the packet array.
#(this function is specific to ECSS packet scheme handling, and it should be removed (at least from here) in the future).
#count in decimal the number of bits after the DataFieldHeader (witch is 32 bits) and before PacketErrorControl (witch is 16 bits).
#we are not using the spare bit, so we count only application data bits.
#convert this (decimal) number in a array (of 16 bits in length) with bit elements,
#and finally replace the PacketLength value into the final array.
$indPacketsBinArray.each { |packetArray|
#print("\n");
#print packetArray.length;
#print("\n");
#print("before packet len array:\n#{packetArray.values_at(32..47)}\n")
#print packetArray[((PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)..(PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)+15)]
#print("\n");
#print packetArray[ (PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ+PCKT_LGTH_SZ),(PCKT_DATA_FIELD_HEADER_SZ) ]
#print packetArray[ (PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ+PCKT_LGTH_SZ+PCKT_DATA_FIELD_HEADER_SZ+40),(16) ]
#print("\n");
  dataPayloadArray = packetArray.values_at( (PCKT_HEADER_SZ+PCKT_DATA_FIELD_HEADER_SZ)..(packetArray.length-17) );
#  print dataPayloadArray;
#  print("\n");
#  print dataPayloadArray.length;
#  print("\n");
  dataPayloadArrayLength = ((dataPayloadArray.length+PCKT_DATA_FIELD_HEADER_SZ+PCKT_PERCTL_SZ)-8)/8; #in octet, page 44 (C-1(octet))
  packetLengthArray = sprintf("%016b",dataPayloadArrayLength).split(//).map { |elem| elem.to_i  }
#  print packetLengthArray;
#  print("\n");
  packetArray[((PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)..(PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)+packetLengthArray.length-1)] = packetLengthArray;
#  print packetArray[((PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)..(PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ)+15)]
#  print("\n");
#print("\n");
#print packetArray.length;
#print("\n");
#print("after packet len array: #{packetArray.values_at(32..47)}\n")
}

#calculate each packet CRC
$indPacketsBinArray.each { |packetArray|
#  printf("the array lenght before is:#{packetArray.length}\n");
#  printf("the array contents before is:\n#{packetArray}\n");

#print packetArray[ (PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ+PCKT_LGTH_SZ+PCKT_DATA_FIELD_HEADER_SZ+40),(16) ]
#print("\n");
  crc8 = CRC8(packetArray, 0, packetArray.length-PCKT_PERCTL_SZ );
  #return an array having as elements the CRC's individual bits.
  crc8_array = sprintf("%016b",crc8).split(//).map { |elem| elem.to_i  }
  #replace the last PCKT_PERCTL_SZ bits of the packet bits array with the crc array.
  packetArray[packetArray.length-PCKT_PERCTL_SZ, PCKT_PERCTL_SZ] = crc8_array;

#print packetArray[ (PCKT_ID_SZ+PCKT_SEQ_CTRL_SZ+PCKT_LGTH_SZ+PCKT_DATA_FIELD_HEADER_SZ+40),(16) ]
#print("\n");
#printf("the array contents after is:\n#{packetArray}\n");
#print("\n");
#printf("the array lenght after is:#{packetArray.length}\n");
}