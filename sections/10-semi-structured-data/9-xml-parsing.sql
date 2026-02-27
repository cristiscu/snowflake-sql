-- XML Parsing
-- https://docs.snowflake.com/en/sql-reference/functions/parse_xml
use test.public;

select check_xml(
    STR => '<price>22.50',
    DISABLE_AUTO_CONVERT => TRUE);

select parse_xml(
    STR => '<price>22.50</price>',
    DISABLE_AUTO_CONVERT => TRUE);

create or replace table xml_table(v variant)
as select parse_xml(
'<root>
    <store>
        <book>
            <category>reference</category>
            <author>Nigel Rees</author>
            <title>Sayings of the Century</title>
            <price>8.95</price>
        </book>
        <book>
            <category>fiction</category>
            <author>Evelyn Waugh</author>
            <title>Sword of Honour</title>
            <price>12.99</price>
        </book>
        <book isbn="0-553-21311-3">
            This is a very good book
            <category>fiction</category>
            <author>Herman Melville</author>
            <title>Moby Dick</title>
            <price>8.99</price>
        </book>
        <book isbn="0-395-19395-8">
            <category>fiction</category>
            <author>J. R. R. Tolkien</author>
            <title>The Lord of the Rings</title>
            <price>22.99</price>
        </book>
        <bicycle>
            <color>red</color>
            <price>19.95</price>
        </bicycle>
    </store>
</root>');

-- ==============================================================

-- the top XML root object
select v, v:"$", v:"@"
from xml_table;

-- the "store" XML object
select XMLGET(v, 'store')
from xml_table;

-- ==============================================================

-- the "bicycle" XML object within "store"
select XMLGET(XMLGET(v, 'store'), 'bicycle') as bicycle, is_array(bicycle)
from xml_table;

-- the "book" XML (not array!) within "store"
select XMLGET(XMLGET(v, 'store'), 'book') as book, is_array(book)
from xml_table;

-- ==============================================================

-- third XML store book content, tag, 'isbn' attribute value
select XMLGET(XMLGET(v, 'store'), 'book', 2) as book,
    GET(book, '$') as content,
    GET(book, '@')::string as tag,
    GET(book, '@isbn')::string as isbn
from xml_table;

-- all prop values of the third book in the store
select GET(XMLGET(XMLGET(v, 'store'), 'book', 2), '$') as book,
    book[0]::string as text,
    book[1]:"$"::string as category,
    book[2]:"$"::string as author,
    book[3]:"$"::string as title,
    book[4]:"$"::string as price
from xml_table;

-- the author of the third book in the store
select GET(XMLGET(XMLGET(XMLGET(v, 'store'), 'book', 2), 'author'), '$')::string as author
from xml_table;

-- ==============================================================
-- https://stackoverflow.com/questions/71102368/flatten-xml-array-to-a-single-row-in-snowflake

-- flatten all 'book' XML objects
SELECT s.value
FROM xml_table t, LATERAL FLATTEN(INPUT => XMLGET(t.v, 'store'):"$") s
WHERE GET(s.value, '@')::STRING = 'book';

-- show all XML props of the third 'book' object
SELECT s.value
FROM xml_table t, LATERAL FLATTEN(INPUT => XMLGET(XMLGET(t.v, 'store'), 'book', 2):"$") s


