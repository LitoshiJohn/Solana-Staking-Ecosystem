  SELECT 
    validator_name,
    commission,
    active_stake
  FROM solana.gov.fact_validators v
  WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
  AND active_stake > 0
  ORDER BY active_stake DESC
  LIMIT 100
;