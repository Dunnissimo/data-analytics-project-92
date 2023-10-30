-- customers_count.csv
select count(customer_id) as customers_count
from customers;
-- Данный запрос находит общее количество покупателей из таблицы customers

-- top_10_total_income.csv
select 
	 e.first_name || ' ' || e.last_name as name, -- объединяем столбцы с именем и фамилией в один из таблици employees
	 count(s.sales_id) as operations, -- считаем кол-во проведенных сделок за все время из таблицы 
	 sum(p.price * s.quantity) as income -- перемножаем кол-во проданного товара и его цену, чтобы получить выручку и суммирем результат, чтобы узнать суммарную выручку продавца за все время
from employees e
left join sales s -- объединяем таблицы employees и sales
on e.employee_id = s.sales_person_id
left join products p -- объединяем таблицы sales и products
on s.product_id = p.product_id
group by 1 -- группируем таблицу по имени продавца
order by 3 desc nulls last -- сортируем по убыванию выручки, перенося вероятные нулы в конец таблицы
limit 10; -- ограничиваем результат 10ю строками
