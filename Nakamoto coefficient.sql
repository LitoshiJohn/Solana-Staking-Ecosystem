WITH base_stats AS (
  SELECT 
    node_pubkey,
    validator_name,
    active_stake,
    SUM(active_stake) OVER () as total_stake
  FROM solana.gov.fact_validators
  WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
),
ranked_validators AS (
  SELECT 
    node_pubkey,
    validator_name,
    active_stake,
    active_stake/total_stake as stake_percentage,
    SUM(active_stake/total_stake) OVER (ORDER BY active_stake DESC) as cumulative_percentage,
    ROW_NUMBER() OVER (ORDER BY active_stake DESC) as validator_rank
  FROM base_stats
)
SELECT 
  validator_rank as nakamoto_coefficient,
  ROUND(cumulative_percentage * 100, 2) as cumulative_stake_percentage,
  COUNT(*) OVER () as total_validators
FROM ranked_validators 
WHERE cumulative_percentage >= 0.33
ORDER BY validator_rank
LIMIT 1;