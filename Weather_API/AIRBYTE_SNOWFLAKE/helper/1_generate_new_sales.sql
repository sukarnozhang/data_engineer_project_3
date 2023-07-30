-- upgrade: 
-- values are inspired from: { salesorderid: 43660 }
insert into AIRBYTE_DATABASE.AIRBYTE_SCHEMA.salesorderheader (
	salesorderid,
	revisionnumber, 
	orderdate, 
	duedate,
	shipdate, 
	status,
	onlineorderflag, 
	purchaseordernumber,
    accountnumber,
    customerid,
    salespersonid,
    territoryid,
    billtoaddressid,
    shiptoaddressid,
    shipmethodid,
    creditcardid,
    creditcardapprovalcode,
    currencyrateid,
    subtotal,
    taxamt,
    freight,
    totaldue,
    modifieddate
)  
values 
(75124, 1, '2022-01-01', '2022-02-09', null, 1, false, 'PO18850127500', '10-4020-000117', 29672, 279, 5, 921, 921, 5, 5618, '115213Vi29411', null, 1294.2529, 124.2483, 38.8276, 1457.3288, '2022-01-01'); 

insert into AIRBYTE_DATABASE.AIRBYTE_SCHEMA.salesorderdetail (
    salesorderid, 
    salesorderdetailid, 
    carriertrackingnumber,
    orderqty,
    productid, 
    specialofferid,
    unitprice,
    unitpricediscount,
    modifieddate
)
values
(75124, 121318, '6431-4D57-83', 1, 762, 1, 419.4589, 0, '2022-01-01'),
(75124, 121319, '6431-4D57-83', 1, 758, 1, 874.794, 0, '2022-01-01'); 

-- downgrade:
delete from AIRBYTE_DATABASE.AIRBYTE_SCHEMA.salesorderheader
where salesorderid in (75124);

delete from AIRBYTE_DATABASE.AIRBYTE_SCHEMA.salesorderdetail
where salesorderid in (75124) and salesorderdetailid in (121318, 121319); 
