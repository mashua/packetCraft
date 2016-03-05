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

#$telecmdpackets = YLoadTelecmdPacketFFile();

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
  $indPacketsBinStrArray[$pckCount].compact!;
  $pckCount=$pckCount+1;
}

#prepare the whole packet binary array
$totalPacketsBinStrArray.each { |elem|
  elem.chars { |bit| #each element its a bit string
    $totalPacketsBinArray.push( bit.to_i );
  }
}

#prepare the individual packets binary arrays
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
