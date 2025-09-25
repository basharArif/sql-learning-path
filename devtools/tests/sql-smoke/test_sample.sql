-- Sample pgTAP test (requires pgTAP extension installed in Postgres)
-- This is an example; CI must install pgTAP or tests will be skipped.
SELECT plan(1);
SELECT ok(1 = 1, 'sanity check');
SELECT finish();
