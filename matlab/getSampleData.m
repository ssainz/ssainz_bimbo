function data = getSampleData(rangeCliente, limitCliente, limitTotal)
conn = database('bimbo','root','','Vendor','MySQL','Server','localhost');

limiteRuta = 3604;
limiteProducto = 800;

isopen(conn);

%sqlquery = sprintf('select id, Semana, Agencia_ID, Canal_ID, Ruta_SAK, Cliente_ID, Producto_ID, Venta_Adjusted from train_norm_5 as TRAIN join ( select floor(rand() * 74180464) as sample from train_norm_5 limit %d) as R ON TRAIN.id = R.sample;', limit);
sqlquery = sprintf('select  id, Semana, Agencia_ID, Canal_ID, Ruta_SAK, Cliente_ID, Producto_ID, Venta_Adjusted from train_norm_5 as TRAIN  join (  select floor(rand() * %d) as rand_cliente from LU_Cliente limit %d) as C  ON TRAIN.Cliente_ID = C.rand_cliente where TRAIN.Ruta_SAK < %d and TRAIN.Producto_ID < %d limit %d;', rangeCliente, limitCliente, limiteRuta, limiteProducto, limitTotal);

curs = exec(conn, sqlquery);
curs = fetch(curs);
data = curs.Data;
close(curs);
close(conn);
end
