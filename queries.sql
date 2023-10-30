-- customers_count.csv
select count(customer_id) as customers_count
from customers;
-- Данный запрос находит общее количество покупателей из таблицы customers

----------------------------------------------------------------------------------------

-- top_10_total_income.csv
select 
	 e.first_name || ' ' || e.last_name as name, -- объединяем столбцы с именем и фамилией в одно целое из таблици employees
	 count(s.sales_id) as operations, -- считаем кол-во проведенных сделок за все время из таблицы sales
	 sum(p.price * s.quantity) as income -- перемножаем кол-во проданного товара на его цену, чтобы получить выручку и суммирем результат, чтобы узнать суммарную выручку продавца за все время
from employees e
left join sales s -- объединяем таблицы employees и sales
on e.employee_id = s.sales_person_id
left join products p -- объединяем таблицы sales и products
on s.product_id = p.product_id
group by 1 -- группируем таблицу по имени продавца
order by 3 desc nulls last -- сортируем по убыванию выручки, перенося вероятные нулы в конец таблицы
limit 10; -- ограничиваем результат 10ю строками

----------------------------------------------------------------------------------------

-- lowest_average_income.csv
with tab as( -- заворачиваю в 
select e.first_name, e.last_name, s.quantity, p.price,
	avg(s.quantity * p.price) over () as average_income_all
from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on s.product_id = p.product_id
)
select
	 first_name || ' ' || last_name as name,
	 round(avg(quantity * price), 0) as average_income
from tab
group by 1, tab.average_income_all
having round(avg(quantity * price), 0) < average_income_all
order by 2;

----------------------------------------------------------------------------------------
