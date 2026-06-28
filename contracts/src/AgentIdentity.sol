// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AgentIdentity
 * @dev A simplified ERC-721 implementation representing the immutable on-chain
 * identity of an AI Agent (GCP BlockTrain Compute Node) under the ERC-8004 concept.
 */
contract AgentIdentity {
    address public owner;
    uint256 private _nextTokenId;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => string) private _tokenURIs;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event AgentRegistered(uint256 indexed tokenId, address indexed nodeOperator, string metadataURI);

    constructor() {
        owner = msg.sender;
        _nextTokenId = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address nodeOwner = _owners[tokenId];
        require(nodeOwner != address(0), "Invalid token ID");
        return nodeOwner;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), "Invalid token ID");
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Register a new AI Agent identity to a Node Operator.
     */
    function registerAgent(address nodeOperator, string memory metadataURI) external onlyOwner returns (uint256) {
        require(nodeOperator != address(0), "Invalid operator address");
        
        uint256 tokenId = _nextTokenId++;
        _owners[tokenId] = nodeOperator;
        _balances[nodeOperator] += 1;
        _tokenURIs[tokenId] = metadataURI;

        emit Transfer(address(0), nodeOperator, tokenId);
        emit AgentRegistered(tokenId, nodeOperator, metadataURI);
        return tokenId;
    }
}
