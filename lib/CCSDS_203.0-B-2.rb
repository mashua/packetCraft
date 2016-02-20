#CCSDS 203.0-B-2
#Telecommand packet structure in YAML

tree = { name: 'ruby',
         uses: [ 'scripting', 'web', 'testing', 'etc' ]
}

telecmdpacket = { 'name' => 'TelecommandWholePacket',
                  'size' => 65535,
                  'has'  =>  
                        {   'name'  => 'PacketHeader',
                            'size'  => 48,
                            'has'   =>    { 'name' => 'testin'
                                
                                          }
                          
                        }
                      
  
}