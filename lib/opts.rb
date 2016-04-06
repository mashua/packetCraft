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

require 'optparse'

#options are in a hash with :keys.
#Keys are ruby symbols.
#The following options are currently supported:
#i)   :serialport --> is the serial port used for transmission, eg: /dev/ttyUSB0|COM1
#ii)  :bytestuff --> true, or false, self-explanatory.
#iii) :tx --> is the mode to transmit the packets. 'bin' transmits binary.
#                                                  'ascii' transmits text.
#iv)  :loadsource --> is the source for packet loading.

$cmdlnoptions = {}

def ParseOptions()  
  option_parser = OptionParser.new{ |opts|
    
    opts.on("-s","--serial-port <serial port>","\n\tMandatory argument. Give:"\
            " /dev/ttyUSB*, or COM*, where '*' is a number to designate the"\
            " serial port to transmit on.")\
    { |port|
      $cmdlnoptions[:serialport] = port;
    }
    
    opts.on("-b", "--byte-stuff <on|off>","\n\tMandatory argument. Turn byte (octet) stuffing on or off."\
            " Applicable only when transmiting on serial ports. By default, turned on.")\
    { |onoff|
      if onoff=='on'
        $cmdlnoptions[:bytestuff]= true; 
      else
        $cmdlnoptions[:bytestuff]= false;
     end
    }
    
    opts.on("-t", "--tx-mode <bin|ascii>","\n\tMandatory argument. Set the mode to use."\
            " 'bin' for binary transmition, 'ascii' for text transmition. "\
            " Applicable only when transmiting on serial ports. By default, binary is selected."\
            " Currently setting this has no effect, only binary is supported.")\
    { |mode|
      if mode=='bin'
        $cmdlnoptions[:tx]= mode;        
      elsif mode =='ascii'
        $cmdlnoptions[:tx]= mode;        
      end
    }
    
    opts.on("-l", "--load-source <disk|file>","\n\tMandatory argument. Set from where the packets will be loaded."\
            " 'disk' to load packets from .yml files under #{File.dirname(__FILE__)}/packets/load/ directory. "\
            " 'file' to load files from CCSDS_203.0-B-2.rb file."\
            " if you don't specify the option, 'disk' will be used.")\
    { |source|
      if source=='disk'
        $cmdlnoptions[:loadsource]= source;        
      elsif source =='file'
        $cmdlnoptions[:loadsource]= source;        
      end
    }
    
    opts.on("-h", "--help", "Prints this help") {
           puts opts
           exit(0);
    }
  }
  option_parser.parse!
   
  if $cmdlnoptions.empty?
    printf("No arguments given, using defaults. (see help with '-h' or '--help', for valid options)\n");
  end
  
  printf("Executing with the following options:\n");
    
  if $cmdlnoptions.has_key?(:serialport)
    printf("--Serial port to be used for transmission is: #{$cmdlnoptions[:serialport]} (if exists)\n");
  else
    $cmdlnoptions[:serialport]="/dev/ttyUSB0";
    printf("-- USING DEFAULT: Serial port to be used for transmission is: #{$cmdlnoptions[:serialport]} (if exists)\n");
  end
    
  if $cmdlnoptions.has_key?(:bytestuff);
    printf("--Byte stuffing is turned #{$cmdlnoptions[:bytestuff]?"on":"off"}\n");
  else
    $cmdlnoptions[:bytestuff]=true;
    printf("-- USING DEFAULT: Byte stuffing is turned on\n");
  end
  
  if $cmdlnoptions.has_key?(:loadsource)
    printf("--Loading packets from: #{$cmdlnoptions[:loadsource]}\n");
  else
    $cmdlnoptions[:loadsource]="disk";
    printf("-- USING DEFAULT: Packets loaded from: #{$cmdlnoptions[:loadsource]}\n");
  end
    
  if $cmdlnoptions.has_key?(:tx)
    printf("--Transmit in binary format\n");
  else
    $cmdlnoptions[:tx]="bin";
    printf("-- USING DEFAULT: Transmit in binary format\n");
  end
    
  end