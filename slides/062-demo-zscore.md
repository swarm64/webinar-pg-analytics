
# z-score

* Key question

  > Are there any significant outliers when measuring the time from the initial
  > loan application request until the decision of "accepted" or "rejected" is
  > made by the bank?

* Inspired by

  > Haki Benita
  > Simple Anomaly Detection Using Plain SQL
  > https://hakibenita.com/sql-anomaly-detection


```sql
SELECT toggle_swarm64(false);
SELECT toggle_swarm64(true);

EXPLAIN
  ANALYZE
SELECT *
FROM (
  SELECT
      period
    , avg_decision_interval_sec * INTERVAL '1s' AS avg_decision_interval
    , (avg_decision_interval_sec - mean_delta_windowed) / stddev_delta_windowed
        AS zscore
  FROM (
    SELECT
        axis.ts AS period
      , avg_decision_interval_sec
      , AVG(avg_decision_interval_sec) OVER status_window
          AS mean_delta_windowed
      , STDDEV(avg_decision_interval_sec) OVER status_window
          AS stddev_delta_windowed
    FROM (
      SELECT generate_series(min_ts, max_ts, INTERVAL '1 hour') AS ts
      FROM (
        SELECT
            date_trunc('hour', MIN(timestamp_rsp)) AS min_ts
          , date_trunc('hour', MAX(timestamp_rsp)) AS max_ts
        FROM brokerage.application_request_data bard
        WHERE bard.state = 'APPLICATION_DELAYED'
      ) min_max_dates
    ) axis
    LEFT JOIN(
      SELECT
          date_trunc('hour', ts_received) ts
        , AVG(ts_decision - ts_received) AS avg_decision_interval
        , FLOOR(EXTRACT(EPOCH FROM AVG(ts_decision - ts_received)))
            AS avg_decision_interval_sec
      FROM (
        SELECT
            bard_1.timestamp_rsp AS ts_received
          , bard_2.timestamp_rsp AS ts_decision
        FROM brokerage.application_request_data bard_1
        INNER JOIN brokerage.application_request_data bard_2 ON
              bard_1.application_id = bard_2.application_id
          AND bard_1.bic = bard_2.bic
          AND (
                 bard_2.state = 'APPLICATION_ACCEPTED'
              OR bard_2.state = 'APPLICATION_REJECTED'
          )
        INNER JOIN brokerage.application ba
                ON bard_1.application_id = ba.loan_application_id
        WHERE bard_1.state = 'APPLICATION_RECEIVED'
          AND NOT EXISTS(
            SELECT 1
            FROM economical_data_debt_consolidation eddc
            WHERE eddc.economical_data_id = ba.economical_data_id
          )
      ) timeframes
      GROUP BY 1
      ORDER BY 1
    ) x ON axis.ts = x.ts
    WINDOW status_window AS (
      PARTITION BY 1
      ORDER BY x.ts DESC
      ROWS BETWEEN 24 PRECEDING AND CURRENT ROW
    )
  ) base
) zscores
WHERE zscore > 3.0;
```
