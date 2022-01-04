select create_hypertable('public."ENDDEV_PAYLOAD"', 'recv_timestamp');

SELECT add_retention_policy('public."ENDDEV_PAYLOAD"', INTERVAL '3 months');