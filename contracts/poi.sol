// just pseudocode to start with

contract owned {
    address owner;
    function owned() { owner = msg.sender; }
    function transfer(address to) onlyowner returns (bool success){
        owner = to;
        return true;
    }
    
    modifier onlyowner { if (msg.sender == owner) _ }
}

contract mortal is owned {
    function kill() onlyowner returns (bool){
        suicide(owner);
        return true;
    }
}

contract POI is mortal {
    function POI(address[] members){
        
    }
}

contract POIRoot {
    
  struct Standing {
      bool exists;
      uint rating;
      address currentPOI;
  }    

  uint genesis;
  uint public periodInBlocks = 172800;
  mapping (address => uint) public standing;
  
  function poiRoot () {
    genesis = block.number;   
  }
  
  function register () returns (bool success) {
      standings[msg.sender] = Standing(true, 0, addres(0));
  }
  
  function newPOIInstance() {
      POI poi = new POI([]);
  }
  
  function checkIn () returns (bool success) {
      return false;
  }
  
}
