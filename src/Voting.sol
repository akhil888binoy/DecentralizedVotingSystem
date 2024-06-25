// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {
    address private chairperson;

    struct Proposal {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint8 vote;
    }

    mapping(address => Voter) addressToVoter;
    Proposal[] public proposals;

    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    function registerNewVoter(address voter) external {
        require(msg.sender == chairperson, "Only chairperson can register voter");
        require(!addressToVoter[voter].isRegistered, "Voter is already Registered");
        addressToVoter[voter] = Voter({isRegistered: true, hasVoted: false, vote: 0});
    }

    function vote(uint8 proposalIndex) external {
        require(addressToVoter[msg.sender].isRegistered, "Voter is not Registered");
        require(!addressToVoter[msg.sender].hasVoted, "Voter already voted");
        require(proposalIndex < proposals.length, "Invalid proposal index");

        addressToVoter[msg.sender].hasVoted = true;
        addressToVoter[msg.sender].vote = proposalIndex;
        proposals[proposalIndex].voteCount += 1;
    }

    function winningProposal() public view returns (uint8) {
        uint256 highestVoteCount = 0; // Initialize the highest vote count
        uint8 winningProposalIndex = 0; // Initialize the winning proposal index
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > highestVoteCount) {
                highestVoteCount = proposals[i].voteCount;
                winningProposalIndex = uint8(i);
            }
        }
        return winningProposalIndex;
    }

    function WinnerName() external view returns (string memory) {
        uint8 winningProposalIndex = winningProposal();
        string memory winnerName = proposals[winningProposalIndex].name;
        return winnerName;
    }

    /////////////////////////
    ///Getter Functions ////
    ///////////////////////

    function getChairperson() external view returns (address) {
        return chairperson;
    }

    function getAddressToVoter(address voteraddress) external view returns (Voter memory) {
        return addressToVoter[voteraddress];
    }

    function getProposalVoteCount(uint256 proposalIndex) external view returns (uint256) {
        require(proposalIndex < proposals.length, "Invalid proposal index");
        return proposals[proposalIndex].voteCount;
    }
}
