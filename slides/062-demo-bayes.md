
# Naive Bayes Classifier

* Key question

  > What is the likelihood that a bank where person X applies
  > accepting the application with respect to the income group
  > person X is in and whether there is additional income or not?

* Inspired by:

  > Peter Bruce & Andrew Bruce
  > Practical Statistics for Data Scientists
  > O'Reilly


```sql
SELECT toggle_swarm64(false);
SELECT toggle_swarm64(true);

EXPLAIN
  ANALYZE
WITH basic_stats AS (
  SELECT
      *
    , n_accepted / n_total_applied AS p_accepted
    , n_rejected / n_total_applied AS p_rejected
  FROM (
    SELECT
      COUNT(*)::DOUBLE PRECISION AS n_total_applied
    , COUNT(
        CASE WHEN state = 'APPLICATION_ACCEPTED' THEN 1 ELSE NULL END
      )::DOUBLE PRECISION AS n_accepted
    , COUNT(
        CASE WHEN state = 'APPLICATION_REJECTED' THEN 1 ELSE NULL END
      )::DOUBLE PRECISION AS n_rejected
    FROM brokerage.application_request_data
    WHERE state IN ('APPLICATION_ACCEPTED', 'APPLICATION_REJECTED')
  ) counts
)
SELECT
    income_group
  , has_misc_earn
  , p_cond_given_accepted
  , 1 - p_cond_given_accepted AS p_cond_given_rejected
FROM (
  SELECT
    freq.*
      -- P(Accepted|Cond) = P(Cond|Accepted) * P(Accepted) / P(Cond)
    , (freq.accepted_count
        / (SELECT n_accepted FROM basic_stats)::DOUBLE PRECISION
      ) * (SELECT p_accepted FROM basic_stats)
        / (freq.cond_count
          / (SELECT n_total_applied FROM basic_stats)::DOUBLE PRECISION
      ) AS p_cond_given_accepted
  FROM (
    SELECT
        CASE WHEN income <                   50000 THEN 0
             WHEN income BETWEEN  50000 AND  60000 THEN 1
             WHEN income BETWEEN  60000 AND  70000 THEN 2
             WHEN income BETWEEN  70000 AND  80000 THEN 3
             WHEN income BETWEEN  80000 AND  90000 THEN 4
             WHEN income BETWEEN  90000 AND 100000 THEN 5
             WHEN income >=                 100000 THEN 6
        END AS income_group
      , has_misc_earn
      , COUNT(
          CASE WHEN bard.state = 'APPLICATION_ACCEPTED' THEN 1 ELSE NULL END
        ) AS accepted_count
      , COUNT(
          CASE WHEN bard.state = 'APPLICATION_REJECTED' THEN 1 ELSE NULL END
        ) AS rejected_count
      , COUNT(*) AS cond_count
    FROM (
      SELECT
          ba.loan_application_id AS la_id
        , income::BIGINT AS income
        , has_misc_earn
      FROM brokerage.application ba
      LEFT JOIN economical_data ed
             ON ed.id = ba.economical_data_id
      LEFT JOIN economical_data_debt_consolidation eddc
             ON ed.id = eddc.economical_data_id
      WHERE ed.owns_accomodation = false
        AND eddc.economical_data_id IS NULL
    ) base
    LEFT JOIN brokerage.application_request_data bard ON base.la_id = bard.application_id
      AND bard.state IN ('APPLICATION_REJECTED', 'APPLICATION_ACCEPTED')
    GROUP BY 1, 2
    ORDER BY 1, 2
  ) freq
) prob
;
```
