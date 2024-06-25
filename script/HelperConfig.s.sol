// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    function getProposalNames() public pure returns (string[] memory) {
        string[] memory proposalNames = new string[](3);
        proposalNames[0] = "Proposal A";
        proposalNames[1] = "Proposal B";
        proposalNames[2] = "Proposal C";
        return proposalNames;
    }
}
