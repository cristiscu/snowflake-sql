select dept_id, name,
    row_number() over (order by dept_id) row_number,
    rank() over (order by dept_id) rank,
    dense_rank() over (order by dept_id) dense_rank,
    round(percent_rank() over (order by dept_id) * 100) || '%' percent_rank,
    ntile(3) over (order by dept_id) bucket
from test.employees.emp
order by dept_id;
