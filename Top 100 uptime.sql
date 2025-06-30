WITH validator_performance AS (
  SELECT 
    bp.epoch,
    bp.node_pubkey,
    v.validator_name,
    bp.num_leader_slots,
    bp.num_blocks_produced,
    ROUND((bp.num_blocks_produced * 100.0 / NULLIF(bp.num_leader_slots, 0)), 2) as block_production_percentage,
    v.delinquent,
    v.active_stake
  FROM solana.gov.fact_block_production bp
  LEFT JOIN solana.gov.fact_validators v 
    ON bp.node_pubkey = v.node_pubkey 
    AND bp.epoch = v.epoch
  WHERE bp.epoch = (SELECT MAX(epoch) FROM solana.gov.fact_block_production)
    AND v.active_stake > 0
)


SELECT 
  validator_name,
  active_stake,
  ROUND(AVG(block_production_percentage), 2) as "Average Validator Uptime %"
FROM validator_performance
WHERE block_production_percentage IS NOT NULL
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 100;