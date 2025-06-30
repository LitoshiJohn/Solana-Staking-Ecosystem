WITH validator_stats AS (
  SELECT 
    v.epoch,
    COUNT(DISTINCT v.node_pubkey) as validator_count,
    COUNT(DISTINCT s.authorized_staker) as delegator_count
  FROM solana.gov.fact_validators v
  LEFT JOIN solana.gov.fact_stake_accounts s 
    ON v.vote_pubkey = s.vote_pubkey 
    AND v.epoch = s.epoch
  WHERE v.delinquent = FALSE  -- Only count active validators
  GROUP BY v.epoch
)

SELECT 
  e.epoch,
  validator_count,
  delegator_count
FROM validator_stats vs
JOIN solana.gov.dim_epoch e 
  ON vs.epoch = e.epoch
ORDER BY e.epoch DESC
