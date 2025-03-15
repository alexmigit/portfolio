CREATE VIEW V
AS
SELECT 'entry:stewiegriffin:lois:brian:' strings
  FROM DUAL
UNION ALL
SELECT 'entry:moe::sizlack:' strings
  FROM DUAL
UNION ALL
SELECT 'entry:petergriffin:meg:chris:' strings
  FROM DUAL
UNION ALL
SELECT 'entry:willie:' strings
  FROM DUAL
UNION ALL
SELECT 'entry:quagmire:mayorwest:cleveland:' strings
  FROM DUAL
  SELECT 'entry:::flanders:' strings
    FROM DUAL
  UNION ALL
  SELECT 'entry:robo:tchi:ken:' strings
    FROM DUAL

WITH CARTESIAN AS (
  SELECT level id
  FROM DUAL
  CONNECT BY level <= 100
)
SELECT max(decode(id,1,substr(strings,p1+1,p2-1))) val1,
       max(decode(id,2,substr(strings,p1+1,p2-1))) val2,
       max(decode(id,3,substr(strings,p1+1,p2-1))) val3
FROM (
  SELECT v.strings,
         c.id,
         instr(v.strings,':',1,c.id) p1,
         instr(v.strings,':',1,c.id+1)-instr(v.strings,':',1,c.id) p2
   FROM v, CARTESIAN c
  WHERE c.id <= (length(v.strings)-length(replace(v.strings,':')))-1
)
GROUP BY strings
ORDER BY 1

