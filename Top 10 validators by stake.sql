WITH total_stake AS (
    SELECT SUM(active_stake) as total_active_stake
    FROM solana.gov.fact_validators
    WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
)
SELECT 
    REGEXP_REPLACE(TRIM(v.validator_name), '[^a-zA-Z0-9 ]', ' ') as clean_validator_name,  
    v.validator_name as original_validator_name,  -- Keep original for reference
    v.active_stake / 1e9 as active_stake_sol,
    ROUND((v.active_stake * 100.0 / total_stake.total_active_stake), 4) as stake_percentage,
    CASE 
        WHEN v.delinquent = TRUE THEN 'Delinquent'
        ELSE 'Active'
    END as validator_status,
    v.commission as commission_percentage,
    v.active_stake as raw_active_stake
FROM solana.gov.fact_validators v
CROSS JOIN total_stake
WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
    AND v.active_stake > 0
ORDER BY v.active_stake DESC
LIMIT 10;