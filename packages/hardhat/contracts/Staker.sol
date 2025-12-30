// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;
    bool public exampleExternalContractCompleted = false;
    modifier notCompleted() {
        require(!exampleExternalContractCompleted, "Challenge Already Completed!");
        _;
    }

    mapping ( address => uint256 ) public balances;

    uint256 public constant threshold = 1 ether;

    uint256 public deadline = block.timestamp + 72 hours;

    bool public openForWithdraw = false;

    event Stake(address indexed sender, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
    function stake() public payable notCompleted {
        require(block.timestamp < deadline, "Deadline has passed");

        balances[msg.sender] += msg.value;

        emit Stake(msg.sender, msg.value);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
    function execute() public notCompleted {
        require(block.timestamp >= deadline, "Deadline is not here yet");

        if (address(this).balance >= threshold) {
            exampleExternalContract.complete{value: address(this).balance}();
        } else {
            openForWithdraw = true;
        }
    }


    // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
    function withdraw() public {
        require(openForWithdraw == true, "withdraw is not allowed");

        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "insufficient balance");

        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: userBalance}("");

        require(sent, "Failed to send ether");
    }

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) return 0;
        
        return deadline - block.timestamp;
    }

    // Add the `receive()` special function that receives eth and calls stake()
    receive() external payable {
        stake();
    }
}
