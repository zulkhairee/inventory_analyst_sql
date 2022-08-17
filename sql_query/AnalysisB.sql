SELECT *
--into threemonthly26june
FROM shopee.dbo.weekly26junefinal
where date >= '2022-04-09' 
order by date desc

select * from threemonthly26june

select max(product) as product, sku, Max(var_name) as var_name, max(parent_sku) as parent_sku, sum(units_paidorder) as totalunits 
into totalunits26june
from shopee.dbo.threemonthly26june
--where sku = 'MASK-KF94.ADULT-BLACK-10PCS'
group by sku
order by sku, totalunits

select * from totalunits26june
order by product, sku, var_name, parent_sku,totalunits

select product, sku, var_name,parent_sku, totalunits,cast(sum(totalunits) as decimal (9,4))/84 as DRR
into drr26june
from totalunits26june
--where sku = 'MASK-KF94.ADULT-BLACK-10PCS'
group by product, sku, var_name, parent_sku, totalunits

select * from drr26june
drop table drr26june

select * from drr26june
select count (distinct sku) from massjune13out
order by sku
select count (distinct sku) from massjune13main
order by sku
select count (distinct sku) from massjune13
order by sku



--2) sorting out massjune13
--massjune13out
SELECT  max(product) as product, max(sku) as sku, var_name, max(parent_sku) as parent_sku, max(stock_remaining) as stock_remaining
into massjune26out
from shopee.dbo.massjune13
where sku = ' '
OR sku = '-'
OR sku = ''
OR sku = 'Na000-Nil'
OR sku = 'Na.0000'
OR sku = 'Nil-0000'
or sku = 'NIL0000'
group by var_name
order by sku

drop table massjune13out
select * from massjune13out

select masterlistnonsumout.product, masterlistnonsumout.sku, masterlistnonsumout.parent_sku, massjune13out.var_name, massjune13out.stock_remaining
into massjune26outfinal
from shopee.dbo.massjune13out
right join shopee.dbo.masterlistnonsumout
ON massjune13out.var_name = masterlistnonsumout.var_name
order by parent_sku, product, sku

drop table massjune13outfinal
select * from massjune13outfinal

-- massjune13main
SELECT max(product) as product, sku, max(var_name) as var_name, max(parent_sku) as parent_sku, max(stock_remaining) as stock_remaining
into massjune26main
from shopee.dbo.massjune13
where sku != '-'
AND sku != 'Na000-Nil'
AND sku != ''
AND sku != 'Na.0000'
AND sku != 'Nil-0000'
AND sku != 'NIL0000'
group by sku
order by sku

drop table massjune13main
select * from massjune13main

select coalesce (masterlistnonsummain.product, massjune13main.product) as product,
massjune13main.sku, 
coalesce (masterlistnonsummain.parent_sku, massjune13main.parent_sku) as parent_sku,
massjune13main.var_name, 
massjune13main.stock_remaining
into massjune26mainfinal
from shopee.dbo.masterlistnonsummain
right join shopee.dbo.massjune13main
ON massjune13main.sku = masterlistnonsummain.sku
order by sku

select * from massjune13main
drop table massjune13main

select * from massjune13mainfinal
order by sku

drop table massjune13mainfinal

--union massjune13mainfinal and massjune13outfinal

select * 
into massjune26final
FROM massjune26mainfinal
UNION ALL
SELECT * 
FROM massjune26outfinal;

select * from massjune26final
order by sku 
drop table massjune26final

-- join massjune13final and weekly12junetotalunits

select * from massjune26final
order by sku
select * from drr26june
order by sku

--
select massjune26final.product, 
massjune26final.sku, 
massjune26final.var_name,  
	coalesce (drr26june.parent_sku, massjune26final.parent_sku) as parent_sku, 
	drr26june.totalunits, 
	drr26june.drr, 
	massjune26final.stock_remaining
into massjune26compiled
FROM shopee.dbo.massjune26final
left join  shopee.dbo.drr26june
ON massjune26final.sku = drr26june.sku
order by parent_sku, sku

select * from massjune26compiled
where sku = 'MASK-KF94.ADULT-BLACK-10PCS'
drop table massjune13compiled

--FINAL
SELECT *,
	CASE 
		 when stock_remaining = 0 AND drr > 0 THEN 'OOS-M' 
		 when stock_remaining > 0 AND drr = 0 THEN 'NM'

		 when stock_remaining = 0 and drr IS NULL THEN 'OOS-NR'
		 when stock_remaining IS NULL and drr = 0 THEN 'SNR-NM'

		 when stock_remaining IS NULL and drr > 0 THEN 'SNR-M'
		 when stock_remaining > 0 and drr IS NULL THEN 'NM'

		 when stock_remaining is NULL and drr IS NULL THEN 'NRNR' 		 

		 when stock_remaining = 0 and drr = 0 THEN 'OOS'
		 when doi > 0 and doi < 31 THEN 'FM'
		 when doi > 30 and doi < 91 then 'M'
		 when doi > 90 then 'SM'
	ELSE 'UNKNOWN'
    END 'status'
	FROM (
	SELECT *, 
	CASE
		when stock_remaining > 0 and drr > 0 THEN 
			(cast(stock_remaining as decimal (6,2))/cast(drr as decimal (6,2)))
	ELSE 0
	END AS 'doi'
--into hellothere
FROM shopee.dbo.massjune26compiled) t
order by parent_sku

--verify 

select * from shopee.dbo.fourweekly12june
where sku = 'HAV-TOP-BLACK.0090-BRA39/40'

select * from shopee.dbo.fourweekly12june
where sku = 'MASK-KF94.ADULT-BLACK-10PCS'

--stock rem table BY PRODUCTS

select * from shopee.dbo.massjune26compiled

select * from shopee.dbo.drrjune26

select totalunits, drr, stock_remaining 
from shopee.dbo.massjune26compiled
group by product
