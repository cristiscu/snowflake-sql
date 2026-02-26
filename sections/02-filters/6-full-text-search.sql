-- Full-Text SEARCH
-- https://docs.snowflake.com/en/user-guide/querying-with-search-functions
-- https://docs.snowflake.com/en/sql-reference/functions/search
USE test.employees;

-- text from Shakespeare's plays
-- https://docs.snowflake.com/en/sql-reference/functions/search#creating-the-sample-data-for-search
CREATE OR REPLACE TABLE lines(
    line_id INT,
    play VARCHAR(50),
    speech_num INT,
    act_scene_line VARCHAR(10),
    character VARCHAR(30),
    line VARCHAR(2000));

INSERT INTO lines VALUES
    (4,'Henry IV Part 1',1,'1.1.1','KING HENRY IV','So shaken as we are, so wan with care,'),
    (13,'Henry IV Part 1',1,'1.1.10','KING HENRY IV','Which, like the meteors of a troubled heaven,'),
    (9526,'Henry VI Part 3',1,'1.1.1','WARWICK','I wonder how the king escaped our hands.'),
    (12664,'All''s Well That Ends Well',1,'1.1.1','COUNTESS','In delivering my son from me, I bury a second husband.'),
    (15742,'All''s Well That Ends Well',114,'5.3.378','KING','Your gentle hands lend us, and take our hearts.'),
    (16448,'As You Like It',2,'2.3.6','ADAM','And wherefore are you gentle, strong and valiant?'),
    (24055,'The Comedy of Errors',14,'5.1.41','AEMELIA','Be quiet, people. Wherefore throng you hither?'),
    (28487,'Cymbeline',3,'1.1.10','First Gentleman','Is outward sorrow, though I think the king'),
    (33522,'Hamlet',1,'2.2.1','KING CLAUDIUS','Welcome, dear Rosencrantz and Guildenstern!'),
    (33556,'Hamlet',5,'2.2.35','KING CLAUDIUS','Thanks, Rosencrantz and gentle Guildenstern.'),
    (33557,'Hamlet',6,'2.2.36','QUEEN GERTRUDE','Thanks, Guildenstern and gentle Rosencrantz:'),
    (33776,'Hamlet',67,'2.2.241','HAMLET','Guildenstern? Ah, Rosencrantz! Good lads, how do ye both?'),
    (34230,'Hamlet',19,'3.1.64','HAMLET','To be, or not to be, that is the question:'),
    (35672,'Hamlet',7,'4.6.27','HORATIO','where I am. Rosencrantz and Guildenstern hold their'),
    (36289,'Hamlet',14,'5.2.60','HORATIO','So Guildenstern and Rosencrantz go to''t.'),
    (36640,'Hamlet',143,'5.2.389','First Ambassador','That Rosencrantz and Guildenstern are dead:'),
    (43494,'King John',1,'1.1.1','KING JOHN','Now, say, Chatillon, what would France with us?'),
    (43503,'King John',5,'1.1.10','CHATILLON','To this fair island and the territories,'),
    (49031,'King Lear',1,'1.1.1','KENT','I thought the king had more affected the Duke of'),
    (49040,'King Lear',4,'1.1.10','GLOUCESTER','so often blushed to acknowledge him, that now I am'),
    (52797,'Love''s Labour''s Lost',1,'1.1.1','FERDINAND','Let fame, that all hunt after in their lives,'),
    (55778,'Love''s Labour''s Lost',405,'5.2.971','ADRIANO DE ARMADO','Apollo. You that way: we this way.'),
    (67000,'A Midsummer Night''s Dream',1,'1.1.1','THESEUS','Now, fair Hippolyta, our nuptial hour'),
    (69296,'A Midsummer Night''s Dream',104,'5.1.428','PUCK','And Robin shall restore amends.'),
    (75787,'Pericles',178,'1.0.21','LODOVICO','This king unto him took a fere,'),
    (78407,'Richard II',1,'1.1.1','KING RICHARD II','Old John of Gaunt, time-honour''d Lancaster,'),
    (91998,'The Tempest',108,'1.2.500','FERDINAND','Were I but where ''tis spoken.'),
    (92454,'The Tempest',150,'2.1.343','ALONSO','Wherefore this ghastly looking?'),
    (99330,'Troilus and Cressida',30,'1.1.102','AENEAS','How now, Prince Troilus! wherefore not afield?'),
    (100109,'Troilus and Cressida',31,'2.1.53','ACHILLES','Why, how now, Ajax! wherefore do you thus? How now,'),
    (108464,'The Winter''s Tale',106,'1.2.500','CAMILLO','As or by oath remove or counsel shake');

-- adding optional search optimization (not free!)
ALTER TABLE lines
    ADD SEARCH OPTIMIZATION
    ON FULL_TEXT(play, character, line);

SELECT SEARCH('king','KING');

SELECT SEARCH(character, 'king queen'), character
FROM lines
WHERE line_id=4;

SELECT play, character, line, act_scene_line
FROM lines
WHERE SEARCH((lines.*), 'king')
ORDER BY act_scene_line
LIMIT 10;

-- EXCLUDE
SELECT play, character, line, act_scene_line
FROM lines
WHERE SEARCH((lines.* EXCLUDE character), 'king')
ORDER BY act_scene_line
LIMIT 10;

SELECT SEARCH(* EXCLUDE (play, line), 'king') result, play, character, line
FROM lines
ORDER BY act_scene_line
LIMIT 10;

-- SEARCH_MODE
SELECT act_scene_line, character, line
FROM lines
WHERE SEARCH(line, 'Rosencrantz Guildenstern', SEARCH_MODE => 'AND')
    AND act_scene_line IS NOT NULL;

SELECT act_scene_line, character, line
FROM lines
WHERE SEARCH(line, 'Why - how  now:  Ajax!', SEARCH_MODE => 'PHRASE');

SELECT act_scene_line, character, line
FROM lines
WHERE SEARCH(line, 'Why, how now, Ajax!', SEARCH_MODE => 'EXACT');

-- using an analyzer
SELECT line_id, act_scene_line FROM lines
WHERE SEARCH(act_scene_line, '1.2.500', ANALYZER=>'NO_OP_ANALYZER');

SELECT DISTINCT(play)
FROM lines
WHERE SEARCH(play, 'love''s', ANALYZER=>'UNICODE_ANALYZER');

SELECT DISTINCT(play)
FROM lines
WHERE SEARCH(play, 'love''s');
