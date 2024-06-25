// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployVoting} from "../../script/DeployVoting.s.sol";
import {Voting} from "../../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;
    address USER = makeAddr("user");
    uint256 constant STARTINGBALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        DeployVoting deployVoting = new DeployVoting();
        voting = deployVoting.run();
        vm.deal(USER, STARTINGBALANCE);
    }

    function testChairperson() public {
        assertEq(voting.getChairperson(), msg.sender);
    }

    function testRegistrationFailedOnlyOwner() public {
        vm.prank(USER);
        vm.expectRevert();
        voting.registerNewVoter(USER);
    }

    function testRegisterVoter() public {
        address voter = USER;
        vm.prank(msg.sender);
        voting.registerNewVoter(voter);
        Voting.Voter memory voterData = voting.getAddressToVoter(voter);
        bool isRegistered = voterData.isRegistered;
        assertTrue(isRegistered);
    }

    function testOnlyRegisteredVoter() public {
        // Confirm that only registered voters can vote.
        vm.prank(USER);
        vm.expectRevert();
        voting.vote(0);
    }

    function testVote() public {
        address voter = USER;
        vm.prank(msg.sender);
        voting.registerNewVoter(voter);
        vm.prank(voter); // Simulate call from registered voter
        voting.vote(0); // Vote for Proposal A
        Voting.Voter memory voterData = voting.getAddressToVoter(voter);
        uint8 vote = voterData.vote;
        assertEq(vote, 0);
        uint256 voteCount = voting.getProposalVoteCount(0);
        assertEq(voteCount, 1);
    }

    function testWinningProposals() public {
        address voter1 = USER;
        address voter2 = address(0x456);
        vm.prank(msg.sender);
        voting.registerNewVoter(voter1);
        vm.prank(msg.sender);
        voting.registerNewVoter(voter2);
        vm.prank(voter1);
        voting.vote(0);
        vm.prank(voter2);
        voting.vote(0);
        assertEq(voting.winningProposal(), 0);
    }

    function testcheckWinnerName() public {
        address voter1 = USER;
        address voter2 = address(0x456);
        vm.prank(msg.sender);
        voting.registerNewVoter(voter1);
        vm.prank(msg.sender);
        voting.registerNewVoter(voter2);
        vm.prank(voter1);
        voting.vote(0);
        vm.prank(voter2);
        voting.vote(1);
        assertEq(voting.WinnerName(), "Proposal A");
    }
}
