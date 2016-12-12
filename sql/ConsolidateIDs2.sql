drop table train_norm_3;
create table train_norm_3 (
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
ALTER TABLE train_norm_3 ADD INDEX semanaIDX (Semana);
ALTER TABLE train_norm_3 ADD INDEX clienteIDX (Cliente_ID);
ALTER TABLE train_norm_3 ADD INDEX prodIDX (Producto_ID);

insert into train_norm_3 (
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

#Update IDs
drop table LU_Producto;
create table LU_Producto ( id int primary key auto_increment,  Producto_Old int);
insert into LU_Producto(Producto_Old) select distinct Producto_ID from train_norm_3;
select * from LU_Producto;

SET SQL_SAFE_UPDATES = 0;
update train_norm_3, LU_Producto   
set train_norm_3.Producto_ID = LU_Producto.id 
where train_norm_3.Producto_ID = LU_Producto.Producto_Old;


