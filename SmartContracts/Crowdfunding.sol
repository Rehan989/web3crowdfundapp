// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Crowdfunding - A contract for managing individual crowdfunding campaigns
/// @notice Implements tiered funding, campaign states, and refund functionality
contract Crowdfunding {
    // Campaign details
    string public name;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    address public owner;
    bool public paused;

    // Campaign states: Active (ongoing), Successful (met goal), Failed (expired without meeting goal)
    enum CampaignState { Active, Successful, Failed }
    CampaignState public state;

    // Funding tier structure
    struct Tier {
        string name;      // Name of the reward tier
        uint256 amount;   // Required contribution amount
        uint256 backers;  // Number of backers in this tier
    }

    // Backer information structure
    struct Backer {
        uint256 totalContribution;                // Total amount contributed
        mapping(uint256 => bool) fundedTiers;     // Tracks which tiers the backer has funded
    }

    // Storage for tiers and backers
    Tier[] public tiers;
    mapping(address => Backer) public backers;

    // Access control modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier campaignOpen() {
        require(state == CampaignState.Active, "Campaign is not active.");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused.");
        _;
    }
    
    /// @notice Creates a new crowdfunding campaign
    /// @param _owner Campaign creator address
    /// @param _name Campaign name
    /// @param _description Campaign description
    /// @param _goal Funding target in wei
    /// @param _duratyionInDays Campaign duration
    constructor(
        address _owner,
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _duratyionInDays
    ) {
        name = _name;
        description = _description;
        goal = _goal;
        deadline = block.timestamp + (_duratyionInDays * 1 days);
        owner = _owner;
        state = CampaignState.Active;
    }

    /// @notice Updates campaign state based on current conditions
    function checkAndUpdateCampaignState() internal {
        if(state == CampaignState.Active) {
            if(block.timestamp >= deadline) {
                state = address(this).balance >= goal ? CampaignState.Successful : CampaignState.Failed;            
            } else {
                state = address(this).balance >= goal ? CampaignState.Successful : CampaignState.Active;
            }
        }
    }

    /// @notice Allows backers to fund a specific tier
    /// @param _tierIndex Index of the tier to fund
    function fund(uint256 _tierIndex) public payable campaignOpen notPaused {
        require(_tierIndex < tiers.length, "Invalid tier.");
        require(msg.value == tiers[_tierIndex].amount, "Incorrect amount.");

        tiers[_tierIndex].backers++;
        backers[msg.sender].totalContribution += msg.value;
        backers[msg.sender].fundedTiers[_tierIndex] = true;

        checkAndUpdateCampaignState();
    }

    /// @notice Adds a new funding tier
    /// @param _name Tier name
    /// @param _amount Required contribution amount
    function addTier(
        string memory _name,
        uint256 _amount
    ) public onlyOwner {
        require(_amount > 0, "Amount must be greater than 0.");
        tiers.push(Tier(_name, _amount, 0));
    }

    /// @notice Removes a funding tier
    /// @param _index Index of tier to remove
    function removeTier(uint256 _index) public onlyOwner {
        require(_index < tiers.length, "Tier does not exist.");
        tiers[_index] = tiers[tiers.length -1];
        tiers.pop();
    }

    /// @notice Allows owner to withdraw funds after successful campaign
    function withdraw() public onlyOwner {
        checkAndUpdateCampaignState();
        require(state == CampaignState.Successful, "Campaign not successful.");

        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        payable(owner).transfer(balance);
    }

    /// @notice Returns current contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Allows backers to get refunds if campaign failed
    function refund() public {
        checkAndUpdateCampaignState();
        require(state == CampaignState.Failed, "Refunds not available.");
        uint256 amount = backers[msg.sender].totalContribution;
        require(amount > 0, "No contribution to refund");

        backers[msg.sender].totalContribution = 0;
        payable(msg.sender).transfer(amount);
    }

    /// @notice Checks if an address has funded a specific tier
    function hasFundedTier(address _backer, uint256 _tierIndex) public view returns (bool) {
        return backers[_backer].fundedTiers[_tierIndex];
    }

    /// @notice Returns all funding tiers
    function getTiers() public view returns (Tier[] memory) {
        return tiers;
    }

    /// @notice Toggles pause state of the contract
    function togglePause() public onlyOwner {
        paused = !paused;
    }

    /// @notice Gets current campaign status considering deadline
    function getCampaignStatus() public view returns (CampaignState) {
        if (state == CampaignState.Active && block.timestamp > deadline) {
            return address(this).balance >= goal ? CampaignState.Successful : CampaignState.Failed;
        }
        return state;
    }

    /// @notice Extends campaign deadline
    /// @param _daysToAdd Number of days to add to deadline
    function extendDeadline(uint256 _daysToAdd) public onlyOwner campaignOpen {
        deadline += _daysToAdd * 1 days;
    }
}