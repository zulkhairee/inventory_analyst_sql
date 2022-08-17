/*this query facilities the unioning of multiple weekly tables of sales data, table names are formatted as [YYWW]
where YY is year and WW is ordinal weeky. E.g. 2150 is the 50th week in 2021*/

/* Union all tables currently 2146 - 2220 */
select * INTO alldata2
FROM shopee.dbo.alldata
UNION ALL
SELECT *
FROM shopee.dbo.[2219]
UNION ALL
SELECT * 
FROM shopee.dbo.[2220]

drop table alldata

-- original UNION ALL 
SELECT * INTO alldataprev
FROM Shopee.dbo.[2146]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2147]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2148]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2149]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2150]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2151]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2152]
UNION ALL
SELECT * 
FROM Shopee.dbo.[a2201]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2205]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2206]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2207]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2208]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2209]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2210]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2211]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2212]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2213]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2214]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2215]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2216]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2217]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2218]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2219]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2220]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2221]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2222]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2223]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2224]
UNION ALL
SELECT * 
FROM Shopee.dbo.[2225]

select * into shopee.dbo.alldataprev 
from shopee.dbo.alldata