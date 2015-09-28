contract poi {
    
    struct Group {
        address[] participants;
        mapping( address => uint ) proof;
    }
    
    struct Round {
        // maps global participants to a group number within the given round.
        mapping( address => uint ) participants;
        Group[] groups;
    }
    
    Round[] rounds;
    
    uint usersPerGroup = 5;
    uint blocksPerRound = 1337;
    uint genesisBlock = block.number;
    
    // 0-indexed rounds
    uint public currentRound;
    
    // 1-indexed, as group 0 indicates no group assignment.
    uint public currentGroupCount = 1;
    
    // register to participate in the current round, user will be assigned to a group
    function register() returns(uint assignedGroup){
        
        // start a new round if sufficient blocks have elapsed.
        if ((block.number - genesisBlock) / blocksPerRound > currentRound) { currentRound += 1; }
        
        // user can only register once per round.
        if (rounds[currentRound].participants[msg.sender] != 0) return 0;
        
        // if the previous group is full, start a new one
        if (rounds[currentRound].groups[currentGroupCount].participants.length >= usersPerGroup) {
                currentGroupCount += 1;
                rounds[currentRound].groups.length += 1;
        }
        
        rounds[currentRound].groups[currentGroupCount].participants.length += 1;
        rounds[currentRound].groups[currentGroupCount].participants[rounds[currentRound].groups[currentGroupCount].participants.length] = msg.sender;
        rounds[currentRound].participants[msg.sender] = currentGroupCount;
        
        // group id that user has been assigned to, 0 indicates failure.
        return currentGroupCount;
    }
    
    // validate participation in a given round.
    function validate(uint group, string proof, address[] addresses){
        for (var i = 0; i < addresses.length; i++) {
            if (rounds[currentRound].participants[addresses[i]] > 0) {
                rounds[currentRound].groups[group].proof[addresses[i]] += 1;
            }
        }
    }
    
    // check if a user has proven their individuality for the current round.
    function isIndividual(address addr) constant returns(bool) {
        uint group = rounds[currentRound].participants[msg.sender];
        if (group == 0) { return false; }
        uint proof = rounds[currentRound].groups[group].proof[addr];
        return proof >= (usersPerGroup / 2 + 1 );
    }
}
