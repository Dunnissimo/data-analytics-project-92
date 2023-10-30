-- 
select count(customer_id) as customers_count
from customers;
-- Данный запрос находит общее количество покупателей из таблицы customers


select 
	 e.first_name || ' ' || e.last_name as name,
	 count(s.sales_id) as operations,
	 sum(p.price * s.quantity) as income
from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on s.product_id = p.product_id
group by 1
order by 3 desc nulls last
limit 10;
