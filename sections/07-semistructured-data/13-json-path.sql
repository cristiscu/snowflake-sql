-- see https://medium.com/snowflake/convert-xpath-and-jsonpath-expressions-to-snowflake-queries-e34ca15bfa6b
use test.public;

create or replace table json_table(v variant) as
    select '{ "store": {
        "book": [ 
            { "category": "reference",
                "author": "Nigel Rees",
                "title": "Sayings of the Century",
                "price": 8.95
            },
            { "category": "fiction",
                "author": "Evelyn Waugh",
                "title": "Sword of Honour",
                "price": 12.99
            },
            { "category": "fiction",
                "author": "Herman Melville",
                "title": "Moby Dick",
                "isbn": "0-553-21311-3",
                "price": 8.99
            },
            { "category": "fiction",
                "author": "J. R. R. Tolkien",
                "title": "The Lord of the Rings",
                "isbn": "0-395-19395-8",
                "price": 22.99
            }
        ],
        "bicycle": {
        "color": "red",
        "price": 19.95
        }
    }
}';

-- =======================================================
-- fluent notation ($.elem1.elem2)

-- the top JSON object
select v
from json_table;

-- the "store" JSON object
select v:store
from json_table;

-- the "bicycle" JSON object within "store"
select v:store.bicycle as bicycle, is_array(bicycle)
from json_table;

-- the "book" JSON array within "store"
select v:store.book as book, is_array(book)
from json_table;

-- =======================================================
-- array elements ([n], [n, m], [:m])

-- the author of the second book in the store (as single string value)
select v:store.book[1].author::string as author
from json_table;

-- first and fourth books in the store
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) in (1, 4);

-- first two books in the store
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) <= 2;

-- second and third books in the store
select elem.value as book
from json_table, lateral flatten(array_slice(v:store.book, 1, 3)) as elem;

-- =======================================================
-- the wildcard operator (*, [*])

-- all child JSON objects in store (as individual records)
select elem.value as child
from json_table, lateral flatten(v:store) as elem;

select elem.value
from json_table, lateral flatten(v) elem;

-- all JSON book objects in the store (as individual records)
select elem.value as book, is_object(book)
from json_table, lateral flatten(v:store.book) as elem;

-- all author string values of all JSON book objects in the store
select elem.value:author::string as author
from json_table, lateral flatten(v:store.book) as elem;

-- =======================================================
-- the descendant operator (..)

-- all "author" property values from the store, no matter where
select elem.value::string as author
from json_table, lateral flatten(input => v:store, recursive => true) as elem
where elem.key = 'author';

-- the second "book" object, anywhere in the document
select elem.value[1] as book
from json_table, lateral flatten(input => v, recursive => true) as elem
where elem.key = 'book';

-- =======================================================
-- filter expressions ([?(…)])

-- only the books with a "price" below $10
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
where elem.value:price < 10;

-- only the books with an "isbn" property defined
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
where elem.value:isbn is not null;