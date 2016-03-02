require 'optparse'

def ParseOptions()
  
  option_parser = OptionParser.new{ |opts|

    # Create a switch
    opts.on("-s","--serial-port <serial port>","Mandatory argument.Give:"\
            " /dev/ttyUSB*, or COM*, where * means a number to designate the"\
            " serial port to transmit on")\
    { |port|
      $cmdlnoptions[:serialport] = true;
      $serialPort=port;
    }

    # Create a flag
    opts.on("-b", "--byte-stuff","Turn byte (octet) stuffing on. Applicable only when transmiting on serial ports"){
      $cmdlnoptions[:bytestuff]= true;
      $BYTESTUFF=true;      
    }
    
  }
   option_parser.parse!
   puts $cmdlnoptions.inspect
end

printf("\n\n");