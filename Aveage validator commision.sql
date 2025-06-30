WITH latest_epoch AS (
  SELECT MAX(epoch) as max_epoch
  FROM solana.gov.fact_validators
)

SELECT 
  'All Active Validators' as validator_group,
  AVG(commission) as avg_commission,
  COUNT(*) as validator_count
FROM solana.gov.fact_validators v
JOIN latest_epoch le ON v.epoch = le.max_epoch
WHERE active_stake > 0
