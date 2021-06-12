// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

//factory
contract CreateCampaigns {
    address[] public campaigns;
    event CampaignCreated(
        address campaignAddress,
        uint256 rewardunit,
        uint256 endate
    );

    function createCampaign(uint256 rewardunit, uint256 endate) public payable {
        address newCampaign = (address)(new Campaign(rewardunit, endate));
        campaigns.push(newCampaign);
        payable(newCampaign).transfer(msg.value);
        // emit CampaignCreated(address(newCampaign), rewardunit, endate);
    }
}

contract Campaign is Ownable {
    event Deposited(uint256 amount);
    event Withdrawn(address indexed claim, uint256 payoutAmount);
    uint256 public rewardunit = 0; ///in this case the reward amount will be in WEI? amount of tokens to award out
    //how would this rewardunit work with different tokens?
    uint256 public startdate = block.timestamp;
    uint256 public endate = 0;
    uint256 public contractBalance;

    // uint256 public contractBalance = address(this).balance;
    constructor(uint256 _rewardunit, uint256 _endate) payable {
        // msg.sender = owner;
        // owner = msg.sender;
        require(msg.value > 0, "Please deposit more than 0");

        rewardunit = _rewardunit;
        endate = _endate;
        deposit(msg.value);
    }

    //claimee struct claimees wallet address, transaction hash, yes or no (bool)
    //creating a mapping of claimees, users in this mapping are already verfiied
    struct claimer {
        address claimee;
        uint256 transaction;
        //whether or not the claimer has previously claimed
        bool claimed;
    }
    mapping(address => claimer) public claimees;

    //campapign struct campaign ID, contract address of the campapign, amount of payout
    function deposit(uint256 _amount) public payable {
        contractBalance = contractBalance + _amount;

        emit Deposited(_amount);
    }

    function payout(bool _verification, uint256 _transaction) public {
        // Check enough balance available, otherwise just return balance
        // claimer storage Claimer = claimees[msg.sender];
        claimer storage Claimer = claimees[msg.sender];
        claimees[msg.sender] = claimer(msg.sender, _transaction, false);

        require(
            _verification == true && Claimer.claimed == false,
            "please complete the tasks to claim the rewards for this challenge."
        );
        claimees[msg.sender].claimed = true;

        // claimees[msg.sender] = claimer(msg.sender, _transaction, true);
        payable(msg.sender).transfer(rewardunit);
        contractBalance = contractBalance - rewardunit;
        //emit reward claimed event here
        emit Withdrawn(msg.sender, rewardunit);
    }

    function endCampaign() public onlyOwner {
        //end campaign and withdraw funds if they are funds left after the duration of campaign ended.
        if (contractBalance > 0 && block.timestamp >= endate) {
            payable(msg.sender).transfer(contractBalance); ///check the synatx
            contractZero();
        }
        //end campaign if the funds ran out before the campaign ends.
    }

    function contractZero() public {
        if (contractBalance == 0) {
            endate = block.timestamp;
        }
    }
}
