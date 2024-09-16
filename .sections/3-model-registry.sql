show models
    in schema test.public;

show versions
    in model test.public.RANDOMFORESTREGRESSOR;

alter model test.public.RANDOMFORESTREGRESSOR
    set comment = 'new comment';

show models
    like '%RANDOMFORESTREGRESSOR%'
    in schema test.public;

-- predict with model
with test_df as (
     select *
     from test.diamonds.diamonds_transform_pipeline
     limit 10),
preds as (
    SELECT PRICE, test.public.RANDOMFORESTREGRESSOR!predict(
        CUT_OE, COLOR_OE, CLARITY_OE, CARAT, DEPTH, TABLE_PCT, X, Y, Z) pred
    FROM test_df)
select price, pred:PREDICTED_PRICE
from preds;

-- predict with model version
with test_df as (
    select *
    from test.diamonds.diamonds_transform_pipeline
    limit 10),
preds as (
    WITH v1 AS MODEL test.public.RANDOMFORESTREGRESSOR VERSION V1
        SELECT PRICE, v1!predict(
            CUT_OE, COLOR_OE, CLARITY_OE, CARAT, DEPTH, TABLE_PCT, X, Y, Z) pred
        FROM test_df)
select price, pred:PREDICTED_PRICE
from preds;
