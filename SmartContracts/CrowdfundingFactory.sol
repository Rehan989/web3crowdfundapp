// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Crowdfunding} from "./Crowdfunding.sol";

/// @title CrowdfundingFactory - A factory contract for creating crowdfunding campaigns
/// @notice This contract allows users to create and manage multiple crowdfunding campaigns
contract CrowdfundingFactory {
    // Contract owner address who can pause/unpause the factory
    address public owner;
    
    // Flag to pause creation of new campaigns
    bool public paused;
    
    // Structure to store campaign details
    struct Campaign {
        address campaignAddress;    // Address of deployed campaign contract
        address owner;             // Creator of the campaign
        string name;              // Name of the campaign
        uint256 creationTime;     // Timestamp when campaign was created
    }
    
    // Array to store all campaigns created through this factory
    Campaign[] public campaigns;
    
    // Mapping of user address to their created campaigns
    mapping(address => Campaign[]) public userCampaigns;
    
    // Ensures function caller is the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner.");
        _;
    }
    
    // Prevents function execution when contract is paused
    modifier notPaused() {
        require(!paused, "Factory is paused");
        _;
    }
    
    // Sets deployer as contract owner
    constructor() {
        owner = msg.sender;
    }
    
    /// @notice Creates a new crowdfunding campaign
    /// @param _name Campaign name
    /// @param _description Campaign description
    /// @param _goal Funding goal in wei
    /// @param _durationInDays Campaign duration in days
    function createCampaign(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationInDays
    ) external notPaused {
        // Deploy new campaign contract
        Crowdfunding newCampaign = new Crowdfunding(
            msg.sender,
            _name,
            _description,
            _goal,
            _durationInDays
        );
        
        // Store campaign details
        address campaignAddress = address(newCampaign);
        Campaign memory campaign = Campaign({
            campaignAddress: campaignAddress,
            owner: msg.sender,
            name: _name,
            creationTime: block.timestamp
        });
        
        // Add to global and user-specific campaign lists
        campaigns.push(campaign);
        userCampaigns[msg.sender].push(campaign);
    }
    
    /// @notice Retrieves all campaigns created by a specific user
    /// @param _user Address of the user
    /// @return Array of campaigns created by the user
    function getUserCampaigns(address _user) external view returns (Campaign[] memory) {
        return userCampaigns[_user];
    }
    
    /// @notice Retrieves all campaigns created through this factory
    /// @return Array of all campaigns
    function getAllCampaigns() external view returns (Campaign[] memory) {
        return campaigns;
    }
    
    /// @notice Toggles the pause state of the factory
    /// @dev Only callable by contract owner
    function togglePause() external onlyOwner {
        paused = !paused;
    }
}