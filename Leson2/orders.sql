use ht2;

/*Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED -  «Order is cancelled»
*/

select
	id as 'id Заказа',
	employee_id as 'id Сотрудника',
    amount as 'Выручка',
	CASE order_status
		when 'open' then 'Order is in open state'
		when 'closed' then 'Order is closed'
		when 'cancelled' then 'Order is cancelled'
        end as 'full_order_status'
from orders;