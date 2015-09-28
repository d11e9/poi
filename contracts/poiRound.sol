
// more efficient (gas cost) grouping 

contract POIRound {
    
    struct Group {
        uint numUsers;
    }
    
    struct User {
        uint groupNumber;
        uint validations;
        bool registered;
    }
    
    mapping (uint => Group) public groups;
    mapping (address => User) public users;
    
    bytes32 entropy;
    uint public numGroups;
    uint public numRegisteredUsers;
    uint public genesisBlock;
    uint public roundLengthInBlocks;
    uint public registrationTimeInBlocks;
    uint public assignmentWindowInBlocks;
    uint public validationWindowInBlocks;
    
    function POIRound() {
        numGroups = 1;
        genesisBlock = block.number;
        roundLengthInBlocks = 30 * 1000 * 1000;
        registrationTimeInBlocks = 10 * 1000;
        assignmentWindowInBlocks = 5 * 1000;
        validationWindowInBlocks = 3 * 1000;
    }
    
    function register () returns(uint groupNum){
        if ((block.number < genesisBlock + registrationTimeInBlocks)
        && (!users[msg.sender].registered)) {
            users[msg.sender].registered = true;
            numRegisteredUsers++;
        }
    }
    
    function assignGroup () returns(uint groupNum) {
        if ((block.number > genesisBlock + registrationTimeInBlocks)
        && (block.number < genesisBlock + registrationTimeInBlocks + assignmentWindowInBlocks)
        && (users[msg.sender].registered)
        && (users[msg.sender].groupNumber == 0)) {
            // TODO: now that we have an assignment window, dont assign in order
            if (groups[numGroups].numUsers == 5) { numGroups++; }
            users[msg.sender].groupNumber = numGroups;
            groups[numGroups].numUsers++;
            return numGroups;
        }
    }
    
    function verify () returns(bool success){
        if ((block.number > genesisBlock + registrationTimeInBlocks + assignmentWindowInBlocks) 
        && (block.number < genesisBlock + registrationTimeInBlocks + assignmentWindowInBlocks + validationWindowInBlocks) 
        && (users[msg.sender].groupNumber != 0)) {
            // TODO: verify
        }
    }
}
