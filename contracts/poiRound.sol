contract poi {
    
    uint public numUsers;
    mapping(address => bytes32) public userHash;
    mapping(bytes32 => address) public userAddress;
    mapping(address => uint) public userGroup;
    
    bool debug;
    uint public blockNum;
    uint genesisBlock;
    uint registrationPeriodInBlocks = 7;
    uint commitmentPeriodInBlocks = 3;
    uint validityPeriodInBlocks = 20;
    
    function blockNumber() returns(uint){ if (debug) { return blockNum; } return block.number; }
    
    function poi(){
        genesisBlock = block.number;
        debug = true;
    }
    
    function register() returns(bool success){
        if ((blockNumber() > genesisBlock + registrationPeriodInBlocks) // registation period over
        || (userHash[msg.sender] != bytes32(0))) return; // already registered
        
        bytes32 h = sha3(msg.sender);
        userHash[msg.sender] = h;
        userAddress[h] = msg.sender;
        numUsers++;
        return true;
    }
    
    function commit(uint group) returns(bool success){
        if ((blockNumber() < genesisBlock + registrationPeriodInBlocks) // registation period not yet over
        || (blockNumber() > genesisBlock + registrationPeriodInBlocks + commitmentPeriodInBlocks) // commitment period over
        || (userGroup[msg.sender] != 0)) return; // group already assigned
        
        userGroup[msg.sender] = group;
        return true;
    }
    
    function verify(bytes proof) returns(bool success){
        if ((blockNumber() < genesisBlock + registrationPeriodInBlocks + commitmentPeriodInBlocks) // commitment period not yet over
        || (blockNumber() > genesisBlock + registrationPeriodInBlocks + commitmentPeriodInBlocks + validityPeriodInBlocks) // verification period over
        || (userGroup[msg.sender] == 0)) return;
        
        // TODO :)
        return true;
    }
    
    function _incBlock() { if (debug) blockNum++; }
    function _myGroupHelper() returns(uint group) {
        return userGroup[msg.sender];
    }
    
}
