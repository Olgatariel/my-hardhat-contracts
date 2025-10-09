// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// ----------------------
// Imports
// ----------------------
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
// ----------------------
// Contract
// ----------------------
contract Fundraiser is Ownable, ReentrancyGuard, Pausable {
    struct Campaign {
        uint id;
        string description;
        uint goal;
        uint raised;
        bool completed;
        address payable owner;
    }
    // ----------------------
    // State variables
    // ----------------------

    mapping(uint => Campaign) public campaigns;
    uint public nextId;
    uint public totalRaised;

    //----------------------
    //Error
    //----------------------
    error InvalidGoal();
    error InvalidCampaignId();
    error InvalidDonationAmount();
    error AlreadyCompleted();

    // ----------------------
    // Events
    // ----------------------

    event CampaignCreated(uint indexed id, address indexed owner, uint goal);
    event DonationReceived(uint indexed id, address indexed from, uint amount);

    // ----------------------
    // Functions
    // ----------------------

    function createCampaign(
        string memory _description,
        uint _goal
    ) public whenNotPaused {
        if (_goal == 0) revert InvalidGoal();
        Campaign memory newCampaign = Campaign({
            id: nextId,
            description: _description,
            goal: _goal,
            raised: 0,
            completed: false,
            owner: payable(msg.sender)
        });
        campaigns[nextId] = newCampaign;
        emit CampaignCreated(nextId, msg.sender, _goal);
        nextId++;
    }
    function donate(uint _id) external payable whenNotPaused nonReentrant {
        if (_id >= nextId) revert InvalidCampaignId();
        if (campaigns[_id].completed) revert AlreadyCompleted();
        if (msg.value == 0) revert InvalidDonationAmount();
        campaigns[_id].raised += msg.value;
        totalRaised += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }
}
