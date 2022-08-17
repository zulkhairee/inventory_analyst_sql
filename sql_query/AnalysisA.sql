/*this series of queries facilities the cleaning and manipulation of weekly shopee data to obtain sales trends  */

-- data consisting of 2146 to 2222 (07 Nov 2021 - 26 June 2022) 
select product, var_name, page_views, date
from shopee.dbo.alldata

select * from shopee.dbo.alldata
order by date desc

--1) CLEANING of multiple variations of parent_sku 
select distinct parent_sku
from alldata
order by parent_sku

-- clean them parent_skus relabelling
update shopee.dbo.alldata
set
	parent_sku = 'Havaianas.Babies/Kids'
WHERE 
	parent_sku = 'H.BABIES'
OR parent_sku = 'H.Kids'
OR parent_sku = 'Havaianas.Kids'

update shopee.dbo.alldata
set
	parent_sku = 'Havaianas.Women'
WHERE 
	parent_sku = 'H.Women'
OR parent_sku = 'H.women'
	
update shopee.dbo.alldata
set
	parent_sku = 'Havaianas.Unisex'
WHERE 
	parent_sku = 'H.UNISEX'
OR parent_sku = 'H.Top'

update shopee.dbo.alldata
set
	parent_sku = 'Havaianas.Men'
WHERE 
	parent_sku = 'H.Men'

--2) generate sum & nonsum tables 
drop table allsumdata
drop table allnonsum

--sumdata
SELECT product, item_id,var_name, var_id,sku,parent_sku, prod_visit, page_views, bounce_rate, likes, prod_visit_addcart, 
	units_addcart, cvr_addcart, buyers_placedorder, units_placedorder, sales_placedorder, cvr_visitplaced,
	buyers_paidorder, units_paidorder, sales_paidorder, cvr_visitpaid, date INTO allsumdata
FROM shopee.dbo.alldata
WHERE bounce_rate != '-'
AND var_id = 0

--nonsum data
SELECT product, item_id, var_name, var_id,sku, parent_sku, prod_visit_addcart, 
	units_addcart, buyers_placedorder, units_placedorder, sales_placedorder, buyers_paidorder, 
	units_paidorder, sales_paidorder, date INTO allnonsum
FROM shopee.dbo.alldata
WHERE bounce_rate = '-'	
AND var_id != '0'


--[checker]
select * from allnonsum
where sku = '-'

select * from allsumdata
order by date desc
where parent_sku = '-'

select distinct parent_sku from allnonsum
order by parent_sku

--3) check duplicates for SKU 
select sku, count(sku) as count
from shopee.dbo.allnonsum
group by sku 
having count(sku) > 1
order by count desc

--4) seperate outlier skus into a seperate table as alldatanonsumout
drop table alldatanonsumout
drop table alldatanonsummain

select max(product) as product, max(sku) as sku, var_name, max(parent_sku) as parent_sku, sum(units_paidorder) as units_paidorder, sum(sales_paidorder) as sales_paidorder, date
into alldatanonsumout
from (
select * 
from shopee.dbo.allnonsum
where sku = 'Na.0000'
OR sku = 'Na000-Nil'
OR sku = 'NIL0000'
OR sku = 'Nil-0000'
OR sku = '-') as t
group by var_name, date
order by product, var_name

select * from alldatanonsummain

--5) seperate main skus into table as alldatanonsummain
select max(product) as product, sku, Max(var_name) as var_name, max(parent_sku) as parent_sku, sum(units_paidorder) as units_paidorder, sum(sales_paidorder) as sales_paidorder, date
into alldatanonsummain
from (
select * 
from shopee.dbo.allnonsum
where sku != 'Na.0000'
AND sku != 'Na000-Nil'
AND sku != 'NIL0000'
AND sku != 'Nil-0000'
AND sku != '-'
) as t
group by sku, date
order by sales_paidorder desc

select * from alldatanonsummain

--6) UNION ALL alldatanonsummain and alldatanonsumout (I forgot why I did this. Maybe to check stuff. Ignore for now 29/6)
SELECT * --INTO x
FROM Shopee.dbo.alldatanonsummain
UNION ALL
SELECT * 
FROM Shopee.dbo.alldatanonsumout

--7) creating masterlist masterlistnonsummain	
drop table masterlistnonsummain
drop table masterlistnonsumout

select distinct max(product) as product, sku, max (var_name) as var_name, parent_sku
into masterlistnonsummain
from shopee.dbo.alldatanonsummain
group by sku, parent_sku
order by parent_sku,sku, product

--7) creating masterlist masterlistnonsumout
select distinct max(product) as product, max(sku) as sku, var_name, parent_sku
into masterlistnonsumout
from shopee.dbo.alldatanonsumout
group by var_name, parent_sku
order by parent_sku,var_name, product
-- note that tables from 7) have been exported and then manually cleaned in excel. then reimported back after cleaned. 

--
select * from shopee.dbo.alldatanonsummain
where sku = 'MASK-KF94.KIDS-LIGHT.GREEN-10PCS'
order by date desc


select * from shopee.dbo.alldatanonsummain
where sku = 'NUU-CROSS.STRAP.SANDALS.858-5-BLACK.EU40'
OR sku = 'NUU-CROSS.STRAP.SANDALS.-STRAP.BLACK.EU40'
order by date desc


--correcting errors found
update shopee.dbo.alldata
set
	sku = 'HAV-SLIM.PRINCESS-CRYSTAL.ROSE.0129-BRA27/28'
WHERE 
	sku = 'HAV-SLIM.PRINCESS-CRYSTAL.ROSE.0129-BRA27.28'

--
select * from shopee.dbo.alldatanonsummain
order by units_paidorder desc,parent_sku, product, sku

select * from shopee.dbo.masterlistnonsummain
select * from shopee.dbo.masterlistnonsumout

--8) creation of cleanednonsummain
drop table #cleanednonsummain

select masterlistnonsummainclean.product, alldatanonsummain.sku, masterlistnonsummainclean.parent_sku, masterlistnonsummainclean.var_name,
alldatanonsummain.units_paidorder, alldatanonsummain.sales_paidorder, alldatanonsummain.date
into #cleanednonsummain
from shopee.dbo.alldatanonsummain
inner join shopee.dbo.masterlistnonsummainclean
ON alldatanonsummain.sku = masterlistnonsummainclean.sku
order by parent_sku, product, sku, date desc

select * from #cleanednonsummain
order by sku

drop table #cleanednonsummain

select distinct sku
from masterlistnonsummain

--9) verifying why there's duplicates, not supposed to happen...
select sku, parent_sku, units_paidorder,sales_paidorder, date from #cleanednonsummain
EXCEPT 
select sku, parent_sku, units_paidorder,sales_paidorder, date from shopee.dbo.alldatanonsummain
--order by SKU
EXCEPT
select sku, parent_sku, units_paidorder,sales_paidorder, date from #cleanednonsummain

select * from #cleanednonsummain 
where sku = 'CRYSTAL-CITRUS.GOLD'

--
select * from #cleanednonsummain

select distinct product, sku, parent_sku
from #cleanednonsummain

select distinct product, sku, parent_sku
from shopee.dbo.alldatanonsummain

select distinct product, sku, parent_sku
from shopee.dbo.masterlistnonsummain

select count (distinct sku) from #cleanednonsummain

select count (distinct sku) from alldatanonsummain

--finding exceptions..still verifying
select distinct sku from #cleanednonsummain
except 
select distinct sku from alldatanonsummain
except
select distinct sku from masterlistnonsummain
except
select distinct sku from alldatanonsummain


select * from masterlistnonsummain 
where sku = 'HAV-SLIM-DARK.BROWN.5964-BRA33/34'

select * from #cleanednonsummain 
where sku = 'HAV-TOP.NAUTICAL-WHITE.YELLOW.9402-BRA37/38'

select * from alldatanonsumout
where sku = '2.0 Black,Brazil 37/38'

--using counts > 1 to check for duplications
select distinct sku, parent_sku
into #hoi
from masterlistnonsummain 

select * from #hoi

drop table #hoi

--verify whether there are duplicates (sku)
select sku, count(sku) as count
from #hoi
group by sku 
having count(sku) > 1
order by count desc

--10) creation of cleanednonsumout
drop table masterlistnonsumoutclean
drop table #cleanednonsumout

select masterlistnonsumoutclean.product, masterlistnonsumoutclean.sku, masterlistnonsumoutclean.parent_sku, alldatanonsumout.var_name,
alldatanonsumout.units_paidorder, alldatanonsumout.sales_paidorder, alldatanonsumout.date
into #cleanednonsumout
from shopee.dbo.alldatanonsumout
inner join shopee.dbo.masterlistnonsumoutclean
ON alldatanonsumout.var_name = masterlistnonsumoutclean.var_name
order by parent_sku, product, sku, date desc


select * from alldatanonsumout
order by sku, date desc
select * from #cleanednonsumout
order by sku
select * from masterlistnonsumoutclean
order by sku
drop table #cleanednonsumout

--11) union all #cleanednonsumout & #cleanednonsummain
select * 
into weekly26june
FROM #cleanednonsummain
UNION ALL
SELECT * 
FROM #cleanednonsumout;


select distinct product,sku,parent_sku, var_name 
into #hello
from weekly26junefinal

drop table #hello



select sku, count(sku) as count
from #hello
group by sku 
having count(sku) > 1
order by count desc

--12) remove duplicates based on differing var_name because of #cleanednonsumout & #cleanednonsummain
select max(product) as product, sku, Max(var_name) as var_name, max(parent_sku) as parent_sku, sum(units_paidorder) as units_paidorder, sum(sales_paidorder) as sales_paidorder, date
into weekly26junefinal 
from shopee.dbo.weekly26june
group by sku, date


select sku, count(sku) as count
from #hello
group by sku 
having count(sku) > 1
order by count desc


select * from #cleanednonsumout
where sku = 'HAV-TOP.MAX.STRT.FGHTR-NAVY.BLUE.0555-BRA41/42'
order by date desc

select * from masterlistnonsumout
where sku = 'HAV-TOP.MAX.STRT.FGHTR-NAVY.BLUE.0555-BRA41/42'
order by date desc

select * from masterlistnonsummain
where sku = 'HJ-PSEUDO.LACE.A01-BLACK-EU40'


select * from #hello
where sku = 'HAV-TOP.MAX.STRT.FGHTR-NAVY.BLUE.0555-BRA41/42'

select * from weekly26junefinal
where sku = 'NUU-DUAL.STRAP.9001-5-BLACK/GREY-EU41'
order by sku, date desc