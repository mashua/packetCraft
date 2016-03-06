=*= packetCraft =*=
    _____________
   /\-//+/|\+\\-/\
  //+\/--/-\--\/+\\
  |/\|+//_|_\\+|/\|
  \\+\-\-\-/-/-/+//
   \\/\+\-|-/+/\//
    \\/\_\_/_/\//
     \\/\+|+/\//
      \//\|/\\/
       \/\+/\/
        \\|//
         \+/
          ^

This tool, intends to aid people who develop applications and are in need for
various packet creation schemes.

--Basic Usage: ( tests where made with ruby version: 2.2.4p230,
newer | older versions might work)

(a) As of now the usage is: 
    
    cd in the repo directory packetCraft
    run as: ruby ./lib/main.rb --help to see your options.

(b) WARNING: if you want to change a packet's content you have to edit the 
    CCSDS_203.0-B-2.rb file directly, as the packets are loaded directly from
    there at runtime, see the $telecmdpackets global variable.
    The packet.yml file at <repo_location>/packets/ directory has no usage at
    this time.

--Supported packet formats:
(a) Packet schemes as they are specified in the CCSDS 203.0-B-2, published from
The Consultative Committee for Space Data Systems (CCSDS)
(for more info look in: http://public.ccsds.org/).

--To do (in order of necessity)
(a) Add socket packet transmission functionality.
(b) Add more packet schemes.
(c) Add a Graphical User Interface (GUI).
(d) Add support for extra packet serialization formats.


(proudly scripted with the ruby language)  
