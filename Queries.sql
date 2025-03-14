--Hangi şehirde ne kadar satış yapılmıştır? Şehirlere göre sıralı
SELECT CITY,SUM(LINETOTAL) AS TOTALSALE 
FROM SALEORDERS 
GROUP BY CITY 
ORDER BY CITY



--Şehirlere göre hangi ayda ne kadar satış yapıldı? Şehirlere ve Aylara göre sıralı
SELECT CITY,MONTH_,
SUM(LINETOTAL) AS TOTALSALE 
FROM SALEORDERS 
GROUP BY CITY,MONTH_
ORDER BY CITY,MONTH_

UPDATE SALEORDERS SET MONTH_='01.OCK' WHERE MONTH_='Ocak'
UPDATE SALEORDERS SET MONTH_='02.ŞUB' WHERE MONTH_='Şubat'
UPDATE SALEORDERS SET MONTH_='03.MAR' WHERE MONTH_='Mart'
UPDATE SALEORDERS SET MONTH_='04.NIS' WHERE MONTH_='Nisan'
UPDATE SALEORDERS SET MONTH_='05.MAY' WHERE MONTH_='Mayıs'
UPDATE SALEORDERS SET MONTH_='06.HAZ' WHERE MONTH_='Haziran'
UPDATE SALEORDERS SET MONTH_='07.TEM' WHERE MONTH_='Temmuz'
UPDATE SALEORDERS SET MONTH_='08.AGU' WHERE MONTH_='Ağustos'
UPDATE SALEORDERS SET MONTH_='09.EYL' WHERE MONTH_='Eylül'
UPDATE SALEORDERS SET MONTH_='10.EKI' WHERE MONTH_='Ekim'
UPDATE SALEORDERS SET MONTH_='11.KAS' WHERE MONTH_='Kasım'
UPDATE SALEORDERS SET MONTH_='12.ARA' WHERE MONTH_='Aralık'



--Şehirlerde haftanın günlerine göre ne kadarlık satış yapılıyor? Şehirlere ve günlere göre sıralı
SELECT CITY,DAYOFWEEK_,
SUM(LINETOTAL) AS TOTALSALE 
FROM SALEORDERS 
GROUP BY CITY,DAYOFWEEK_
ORDER BY CITY,DAYOFWEEK_

UPDATE SALEORDERS SET DAYOFWEEK_='01.PZT' WHERE DAYOFWEEK_='Pazartesi'
UPDATE SALEORDERS SET DAYOFWEEK_='02.SAL' WHERE DAYOFWEEK_='Salı'
UPDATE SALEORDERS SET DAYOFWEEK_='03.ÇAR' WHERE DAYOFWEEK_='Çarşamba'
UPDATE SALEORDERS SET DAYOFWEEK_='04.PER' WHERE DAYOFWEEK_='Perşembe'
UPDATE SALEORDERS SET DAYOFWEEK_='05.CUM' WHERE DAYOFWEEK_='Cuma'
UPDATE SALEORDERS SET DAYOFWEEK_='06.CMT' WHERE DAYOFWEEK_='Cumartesi'
UPDATE SALEORDERS SET DAYOFWEEK_='07.PAZ' WHERE DAYOFWEEK_='Pazar'



--Her ilin en çok satan 5 kategorisi
SELECT S.CITY,S1.CATEGORY1,SUM(S1.TOTALSALE) AS TOTALSALE
FROM SALEORDERS S

CROSS APPLY(SELECT TOP 5 CATEGORY1,SUM(LINETOTAL) AS TOTALSALE
FROM SALEORDERS 
WHERE CITY=S.CITY 
GROUP BY CATEGORY1 
ORDER BY TOTALSALE DESC) S1

GROUP BY S.CITY,S1.CATEGORY1
ORDER BY  S.CITY,SUM(S1.TOTALSALE) DESC



--Her kategorinin en çok satan markası
SELECT I.CATEGORY1,I.CATEGORY2,I.BRAND,
SUM(O.LINETOTAL) AS TOTALPRICE
FROM ORDERDETAILS O

INNER JOIN ITEMS I ON I.ID=O.ITEMID
GROUP BY I.CATEGORY1,I.CATEGORY2,I.BRAND
ORDER BY I.CATEGORY1,I.CATEGORY2,TOTALPRICE DESC



--Her ürün Minimum,Maksimum ve Ortalama ne kadara satıldı? Kaç kez ve kaç tane satıldı?
SELECT I.BRAND,I.CATEGORY1,I.ITEMCODE,I.ITEMNAME,
COUNT(O.ID) AS SALECOUNT,
SUM(O.AMOUNT) AS TOTALAMOUNT,
MIN(O.UNITPRICE) AS MINPRICE,
MAX(O.UNITPRICE) AS MAXPRICE,
AVG(O.UNITPRICE) AS AVGPRICE
FROM ITEMS I

INNER JOIN ORDERDETAILS O ON O.ITEMID=I.ID
GROUP BY I.BRAND,I.CATEGORY1,I.ITEMCODE,I.ITEMNAME



--Müşterilerin sistemde kayıtlı adres sayıları ve son alışveriş adresleri
SELECT U.ID,U.NAMESURNAME,
(SELECT COUNT(*) FROM ADDRESS WHERE USERID=U.ID) AS ADDRESSCOUNT,
(SELECT ADDRESSTEXT FROM ADDRESS WHERE ID IN
	(SELECT TOP 1 ADDRESSID FROM ORDERS WHERE USERID=U.ID ORDER BY DATE_ DESC) 
) AS LASTSHOPPINGADDRESS
FROM USERS U



--Nisan ayında en az 12 gün,günlük 500TL altında sipariş veren şehirler
SELECT CITY,COUNT(*) AS DAY_COUNT_U500
FROM (
SELECT 
C.CITY,CONVERT(DATE,O.DATE_) AS DATE_,
SUM(O.TOTALPRICE) AS TOTALPRICE
FROM ORDERS O
INNER JOIN ADDRESS A ON A.ID=O.ADDRESSID
INNER JOIN CITIES C ON C.ID=A.CITYID
WHERE O.DATE_ BETWEEN '2019-04-01' AND '2019-04-30 23:59:59'
GROUP BY C.CITY,CONVERT(DATE,O.DATE_)
HAVING SUM(O.TOTALPRICE)<500
)TMP
GROUP BY CITY
HAVING COUNT(CITY)>=12
