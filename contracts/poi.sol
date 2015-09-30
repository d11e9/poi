contract poi {
    
    mapping(address => bytes32) public userHash;
    mapping(bytes32 => address) public userAddress;
    mapping(address => uint) public userGroup;

    bytes32 maxHash = sha3(address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
    
    bool debug;
    uint blockNum;
    uint public numUsers;
    uint groupSize;
    uint genesisBlock;
    uint registrationBlock;
    uint commitmentBlock;
    uint validityBlock;
    bytes32 entropy;
    
    function blockNumber() returns(uint){ if (debug) { return blockNum; } return block.number; }
    function numGroups() returns(uint){ return numUsers / groupSize;}
    
    function poi(){
        debug = true;
        groupSize = 5;
        entropy = block.blockhash(block.number);
        genesisBlock = block.number;
        registrationBlock = genesisBlock + 7;
        commitmentBlock = registrationBlock + 3;
        validityBlock = commitmentBlock + 20;
    }
    
    function register() returns(bool success){
        if ((blockNumber() > registrationBlock) // registation period over
        || (userHash[msg.sender] != bytes32(0))) return; // already registered
        
        // generate a hash for the given user, using previous entropy, 
        // senders address and current blocknumber.
        bytes32 h = sha3(entropy, msg.sender, block.blockhash(block.number));
        userHash[msg.sender] = h;
        userAddress[h] = msg.sender;
        numUsers++;
        return true;
    }
    
    function commit() returns(bool success){
        if ((blockNumber() < registrationBlock) // registation period not yet over
        || (blockNumber() > commitmentBlock) // commitment period over
        || (userGroup[msg.sender] != 0)) return; // group already assigned
        
        // deterministically assign user to random group (1-indexed)
        // based on number of users, group size and user hash;
        userGroup[msg.sender] = uint(userHash[msg.sender]) / (uint(maxHash) / numGroups()) + 1;
        return true;
    }
    
    function verify(bytes32 data, uint8 v, bytes32 r, bytes32 s ) returns(bool success){
        if ((blockNumber() < commitmentBlock) // commitment period not yet over
        || (blockNumber() > validityBlock) // verification period over
        || (userGroup[msg.sender] == 0)) return;
        
        // TODO :)
        ecrecover( data, v, r, s);
        return true;
    }
    
    function _incBlock() { if (debug) blockNum++; }
    function _myGroupHelper() returns(uint group) {
        return userGroup[msg.sender];
    }
    
}
