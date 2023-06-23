USE ht2;

/* Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : 
меньше 100  -    Маленький заказ
от 100 до 300 - Средний заказ
больше 300  -     Большой заказ
*/

select
	id as 'id заказа',
    case
		when count_product < 100 then 'Маленький заказ'
		when count_product < 300 then 'Средний заказ'
		else 'Большой заказ'
	end as 'Тип заказа'
from sales;

select
	id as 'id заказа',
    if(count_product < 100, 'Маленький заказ',
		if(count_product<300, 'Средний заказ',
			'Большой заказ'
        )
) as 'Тип заказа'
from sales;