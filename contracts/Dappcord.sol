// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dappcord is ERC721 {
    address public owner;
    uint256 public totalChannels;
    uint256 public totalSupply;

    mapping(uint256 => Channel) public channels;
    mapping(uint256 => mapping(address => bool)) public hasJoined;

    modifier mustBeOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Channel {
        uint256 id;
        string name;
        uint256 cost;
    }

    constructor(string memory _name, string memory _symbol) 
    ERC721(_name, _symbol) {
        owner = msg.sender;

    }

    function mint(uint256 _id) public payable {
        require(_id != 0, "Channel ID must not be 0");
        require(_id <= totalChannels, "Channel ID is invalid (> # channels)");
        require( hasJoined[_id][msg.sender] == false , "User is already subscribed");
        require( msg.value >= channels[_id].cost, "Insufficient value");

        totalSupply++;
        _safeMint(msg.sender, totalSupply);

        hasJoined[totalSupply][msg.sender] = true;
    }

    function createChannel(string memory _name, uint256 _cost)
    public mustBeOwner() {
        totalChannels++;
        channels[totalChannels] = Channel(totalChannels, _name, _cost);
    }

    function getChannel(uint256 _id) public view returns (Channel memory) {
        return channels[_id];
    }

    function withdraw() public mustBeOwner() {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }    
}
