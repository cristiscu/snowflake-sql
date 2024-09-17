-- see https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-udafs
use test.employees;

-- SUM: w/ single parameter
CREATE OR REPLACE AGGREGATE FUNCTION sum2(a FLOAT)
    RETURNS FLOAT
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.8
    HANDLER = 'Sum2'
AS $$
class Sum2:
    def __init__(self): self._sum = 0
    @property
    def aggregate_state(self): return self._sum
    def accumulate(self, input_value): self._sum += input_value
    def merge(self, other_partial_sum): self._sum += other_partial_sum
    def finish(self): return self._sum
$$;

select dept_id, sum(salary), sum2(salary)
from emp
group by dept_id;

-- AVG: w/ multiple parameters
CREATE OR REPLACE AGGREGATE FUNCTION avg2(a FLOAT)
    RETURNS FLOAT
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.8
    HANDLER = 'Avg2'
AS $$
from dataclasses import dataclass
@dataclass
class Avg2State:
    count: int
    sum: int

class Avg2:
    def __init__(self):
        self._state = Avg2State(0, 0)

    @property
    def aggregate_state(self):
        return self._state

    def accumulate(self, input_value):
        self._state.sum += input_value
        self._state.count += 1

    def merge(self, other_state):
        self._state.sum += other_state.sum
        self._state.count += other_state.count

    def finish(self):
        return self._state.sum / self._state.count
$$;

select dept_id, avg(salary), avg2(salary)
from emp
group by dept_id;

-- not working (yet) as window function!
select distinct dept_id,
    avg(salary) over (partition by dept_id),
    avg2(salary) over (partition by dept_id)
from emp;
