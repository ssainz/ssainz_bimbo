drop table trainv2;
create table trainv2(
Semana 	int,
Agencia_ID	int,
Canal_ID	int,
Ruta_SAK	int,
Cliente_ID	int,
Producto_ID	int,
Venta_uni_hoy bigint,
Venta_hoy double,
Dev_uni_proxima bigint,
Dev_proxima double,
Demanda_uni_equil bigint
)

select count(*) from trainv2