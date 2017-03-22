/*
  Script de creación de esquema y carga de datos para el proyecto de ci5313
  Elaborado: Abril 2016.
  Autor: Jose Noel Mendoza
*/

create table Region(
  r_regionkey serial primary key,
  r_name      text   check (char_length(r_name) <= 25),
  r_comment   text   check (char_length(r_comment) <= 152)
);


ALTER TABLE public.nation
  ADD CONSTRAINT fk_nation_region FOREIGN KEY (n_regionkey)
      REFERENCES public.region (r_regionkey) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE INDEX fki_nation_region
  ON public.nation
  USING btree
  (n_regionkey);



CREATE INDEX fki_supplier_nation
  ON public.supplier
  USING btree
  (s_nationkey);


CREATE INDEX fki_partsupp_part
  ON public.partsupp
  USING btree
  (ps_partkey);

CREATE INDEX fki_partsupp_supplier
  ON public.partsupp
  USING btree
  (ps_suppkey);


CREATE INDEX fki_customer_nation
  ON public.customer
  USING btree
  (c_nationkey);


CREATE INDEX fki_orders_customer
  ON public.orders
  USING btree
  (o_custkey);


CREATE INDEX fki_lineitem_order
  ON public.lineitem
  USING btree
  (l_orderkey);

CREATE INDEX fki_customer_nation
  ON public.customer
  USING btree
  (c_nationkey);


CREATE INDEX fki_lineitem_part
  ON public.lineitem
  USING btree
  (l_partkey);

CREATE INDEX fki_lineitem_partsupp
  ON public.lineitem
  USING btree
  (l_suppkey, l_partkey);

CREATE INDEX fki_lineitem_supplier
  ON public.lineitem
  USING btree
  (l_suppkey);

CREATE INDEX index_shipdate
  ON public.lineitem
  USING btree
  (l_shipdate);