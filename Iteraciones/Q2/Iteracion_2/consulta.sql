explain (format yaml) select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as value
from
	partsupp,
	supplier,
	nation
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_regionkey = 1
group by
	ps_partkey having
	sum(ps_supplycost * ps_availqty) > (SELECT MAX(number) from (
		(select sum(ps_supplycost * ps_availqty)*0.5 as number
		from
			partsupp,
			supplier,
			nation
		where
			ps_suppkey = s_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = 4
			and s_acctbal > 0
		group by ps_partkey )) subquery );