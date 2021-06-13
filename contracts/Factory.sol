// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Campaign is Ownable {
    event Deposited(uint256 amount);
    event Withdrawn(address indexed claim, uint256 payoutAmount);
    uint256 public startdate = block.timestamp;
    uint256 public endate = 0;
    uint256 public contractBalance;

      constructor(uint256 _endate) payable {
        // msg.sender = owner;
        // owner = msg.sender;
        require(msg.value > 0, "Please deposit more than 0");

        endate = _endate;
        deposit(msg.value);
    }

    //claimee struct claimees wallet address, transaction hash, yes or no (bool)
    //creating a mapping of claimees, users in this mapping are already verfiied
    struct claimer {
        address claimee;
        //whether or not the claimer has previously claimed
        bool claimed;
    }
    mapping(address => claimer) public claimees;

    //campapign struct campaign ID, contract address of the campapign, amount of payout
    function deposit(uint256 _amount) public payable {
        contractBalance = contractBalance + _amount;

        emit Deposited(_amount);
    }
    function payout(bool _verification, address payee, uint256 amount) public payable {
        // Check enough balance available, otherwise just return balance
        // claimer storage Claimer = claimees[msg.sender];
        claimer storage Claimer = claimees[payee];
        claimees[payee] = claimer(payee, false);

        require(
            _verification == true && Claimer.claimed == false,
            "please complete the tasks to claim the rewards for this challenge."
        );
        claimees[payee].claimed = true;

        // claimees[msg.sender] = claimer(msg.sender, _transaction, true);
        
        require(address(this).balance > amount, "Contract underfunded");
        payable(payee).transfer(amount);
        
        contractBalance = contractBalance - amount;
        //emit reward claimed event here
        emit Withdrawn(payee, amount);
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
