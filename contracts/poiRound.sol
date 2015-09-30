contract poi {
    
    uint public numUsers;
    mapping(address => bytes32) public userHash;
    mapping(bytes32 => address) public userAddress;
    mapping(address => uint) public userGroup;
    
    bool debug;
    uint blockNum;
    uint genesisBlock = block.number;
    uint registrationBlock = genesisBlock + 7;
    uint commitmentBlock = registrationBlock + 3;
    uint validityBlock = commitmentBlock + 20;
    
    function blockNumber() returns(uint){ if (debug) { return blockNum; } return block.number; }
    
    function poi(){
        genesisBlock = block.number;
        debug = true;
    }
    
    function register() returns(bool success){
        if ((blockNumber() > registrationBlock) // registation period over
        || (userHash[msg.sender] != bytes32(0))) return; // already registered
        
        bytes32 h = sha3(msg.sender);
        userHash[msg.sender] = h;
        userAddress[h] = msg.sender;
        numUsers++;
        return true;
    }
    
    function commit(uint group) returns(bool success){
        if ((blockNumber() < registrationBlock) // registation period not yet over
        || (blockNumber() > commitmentBlock) // commitment period over
        || (userGroup[msg.sender] != 0)) return; // group already assigned
        
        userGroup[msg.sender] = group;
        return true;
    }
    
    function verify(bytes proof) returns(bool success){
        if ((blockNumber() < commitmentBlock) // commitment period not yet over
        || (blockNumber() > validityBlock) // verification period over
        || (userGroup[msg.sender] == 0)) return;
        
        // TODO :)
        return true;
    }
    
    function _incBlock() { if (debug) blockNum++; }
    function _myGroupHelper() returns(uint group) {
        return userGroup[msg.sender];
    }
    
}
