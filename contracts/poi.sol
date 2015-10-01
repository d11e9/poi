contract poi {
    
    bool debug;
    uint blockNum;

    uint groupSize;
    bytes32 entropy;
    
    uint public numUsers;
    mapping(address => bytes32) public userHash;
    //mapping(bytes32 => address) public userAddress;
    mapping(address => uint) public userGroup;

    // max value of a sha3 hash
    bytes32 maxHash = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    enum Phases { Registration, Commitment, Verification } 
    event Registration(bytes32 userHash);
    event Commitment(bytes32 userHash, uint group);
    event Verification(bytes32 userHash);

    Phases phase;
    uint public genesisBlock;
    uint public registrationBlock;
    uint public commitmentBlock;
    uint public validityBlock;
    
    function blockNumber() constant returns(uint){ if (debug) { return blockNum; } return block.number; }
    function numGroups() constant returns(uint){ return numUsers / groupSize;}
    
    function poi(){
        debug = true;
        groupSize = 5;
        entropy = sha3(block.blockhash(block.number));
        genesisBlock = block.number;
        registrationBlock = genesisBlock + 7;
        commitmentBlock = registrationBlock + 3;
        validityBlock = commitmentBlock + 20;
        phase = Phases.Registration;
    }
    
    function register() returns(bool success){
        if ((blockNumber() > registrationBlock) // registation period over
        || (userHash[msg.sender] != bytes32(0))) return; // already registered
        
        // generate a hash for the given user, using previous entropy, 
        // senders address and current blocknumber.
        bytes32 h = sha3(entropy, msg.sender, block.blockhash(block.number));
        entropy = h;
        userHash[msg.sender] = h;
        //userAddress[h] = msg.sender;
        numUsers++;
        Registration(h);
        return true;
    }
    
    function commit() returns(bool success){
        if ((blockNumber() < registrationBlock) // registation period not yet over
        || (blockNumber() > commitmentBlock) // commitment period over
        || (userGroup[msg.sender] != 0)) return; // group already assigned

        phase = Phases.Commitment;
        
        // deterministically assign user to random group (1-indexed)
        // based on number of users, group size and user hash;
        userGroup[msg.sender] = uint(userHash[msg.sender]) / (uint(maxHash) / numGroups()) + 1;
        Commitment(userHash[msg.sender], userGroup[msg.sender]);
        return true;
    }
    
    function verify(bytes32 data, uint8 v, bytes32 r, bytes32 s ) returns(bool success){
        if ((blockNumber() < commitmentBlock) // commitment period not yet over
        || (blockNumber() > validityBlock) // verification period over
        || (userGroup[msg.sender] == 0)) return;

        phase = Phases.Verification;
        
        // TODO :)
        address signer = ecrecover( data, v, r, s);
        // is the proof provided by a user in the same group
        if (userGroup[signer] == userGroup[msg.sender]) {
            Verification(userHash[msg.sender]);
            return true;
        }
    }
    
    function _incBlock() { if (debug) blockNum++; }
    function _myAddressHelper() constant returns(address){ return msg.sender; }
    function _myGroupHelper() constant returns(uint group) {
        return userGroup[msg.sender];
    }
    
}
