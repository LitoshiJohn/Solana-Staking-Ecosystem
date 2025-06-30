WITH current_active_validators AS (
    SELECT COUNT( node_pubkey) as total_validators,
           COUNT( CASE WHEN delinquent = false THEN node_pubkey END) as active_validators,
           COUNT( CASE WHEN delinquent = true THEN node_pubkey END) as delinquent_validators
    FROM solana.gov.fact_validators
    WHERE epoch = (SELECT MAX(epoch) FROM solana.gov.fact_validators)
),
recent_staking_validators AS (
    SELECT COUNT(DISTINCT vote_account) as validators_with_recent_stakes
    FROM solana.gov.ez_staking_lp_actions
    WHERE block_timestamp >= CURRENT_DATE - INTERVAL '7 days'
    AND stake_active = true 
    AND validator_name IS NOT NULL 
    AND validator_name <> ''
)
SELECT 
    cav.total_validators,
    cav.active_validators,
    cav.delinquent_validators,
    (cav.active_validators/cav.total_validators)*100 as active_percent,
    (cav.delinquent_validators/cav.total_validators)*100 as delinquent_percent,
    rsv.validators_with_recent_stakes as validators_with_recent_stakes
FROM current_active_validators cav
CROSS JOIN recent_staking_validators rsv;