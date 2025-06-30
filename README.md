# Solana-Staking-Ecosystem
Analysis of Solana network's health 

Solana operates on a delegated proof-of-stake (DPoS) consensus mechanism, where validators are selected based on the amount of SOL they stake, and stakers delegate their SOL to these validators to participate in network security and earn rewards.

The performance of the staking ecosystem is critical to determining the health of the network and for decentralization, security, and network stability. It also gives every Solana user a grasp of the overall state of Solana staking.

The purpose of this dashboard is to monitor the health of the staking ecosystem on Solana

This dashboard is for the Helius [Redacted] x Nubula Node bounty on Superteam Earn.



When setting out to create this dashboard, I divided the metrics into 3 categories:

Stake distribution - Total Staked SOL, Top 10 Validators by Stake, Nakamoto Coefficient.

Validator performance - Average Validator Commission, Average Validator Uptime, Average Skipped Slots Rate, Staking Yield (APY).

Network participation - Number of Active Validators, Percentage of SOL Staked, Stake Activation Trend, Stake Deactivation Trend.

Each metric analysed will fall into one of these categories, but they will not be done in sequential order.

Tables from the solana.gov schema will be used.

Assumptions

Flipside is the sole provider of data; any data not in the Flipside database will not be analysed.

Only native staking will be analysed.

Epochs are used for time based analysis.
