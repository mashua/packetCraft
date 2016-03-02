require 'optparse'

#options are in a hash with :keys.
#Keys are ruby symbols.
#The following options are currently supported:
#i)   :serialport --> is the serial port used for transmission, eg: /dev/ttyUSB0|COM1
#ii)  :bytestuff --> true, or false, self-explanatory.
#iii) :tx --> is the mode to transmit the packets. 'bin' transmits binary.
#                                                  'ascii' transmits text.
$cmdlnoptions = {} #initialy empty options hash.


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
    opts.on("-h", "--help", "Prints this help") do
           puts opts
           exit(0);
         end
    
  }
   option_parser.parse!
   
  if $cmdlnoptions.empty?
    printf("No arguments given, using defaults as: (see help with '-h' or '--help', for valid options)\n");
    printf("--Serial port to be used for transmission is: /dev/ttyUSB0 (if exists)\n");    
    printf("--Byte stuffing is turned on\n");
    printf("--Transmit in binary format\n");
    $cmdlnoptions[:seriaport]="/dev/ttyUSB0";
    $cmdlnoptions[:bytestuff]=true;
    $cmdlnoptions[:tx]="bin";
  else
    printf("Executing with the following options:\n");
    if $cmdlnoptions[:serialport]
      printf("--Serial port to be used for transmission is: #{$cmdlnoptions[:serialport]} (if exists)\n");
    end
    if $cmdlnoptions.has_key?(:bytestuff);
      printf("--Byte stuffing is turned #{$cmdlnoptions[:bytestuff]?"on":"off"}\n");
    else
      $cmdlnoptions[:bytestuff]=true;
#      printf("--Byte stuffing is turned #{$cmdlnoptions[:bytestuff]?"on":"off"}\n");
      printf("--Byte stuffing is turned on\n");
    end
    if $cmdlnoptions[:tx]
      printf("--Transmit in binary format\n");
    else
      $cmdlnoptions[:tx]="bin";
      printf("--Transmit in binary format\n");
    end
    
  end
end