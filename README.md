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
newer | older versions should ('might') work)

(a) As of now the usage is: 
    
    cd in the repo directory packetCraft
    run as: ruby ./lib/main.rb --help to see your options.

(b) You can specify the packets source with the -l or --load-source option.
    If you specify the 'disk' option, packets will be loaded from './lib/packets/load/' folder.
    (packets that you do not want to load, you can safely cut->paste them into './lib/packets/noload' folder)
    If you specify the 'file' option, packets will be loaded from CCSDS_203.0-B-2.rb file directly.
    
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
