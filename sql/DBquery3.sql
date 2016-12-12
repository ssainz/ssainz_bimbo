use bimbo;

select * from trainv2 limit 10;

#ClienteID_CountOfRutas_relation.csv:
select Cliente_ID, count(distinct Ruta_SAK) as rutas from trainv2 group by Cliente_ID having rutas > 1;
#We can see the relation is not Cliente_ID M:1 Ruta_SAK. It is M:M
#Took 162 seconds.
#ClienteID_CountOfRutas_relation

#RutaSAK_CountOfAgenciaID_relation.csv
select Ruta_SAK, count(distinct Agencia_ID) as CountOfAgencia from trainv2 group by Ruta_SAK having CountOfAgencia > 1;
#We also know that Ruta_SAK is not M:1 with Agencia_ID 
#RutaSAK_CountOfAgenciaID_relation.csv

#AgenciaID_CountOfCanalID_relation.csv
select Agencia_ID, count(distinct Canal_ID) as CountOfCanales from trainv2 group by Agencia_ID having CountOfCanales > 1;
#We also know that AgenciaID is not M:1 with Canal_ID 
#AgenciaID_CountOfCanalID_relation.csv

select Cliente_ID, count(distinct Canal_ID) as CountOfCanales from trainv2 group by Cliente_ID having CountOfCanales > 1;
#not Cliente M:1 Canal_ID

select Cliente_ID, count(distinct Agencia_ID) as CountOfAgencias from trainv2 group by Cliente_ID having CountOfAgencias > 1;
#not Cliente M:1 Agencia_ID

select Ruta_SAK, count(distinct Canal_ID) as CountOfCanales from trainv2 group by Ruta_SAK having CountOfCanales > 1;
#not Ruta_SAK M:1 Canal_ID.

select count(distinct Cliente_ID) from trainv2;

select count(distinct Ruta_SAK) from trainv2;

select count(distinct Agencia_ID) from trainv2;

select count(distinct Canal_ID) from trainv2;

select count(distinct Producto_ID) from trainv2;

select * from trainv2 limit 10;

select count(distinct Cliente_ID, Producto_ID) from trainv2; 

select Cliente_ID, Producto_ID, Semana, Venta_hoy from trainv2 group by Cliente_ID, Producto_ID, Semana order by Cliente_ID, Producto_ID, Semana ASC;

select Cliente_ID, Producto_ID, Semana, sum(Venta_hoy from trainv2 group by Cliente_ID, Producto_ID, Semana order by Cliente_ID, Producto_ID, Semana ASC limit 2100;

select distinct Cliente_ID, Producto_ID from trainv2 il limit 10;

select Cliente_ID, Producto_ID , count(distinct Semana) as countSemana from trainv2 group by Cliente_ID, Producto_ID order by countSemana DESC;

select Cliente_ID, Producto_ID , count(distinct Semana) as countSemana, avg(Venta_hoy) as meanVenta from trainv2 group by Cliente_ID, Producto_ID order by  meanVenta DESC;

select count(distinct Producto_ID) from trainv2;

create table t1 select 1;

create table topTenClients select t1.Cliente_ID, t1.Producto_ID, t1.Semana, t1.Venta_hoy from trainv2 t1, (select distinct Cliente_ID from trainv2 il limit 10) c1 where c1.Cliente_ID = t1.Cliente_ID;

select Cliente_ID, Semana, Producto_ID, sum(Venta_hoy) from topTenClients order by Cliente_ID, Semana,Producto_ID;

use bimbo;
select topClients.Cliente_ID, topClients.Semana, topClients.Producto_ID, topClients.Venta_hoy from (select t1.Cliente_ID, t1.Producto_ID, t1.Semana, t1.Venta_hoy from trainv2 t1, (select distinct Cliente_ID from trainv2 il limit 10) c1 where c1.Cliente_ID = t1.Cliente_ID) as topClients order by topClients.Cliente_ID, topClients.Semana, topClients.Producto_ID;

select Semana, count(*) from tr	ainv2  group by Semana order by Semana ASC;


#Random select rows:
select floor(rand() * 74180464) as sampleId limit 10;



