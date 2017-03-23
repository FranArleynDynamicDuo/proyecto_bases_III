/*
  Script de creación de esquema y carga de datos para el proyecto de ci5313,
  contiene las entonaciones propuestas por el equipo ya integradas de manera
  que solo se debe ejecutar el script y tendremos todo el ambiente configurado
  Elaborado: Marzo 2017.
  Autor: Francisco Sucre (10-10717) y Arleyn Goncalves (10-10290)
*/

--  Limpiando la bd...

drop table if exists Lineitem cascade;
drop table if exists Orders cascade;
drop table if exists Customer cascade;
drop table if exists Partsupp cascade;
drop table if exists Supplier cascade;
drop table if exists Nation cascade;
drop table if exists Region cascade;
drop table if exists Part cascade;

-- Creando tablas...
create table Part(
  p_partkey     serial  primary key,
  p_name        text    check (char_length(p_name) <= 55),
  p_mfgr        text    check (char_length(p_mfgr) <= 25),
  p_brand       text    check (char_length(p_brand) <= 10),
  p_type        text    check (char_length(p_type) <= 25),
  p_size        integer check (p_size >= 0),
  p_container   text    check (char_length(p_container) <= 10),
  p_retailprice decimal check (p_retailprice >= 0),
  p_comment     text    check (char_length(p_comment) <= 23)
);

create table Region(
  r_regionkey serial primary key,
  r_name      text   check (char_length(r_name) <= 25),
  r_comment   text   check (char_length(r_comment) <= 152)
);

create table Nation(
  n_nationkey serial  primary key,
  n_name      text    check (char_length(n_name) <= 25),
  n_regionkey integer not null,
  n_comment   text    check (char_length(n_comment) <= 152)
);

create table Supplier(
  s_suppkey   serial primary key,
  s_name      text   check (char_length(s_name) <= 25),
  s_address   text   check (char_length(s_address) <= 40),
  s_nationkey integer not null references Nation(n_nationkey),
  s_phone     text   check (char_length(s_phone) <= 15),
  s_acctbal   decimal,
  s_comment   text   check (char_length(s_comment) <= 101)
);


create table Partsupp(
  ps_partkey    integer not null references Part(p_partkey),
  ps_suppkey    integer not null references Supplier(s_suppkey),
  ps_availqty   integer check (ps_availqty >= 0),
  ps_supplycost decimal check (ps_supplycost >= 0),
  ps_comment    text    check (char_length(ps_comment) <= 199),
  primary key (ps_partkey, ps_suppkey)
);

create table Customer(
  c_custkey    serial  primary key,
  c_name       text    check (char_length(c_name) <= 25),
  c_address    text    check (char_length(c_address) <= 40),
  c_nationkey  integer not null references Nation(n_nationkey),
  c_phone      text    check (char_length(c_phone) <= 15),
  c_acctbal    decimal,
  c_mktsegment text    check (char_length(c_mktsegment) <= 10),
  c_comment    text    check (char_length(c_comment) <= 117)
);

create table Orders(
  o_orderkey      serial primary key,
  o_custkey       integer not null references Customer(c_custkey),
  o_orderstatus   text    check (char_length(o_orderstatus) = 1),
  o_totalprice    decimal check (o_totalprice >= 0),
  o_orderdate     date,
  o_orderpriority text    check (char_length(o_orderpriority) <= 15),
  o_clerk         text    check (char_length(o_clerk) <= 15),
  o_shippriority  integer,
  o_comment       text    check (char_length(o_comment) <= 79)
);

create table Lineitem(
  l_orderkey      integer  not null references Orders(o_orderkey),
  l_partkey       integer  not null references Part(p_partkey),
  l_suppkey       integer  not null references Supplier(s_suppkey),
  l_linenumber    integer,
  l_quantity      decimal  check (l_quantity >= 0),
  l_extendedprice decimal  check (l_extendedprice >= 0),
  l_discount      decimal  check (l_discount between 0.00 and 1.00),
  l_tax           decimal  check (l_tax >= 0),
  l_returnflag    text     check (char_length(l_returnflag) = 1),
  l_linestatus    text     check (char_length(l_linestatus) = 1),
  l_shipdate      date,
  l_commitdate    date,
  l_receiptdate   date,
  l_shipinstruct  text     check (char_length(l_shipinstruct) <= 25),
  l_shipmode      text     check (char_length(l_shipmode) <= 10),
  l_comment       text     check (char_length(l_comment) <= 44),
  foreign key (l_partkey,l_suppkey) references Partsupp(ps_partkey,ps_suppkey),
  primary key (l_orderkey,l_linenumber),
  check (l_shipdate <= l_receiptdate)
);

/*
  ya que al ser una relación intermedia entre orders y customer, es una tabla que 
  ha acumulado ya un tamaño considerable cuyo propósito da a entender que va a 
  seguir creciendo. Podemos utilizar la estadística histogram_bounds para ayudarnos 
  a definir las condiciones del particion, particularmente si utilizamos esta 
  estadistica sobre un atributo como él del c_custkey o o_orderkey para así separar 
  en distintas tablas hijo los productos de distintas órdenes o clientes. Ya que 
  en la estadística mencionada nos muestran los límites para dividir la tabla 
  en conjuntos de tamaños equivalentes, reduciremos el tamaño del búsqueda 
  notablemente y en general siempre será parecido. También se puede particionar 
  tomando en cuenta las fechas, ya que es probable que las consultas se hagan 
  continuamente sobre elementos recientes y podríamos ahorrarnos la lectura del 
  elementos más antiguos.
*/

/* Creamos un conjunto de tablas hijo para lineitem organizadas de manera anual,
este procedimiento puede hacerse con un trigger de manera automatica para que se
creen tablas hijos de manera automatica pero para efectos de este proyecto las 
haremos de manera manual y estatica */

CREATE TABLE lineitem_y1992 (
    CHECK ( l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1993 (
    CHECK ( l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1994 (
    CHECK ( l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1995 (
    CHECK ( l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1996 (
    CHECK ( l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1997 (
    CHECK ( l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31' )
) INHERITS (Lineitem);

CREATE TABLE lineitem_y1998 (
    CHECK ( l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31' )
) INHERITS (Lineitem);

-- Cargando los datos usando \copy ...
\copy Part from '/etc/postgresql/9.4/main/part.csv' delimiter '|' CSV;
\copy Region from '/etc/postgresql/9.4/main/region.csv' delimiter '|' CSV;
\copy Nation from '/etc/postgresql/9.4/main/nation.csv' delimiter '|' CSV;
\copy Supplier from '/etc/postgresql/9.4/main/supplier.csv' delimiter '|' CSV;
\copy Partsupp from '/etc/postgresql/9.4/main/partsupp.csv' delimiter '|' CSV;
\copy Customer from '/etc/postgresql/9.4/main/customer.csv' delimiter '|' CSV;
\copy Orders from '/etc/postgresql/9.4/main/orders.csv' delimiter '|' CSV;
\copy Lineitem from '/etc/postgresql/9.4/main/lineitem.csv' delimiter '|' CSV;


ALTER TABLE Nation
  ADD CONSTRAINT fk_nation_region FOREIGN KEY (n_regionkey)
      REFERENCES region (r_regionkey) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


/* Ya que para cargar la data se usa el comando copy tenemos que trasladar manualmente los registros de la
tabla lineitem a sus hijos, ya que el comando copy ignora cualquier otra configuracion puesta a la tabla 
excepto los triggers */
insert into lineitem_y1992 select * 
from Lineitem 
where (l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31');

insert into lineitem_y1993 select *
from Lineitem 
where (l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31');

insert into lineitem_y1994 select *
from Lineitem 
where (l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31');

insert into lineitem_y1995 select *
from Lineitem 
where (l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31');

insert into lineitem_y1996 select *
from Lineitem 
where (l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31');

insert into lineitem_y1997 select *
from Lineitem 
where (l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31');

insert into lineitem_y1998 select *
from Lineitem 
where (l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31');


/* Creamos los indices */

/*
  Utilizar índices B-Tree en las llaves foráneas, ya que las consultas suelen hacer joins entre 
  distintas tablas, además que esto forma parte de los estándares de optimización del postgresql. 
  Analizando caso por caso podríamos incluso ordenar las tablas por los atributos con los que se 
  suele hacer JOIN para así él planificador pueda utilizar el algoritmo de Merge Sort JOIN qué 
  tiene el menor tiempo de búsqueda.
*/ 
CREATE INDEX fki_nation_region
  ON nation
  USING btree
  (n_regionkey);



CREATE INDEX fki_supplier_nation
  ON supplier
  USING btree
  (s_nationkey);


CREATE INDEX fki_partsupp_part
  ON partsupp
  USING btree
  (ps_partkey);

CREATE INDEX fki_partsupp_supplier
  ON partsupp
  USING btree
  (ps_suppkey);


CREATE INDEX fki_customer_nation
  ON customer
  USING btree
  (c_nationkey);


CREATE INDEX fki_orders_customer
  ON orders
  USING btree
  (o_custkey);


CREATE INDEX fki_lineitem_order
  ON lineitem
  USING btree
  (l_orderkey);

CREATE INDEX fki_customer_nation
  ON customer
  USING btree
  (c_nationkey);


CREATE INDEX fki_lineitem_part
  ON lineitem
  USING btree
  (l_partkey);

CREATE INDEX fki_lineitem_partsupp
  ON lineitem
  USING btree
  (l_suppkey, l_partkey);

CREATE INDEX fki_lineitem_supplier
  ON lineitem
  USING btree
  (l_suppkey);

/*
  Utilizar un índice B-Tree en el atributo l_shipdate podría ayudar considerablemente 
  a la consulta Q1, asumiendo que las fechas escritas en la consulta fuesen a ser 
  sustituidas por cualquier otra. Si asumimos que las fechas de la consulta son 
  fijas entonces nos convendría mejor un índice parcial con la condición “'1995-01-01' 
  and date '1996-12-31'”
*/

CREATE INDEX index_shipdate
  ON lineitem
  USING btree
  (l_shipdate);

/* 
  Utilizar un índice parcial con la condición s_acctbal > 0, ya que nos evitará 
  leer todas las entradas que no cumplen dicha condición y esto ahorraría una 
  cantidad considerable del trabajo al manejador, también se podría utilizar 
  una tabla particionada pero dado a que ninguna de las consultas busca balances 
  menores a cero dep manera exclusiva, no estaríamos obteniendo ninguna mejoría 
  frente al índice parcial.
*/

CREATE INDEX supplier_s_acctbal_idx
  ON supplier
  USING btree
  (s_acctbal)
  WHERE s_acctbal > 0::numeric;
