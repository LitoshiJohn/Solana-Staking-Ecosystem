WITH delegator_stats AS (
  SELECT 
    stake_pubkey,
    authorized_staker,
    AVG(active_stake) as avg_stake_amount
  FROM solana.gov.fact_stake_accounts
  WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_stake_accounts)
    AND type_stake = 'delegated'  
    AND vote_pubkey IS NOT NULL 
    AND active_stake > 0
  GROUP BY stake_pubkey, authorized_staker
)

SELECT 
  COUNT(DISTINCT authorized_staker) as unique_delegators,
  AVG(avg_stake_amount) as avg_stake_per_delegator_sol,
  MIN(avg_stake_amount) as min_stake_sol,
  MAX(avg_stake_amount) as max_stake_sol,
  MEDIAN(avg_stake_amount) as median_stake_sol
FROM delegator_stats;