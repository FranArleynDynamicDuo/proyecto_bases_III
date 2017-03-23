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
	sum(ps_supplycost * ps_availqty) > ALL
		(select sum(ps_supplycost * ps_availqty)*0.5
		from
			partsupp,
			supplier,
			nation
		where
			ps_suppkey = s_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = 4
			and s_acctbal > 0
		group by ps_partkey );