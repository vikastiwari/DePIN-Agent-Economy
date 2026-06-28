// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AgentSmartAccount.sol"; // For IERC20 interface

/**
 * @title SubscriptionManager
 * @dev Handles B2B fiat-pegged subscriptions (Shared & Dedicated Tiers).
 */
contract SubscriptionManager {
    IERC20 public stablecoin;
    address public treasury;

    uint256 public constant SHARED_TIER_PRICE = 5_000 * 10**18;    // e.g. 5000 USDC
    uint256 public constant DEDICATED_TIER_PRICE = 25_000 * 10**18; // e.g. 25000 USDC
    uint256 public constant SUBSCRIPTION_DURATION = 30 days;

    enum Tier { NONE, SHARED, DEDICATED }

    struct Subscription {
        Tier tier;
        uint256 expiry;
    }

    mapping(address => Subscription) public subscriptions;

    event SubscriptionPurchased(address indexed client, Tier tier, uint256 expiry);

    constructor(address _stablecoin, address _treasury) {
        stablecoin = IERC20(_stablecoin);
        treasury = _treasury;
    }

    function subscribe(Tier tier) external {
        require(tier == Tier.SHARED || tier == Tier.DEDICATED, "Invalid Tier");
        
        uint256 price = (tier == Tier.SHARED) ? SHARED_TIER_PRICE : DEDICATED_TIER_PRICE;

        require(
            stablecoin.transferFrom(msg.sender, treasury, price),
            "Payment failed"
        );

        uint256 currentExpiry = subscriptions[msg.sender].expiry;
        if (currentExpiry < block.timestamp) {
            currentExpiry = block.timestamp; // Start fresh if expired
        }

        subscriptions[msg.sender] = Subscription({
            tier: tier,
            expiry: currentExpiry + SUBSCRIPTION_DURATION
        });

        emit SubscriptionPurchased(msg.sender, tier, subscriptions[msg.sender].expiry);
    }

    function checkSubscription(address client) external view returns (Tier, uint256) {
        Subscription memory sub = subscriptions[client];
        if (sub.expiry < block.timestamp) {
            return (Tier.NONE, 0);
        }
        return (sub.tier, sub.expiry);
    }
}
