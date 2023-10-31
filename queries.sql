-- customers_count.csv
-- Данный запрос находит общее количество покупателей из таблицы customers

select count(customer_id) as customers_count
from customers;

----------------------------------------------------------------------------------------

-- top_10_total_income.csv 
-- Данный запрос выводит таблицу с данными о 10 продавцах с самой большой суммарной выручкой и количество проведенных ими сделок

select 
	 e.first_name || ' ' || e.last_name as name, -- объединяем столбцы с именем и фамилией в одно целое из таблици employees
	 count(s.sales_id) as operations, -- считаем кол-во проведенных сделок за все время из таблицы sales
	 round(sum(p.price * s.quantity),0) as income -- перемножаем кол-во проданного товара на его цену, чтобы получить выручку и суммирем результат, чтобы узнать суммарную выручку продавца за все время
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
-- Данный запрос выводит таблицу с данными о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам

with tab as( -- создаем временную таблицу с необходимыми нам значениями
select e.first_name, e.last_name, s.quantity, p.price,
	avg(s.quantity * p.price) over () as average_income_all -- также считаем средний доход по всем продавцам
from employees e
left join sales s
	on e.employee_id = s.sales_person_id
left join products p
	on s.product_id = p.product_id
)
select
	 first_name || ' ' || last_name as name, -- объединяем столбцы с именем и фамилией в одно целое
	 round(avg(quantity * price), 0) as average_income -- считаем средний доход сделки (каждого продавца)
from tab
group by 1, tab.average_income_all -- группируем результат по имени продавца (и по среднему доходу по всем продавцам)
having round(avg(quantity * price), 0) < average_income_all -- фильтруем результат, где средняя выручка за сделку меньше средней выручки за сделку по всем продавцам
order by 2; -- сортируем результат по средней доходности по возрастанию

----------------------------------------------------------------------------------------

-- day_of_the_week_income.csv
-- Данный запрос выводит таблицу с данными о выручке продавцов по дням недели

with tab as( -- во временном запросе выводим все необходимые столбцы
select 
	e.first_name || ' ' || e.last_name as name,
	to_char(sale_date, 'day') as weekday,
	to_char(sale_date, 'ID') as weekday_number,
	round(sum(p.price * s.quantity),0) as income
from employees e
left join sales s
	on e.employee_id = s.sales_person_id
left join products p
	on s.product_id = p.product_id
group by 1, 2, 3
order by 3, 1
)
select name, weekday, income
from tab;

--------------------------------------------------------------------------------------------

-- age_groups.csv
-- Данный запрос выводит таблицу с количеством покупателей в разных возрастных группах

select 
	case 
		when age between 16 and 25 then '16-25'
		when age between 26 and 40 then '26-40'
		when age >40 then '40+'
	end as age_category,
	count(age) as count
from customers
group by 1
order by 1;
