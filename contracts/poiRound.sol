
// more efficient (gas cost) grouping 

contract POIRound {
    
    struct Group {
        uint numUsers;
    }
    
    struct User {
        uint groupNumber;
        uint validations;
    }
    
    mapping (uint => Group) public groups;
    mapping (address => User) public users;
    
    uint public numGroups;
    uint public genesisBlock;
    uint public roundLengthInBlocks;
    uint public registrationTimeInBlocks;
    uint public validationWindowInBlocks;
    
    function POIRound() {
        numGroups = 1;
        genesisBlock = block.number;
        roundLengthInBlocks = 30 * 1000 * 1000;
        registrationTimeInBlocks = 10 * 1000;
        validationWindowInBlocks = 3 * 1000;
    }
    
    function register () returns(uint groupNum){
        if ((block.number < genesisBlock + registrationTimeInBlocks)
        && (users[msg.sender].groupNumber == 0)) {
            if (groups[numGroups].numUsers == 5) { numGroups++; }
            users[msg.sender].groupNumber = numGroups;
            groups[numGroups].numUsers++;
            return numGroups;
        }
    }
    
    function verify () returns(bool success){
        if ((block.number > genesisBlock + registrationTimeInBlocks) 
        && (block.number < genesisBlock + registrationTimeInBlocks + validationWindowInBlocks) 
        && (users[msg.sender].groupNumber != 0)) {
            
        }
    }
}
