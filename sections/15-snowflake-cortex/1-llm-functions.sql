-- Cortex LLM Functions
-- https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql

SET review = $$
I've been a customer for less than a year and I have never
had to visit a branch this much in my lifetime.
I've had my banking card locked THREE times for fraud.
I'm canceling both my debit and credit cards ASAP when I can access a branch.
$$;

SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-large',
    'Is this bank customer cancelling his service? ' || $review) as completion;

SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER($review,
    'Why is this customer not paying his bills?') as answer;

SELECT SNOWFLAKE.CORTEX.SENTIMENT($review) as mood;

SELECT SNOWFLAKE.CORTEX.SUMMARIZE($review) as summary;

SELECT SNOWFLAKE.CORTEX.TRANSLATE($review, 'en', 'fr') as translation;
