SELECT 
    epoch,
    SUM(active_stake/POWER(10,9)) as total_staked_sol,
    (SUM(active_stake/POWER(10,9)) / 560000000) * 100 as percent_sol_staked
FROM solana.gov.fact_validators
WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
GROUP BY epoch;