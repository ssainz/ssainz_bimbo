#Maintenance:
SELECT @@innodb_buffer_pool_size;
SELECT @@innodb_buffer_pool_size/1024/1024/1024;
SELECT @@innodb_buffer_pool_instances;
SELECT @@innodb_buffer_pool_chunk_size;
#Set pool size to 2 GB:
SET GLOBAL innodb_buffer_pool_size=4294967296;
SET GLOBAL innodb_buffer_pool_instances=2;
#allows updates without having key column in where clause
SET SQL_SAFE_UPDATES = 0;


use bimbo;
#Create norm table
drop table train_norm_4;
create table train_norm_4 (
id int primary key auto_increment,
Semana 	int,
Agencia_ID	int,
Canal_ID	int,
Ruta_SAK	int,
Cliente_ID	int,
Producto_ID	int,
Venta_uni_hoy	bigint(20),
Venta_hoy	double,
Dev_uni_proxima	bigint(20),
Dev_proxima 	double,
Demanda_uni_equil	bigint(20),
Venta_Adjusted	double
);
ALTER TABLE train_norm_4 ADD INDEX prodIDX (Producto_ID);
ALTER TABLE train_norm_4 ADD INDEX clienteIDX (Cliente_ID);
ALTER TABLE train_norm_4 ADD INDEX semanaIDX (Semana);

insert into train_norm_4 (
Semana, 
Agencia_ID, 
Canal_ID,
Ruta_SAK,
Cliente_ID,
Producto_ID,
Venta_uni_hoy,
Venta_hoy,
Dev_uni_proxima,
Dev_proxima,
Demanda_uni_equil,
Venta_Adjusted) 
select 
Semana, 
Agencia_ID, 
Canal_ID,
Ruta_SAK,
Cliente_ID,
Producto_ID,
Venta_uni_hoy,
Venta_hoy,
Dev_uni_proxima,
Dev_proxima,
Demanda_uni_equil,
Venta_hoy - Dev_proxima as Venta_Adjusted
from trainv2;



select count(*) from train_norm;



#Update IDs

#AGENCIA
drop table LU_AGENCIA;
create table LU_AGENCIA (id int primary key auto_increment, Agencia_Old int);
insert into LU_AGENCIA (Agencia_Old) select distinct Agencia_ID from trainv2;

#CANAL
drop table LU_CANAL;
create table LU_CANAL (id int primary key auto_increment, Canal_Old int);
insert into LU_CANAL (Canal_Old) select distinct Canal_ID from trainv2;

#RUTA
drop table LU_RUTA;
create table LU_RUTA (id int primary key auto_increment , Ruta_Old int);
insert into LU_RUTA (Ruta_Old) select distinct Ruta_SAK from trainv2;

#CLIENTE
drop table LU_Cliente;
create table LU_Cliente ( id int primary key auto_increment,  Cliente_Old int);
insert into LU_Cliente(Cliente_Old) select distinct Cliente_ID from trainv2;
#Update,
#DEPRECATED
#SET SQL_SAFE_UPDATES = 0;
#update train_norm f, LU_Cliente lu  set f.Cliente_ID = lu.id where  f.Cliente_ID = lu.Cliente_Old;


#PRODUCTO
drop table LU_Producto;
create table LU_Producto ( id int primary key auto_increment,  Producto_Old int);
insert into LU_Producto(Producto_Old) select distinct Producto_ID from trainv2;
select * from LU_Producto;
select distinct Producto_ID from train_norm;
#Product Update: 
#DEPRECATED
#SET SQL_SAFE_UPDATES = 0;
#update train_norm, LU_Producto   
#set train_norm.Producto_ID = LU_Producto.id 
#where train_norm.Producto_ID = LU_Producto.Producto_Old;



