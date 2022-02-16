function Decoder(bytes, port) {
    var meta = {};
    meta.dev_type = 'LSE01';
    // Decode an uplink message from a buffer
    // (array) of bytes to an object of fields.
    var value=(bytes[0]<<8 | bytes[1]) & 0x3FFF;
    var bat=value/1000;//Battery,units:V
  
    value=bytes[2]<<8 | bytes[3];
    if(bytes[2] & 0x80) {
      value |= 0xFFFF0000;
    }
    
    var temp_DS18B20=parseFloat((value/10).toFixed(2));//DS18B20,temperature,units:â„ƒ
     
    value=bytes[4]<<8 | bytes[5];
    var water_SOIL=parseFloat((value/100).toFixed(2));//water_SOIL,Humidity,units:%
     
    value=bytes[6]<<8 | bytes[7];
    var temp_SOIL;
    if((value & 0x8000)>>15 === 0)
      temp_SOIL=parseFloat((value/100).toFixed(2));//temp_SOIL,temperature,units:Â°C
    else if((value & 0x8000)>>15 === 1)
      temp_SOIL=parseFloat(((value-0xFFFF)/100).toFixed(2));//temp_SOIL,temperature,units:Â°C
     
    value=bytes[8]<<8 | bytes[9];
    var conduct_SOIL=(value);//conduct_SOIL,conductivity,units:uS/cm
    
    if (temp_DS18B20===0)
      return {
        data: {
          BatV:bat,
          SoilHumid:water_SOIL,
          SoilTemp:temp_SOIL,
          SoilEC:conduct_SOIL
        },
        
        meta: meta
      };
    
    return {
        data : {
          BatV:bat,
          AirTemp:temp_DS18B20,
          SoilHumid:water_SOIL,
          SoilTemp:temp_SOIL,
          SoilEC:conduct_SOIL
        },
        
        meta: meta
      };
  }