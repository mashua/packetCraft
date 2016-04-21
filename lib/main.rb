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
require 'thread'
require 'serialport'
#require 'rubyserial'

require_relative 'opts'
#include Curses
require_relative 'craft'
require_relative 'CCSDSTCTMServer'
#require_relative 'testCCSDSClient'
require_relative 'HelpThreads'

$mutex_obj = Mutex.new();
#$serial_line_queue = Queue.new();
#$server_queue = Queue.new();

#handles TC from client,--> to server,--> to serial
$server_to_serial_q = Queue.new();

#hadles TM from serial,--> to server,--> to client
$serial_to_server_q = Queue.new();

#handles yamled responses to client
$server_to_client_q = Queue.new();

$serial_pq ;
$server_obj ;
$test_client ;

ParseOptions();

ClaimSerialPort( $cmdlnoptions[:serialport]);

l_t = return_serial_listen_thread(nil);
#lt.run();
slc_t = return_slice_thread();
#st.run();
#ccsds_t = return_ccsds_server_thread();

server_t = CCSDSTCTMServer.new( "localhost");


#$test_client = CCSDSClient.new( TCPSocket.open( "localhost", 2000 ) );

#sleep(0.1);
printf("\n---Loaded #{$pckCount} packets---\n");
PrintBasicMenu();

while inp = gets
  ParseMainInput(inp);
end

server_t.l_t.join();
server_t.slc_t.join();
#server_t.join();