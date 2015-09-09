contract poi {
    
    struct Group {
        address[] participants;
        uint slotsTaken;
        mapping(bytes32 => uint) proof;
    }
    
    struct Round {
        // maps global participants to a group number
        mapping( address => uint ) participants;
        Group[] groups;
    }
    
    Round[] rounds;
    uint currentRound;
    uint currentGroupCount = 1;
    
    function register() returns(uint success){
        if (rounds[currentRound].participants[msg.sender] != 0) return 0;
        if (rounds[currentRound].groups[currentGroupCount].slotsTaken >= 5) {
                currentGroupCount += 1;
                rounds[currentRound].groups.length += 1;
        }
        rounds[currentRound].groups[currentGroupCount].participants[msg.sender] += 1;
        rounds[currentRound].groups[currentGroupCount].slotsTaken += 1;
        rounds[currentRound].participants[msg.sender] = currentGroupCount;
        return currentGroupCount;
    }
    
    function validate(uint group, string proof, address[] addresses){
        for (var i = 0; i < addresses.length; i++) {
            //rounds[currentRound][group][addr] += 1;
        }
    }
}
