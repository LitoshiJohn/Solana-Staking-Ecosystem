WITH daily_stats AS (
    SELECT 
        DATE_TRUNC('day', block_timestamp) AS date,
        CASE 
            WHEN event_type = 'delegate' THEN 'Activation'
            WHEN event_type = 'deactivate' THEN 'Deactivation'
        END as action_type,
        COUNT(*) as number_of_actions,
        SUM(ABS(post_tx_staked_balance - pre_tx_staked_balance))/1e9 as total_sol_amount,
        AVG(ABS(post_tx_staked_balance - pre_tx_staked_balance))/1e9 as avg_sol_per_action
    FROM solana.gov.ez_staking_lp_actions
    WHERE event_type IN ('delegate', 'deactivate')
        AND succeeded = TRUE
        AND block_timestamp >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY 1, 2
)

SELECT 
    date,
    
    SUM(CASE WHEN action_type = 'Activation' THEN number_of_actions END) as activation_count,
    SUM(CASE WHEN action_type = 'Activation' THEN total_sol_amount END) as total_sol_activated,
    SUM(CASE WHEN action_type = 'Activation' THEN avg_sol_per_action END) as avg_sol_per_activation,
    
    SUM(CASE WHEN action_type = 'Deactivation' THEN number_of_actions END) as deactivation_count,
    SUM(CASE WHEN action_type = 'Deactivation' THEN total_sol_amount END) as total_sol_deactivated,
    SUM(CASE WHEN action_type = 'Deactivation' THEN avg_sol_per_action END) as avg_sol_per_deactivation,
    
    SUM(CASE WHEN action_type = 'Activation' THEN number_of_actions ELSE -number_of_actions END) as net_action_count,
    SUM(CASE WHEN action_type = 'Activation' THEN total_sol_amount ELSE -total_sol_amount END) as net_sol_staked
FROM daily_stats
GROUP BY 1
ORDER BY 1 ASC;