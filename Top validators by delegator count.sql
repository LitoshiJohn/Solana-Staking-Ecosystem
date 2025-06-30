WITH current_epoch AS (
  SELECT MAX(epoch) as max_epoch 
  FROM solana.gov.fact_stake_accounts
)

SELECT 
  v.validator_name,
  v.vote_pubkey,
  COUNT(DISTINCT s.authorized_staker) as unique_delegators,
  SUM(s.active_stake) as total_active_stake
FROM solana.gov.fact_stake_accounts s
JOIN solana.gov.fact_validators v 
  ON s.vote_pubkey = v.vote_pubkey 
  AND s.epoch = v.epoch
WHERE s.epoch = (SELECT max_epoch FROM current_epoch)
  AND s.active_stake > 0  
GROUP BY 1, 2
ORDER BY unique_delegators DESC
LIMIT 100;

