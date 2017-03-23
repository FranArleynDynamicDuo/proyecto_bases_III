/*
  Script de creación de esquema y carga de datos para el proyecto de ci5313
  Elaborado: Abril 2016.
  Autor: Jose Noel Mendoza
*/


ALTER TABLE Nation
  ADD CONSTRAINT fk_nation_region FOREIGN KEY (n_regionkey)
      REFERENCES region (r_regionkey) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

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

CREATE INDEX index_shipdate
  ON lineitem
  USING btree
  (l_shipdate);

CREATE INDEX supplier_s_acctbal_idx
  ON supplier
  USING btree
  (s_acctbal)
  WHERE s_acctbal > 0::numeric;



CREATE TABLE lineitem_y1992 (
    CHECK ( l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1992 select * 
from Lineitem 
where (l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1992-01-01' AND l_shipdate <= DATE '1992-12-31');

CREATE TABLE lineitem_y1993 (
    CHECK ( l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1993 select *
from Lineitem 
where (l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1993-01-01' AND l_shipdate <= DATE '1993-12-31');

CREATE TABLE lineitem_y1994 (
    CHECK ( l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1994 select *
from Lineitem 
where (l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1994-01-01' AND l_shipdate <= DATE '1994-12-31');

CREATE TABLE lineitem_y1995 (
    CHECK ( l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1995 select *
from Lineitem 
where (l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1995-01-01' AND l_shipdate <= DATE '1995-12-31');

CREATE TABLE lineitem_y1996 (
    CHECK ( l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1996 select *
from Lineitem 
where (l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1996-01-01' AND l_shipdate <= DATE '1996-12-31');

CREATE TABLE lineitem_y1997 (
    CHECK ( l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1997 select *
from Lineitem 
where (l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1997-01-01' AND l_shipdate <= DATE '1997-12-31');

CREATE TABLE lineitem_y1998 (
    CHECK ( l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31' )
) INHERITS (Lineitem);

insert into lineitem_y1998 select *
from Lineitem 
where (l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31');

delete from ONLY lineitem where (l_shipdate >= DATE '1998-01-01' AND l_shipdate <= DATE '1998-12-31');


