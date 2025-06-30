WITH current_stakes AS (
  SELECT 
    authorized_staker as delegator,
    SUM(active_stake) as total_stake_amount,
    COUNT(DISTINCT stake_pubkey) as stake_account_count
  FROM 
    solana.gov.fact_stake_accounts
  WHERE 
    epoch = (SELECT MAX(epoch) FROM solana.gov.fact_stake_accounts)
    AND active_stake > 0
  GROUP BY 
    authorized_staker
)

SELECT 
  cs.delegator,
  cs.total_stake_amount as total_stake_sol,
  cs.stake_account_count,
  ROUND(cs.total_stake_amount / (SELECT SUM(total_stake_amount) FROM current_stakes) * 100, 2) as stake_percentage
FROM 
  current_stakes cs
ORDER BY 
  cs.total_stake_amount DESC
LIMIT 100;