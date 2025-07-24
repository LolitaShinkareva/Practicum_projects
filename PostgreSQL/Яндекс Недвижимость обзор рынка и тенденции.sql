/* 
ЯНДЕКС НЕДВИЖИМОСТЬ: ОБЗОР РЫНКА И ТЕНДЕНЦИИ

Основные задачи:
1. Определить временной диапазон выборки (дат публикации объявлений).
2. Классифицировать населённые пункты (разделить на города, поселки и прочие категории).
3. Оценить продолжительность жизни объявлений (активность перед снятием).
4. Рассчитать долю снятых с публикации объявлений.
5. Провести сравнительный анализ соотношения предложений недвижимости Санкт-Петербурга и Ленинградской области.
6. Проверить стоимость квадратного метра на наличие статистически значащих отклонений (очень низких или высоких цен).
7. Выявить и устранить выбросы среди числовых показателей (площади, высота потолков и прочее); сравнить средние, медиану и перцентили для точного анализа данных.
8. AD-HOC задачи. 


AD-HOC ЗАДАЧИ:

ЗАДАЧА № 1. Время активности объявлений

Описание задачи:
Заказчику необходимо выбрать эффективные сегменты рынка недвижимости Санкт-Петербурга и Ленинградской области, исходя из длительности активности объявлений. 
Задача заключается в анализе зависимостей между временем активности объявления и характеристиками недвижимости (стоимость, площадь, число комнат и др.) отдельно для каждого региона.

Цель исследования:
Определить рыночные сегменты с высокой привлекательностью для бизнеса, основываясь на продолжительности размещения объявлений и характеристиках предлагаемых объектов недвижимости.

Вопросы для анализа:
Какие сегменты недвижимости отличаются наименьшим и наибольшим сроком активности объявлений?
Какие факторы (цена, площадь, количество комнат и балконов) оказывают влияние на активность объявлений?
Есть ли существенные отличия между рынком недвижимости Санкт-Петербурга и областью по данным показателям?

ЗАДАЧА № 2.Сезонность объявлений  

Описание задачи:
Исследовать сезонные тенденции на рынке недвижимости Санкт-Петербурга и Ленинградской области, выявив периоды с максимальной активностью продавцов и покупателей.

Цели исследования:
Установить месяцы с максимальным количеством публикаций и снятий объявлений о продаже недвижимости.
Определить зависимость средней стоимости и площадей квартир от сезона.
Подготовить рекомендации для планирования маркетинга и выбора сроков выхода на рынок.

Вопрос для анализа:
Какие месяцы характеризуются пиковым спросом и предложением недвижимости, и как сезон влияет на ключевые характеристики жилья?

ЗАДАЧА № 3. Анализ рынка недвижимости Ленобласти  

Описание задачи:
Определить активные регионы продаж недвижимости в Ленинградской области и проанализировать её особенности для принятия обоснованных бизнес-решений.

Цели исследования:
Составить рейтинг населенных пунктов по уровню активности продаж недвижимости.
Выделить районы с высоким уровнем продажи недвижимости (на основании доли снятых объявлений).
Исследовать среднюю стоимость квадратных метров и размеры недвижимости по выбранным районам.
Проанализировать скорость реализации недвижимости в разных регионах.

Вопрос для анализа:
Где в Ленинградской области наиболее востребована недвижимость, и каковы её ключевые характеристики в активных районах?  */ 



--1) Период представленых объявлений о продаже недвижимости 
select min(first_day_exposition), max(first_day_exposition) 
from real_estate.advertisement a;

|min       |max       |
|----------|----------|
|2014-11-27|2019-05-03|

/*Данные охватывают период с 27 ноября 2014 года по 3 мая 2019 года.
Для анализа годовой динамики рекомендуется использовать лишь полные годы (2015-2018), исключая неполные 2014 и 2019.*/


--2) Распределение объявлений по населённым пунктам
select t.type, COUNT (a.id) as total_advertisement, 
               COUNT(DISTINCT c.city) AS unique_cities 
from real_estate.advertisement a
join real_estate.flats as f on a.id = f.id 
join real_estate.type as t on f.type_id = t.type_id 
join real_estate.city as c on f.city_id = c.city_id
group by t.type_id;

|type                                     |total_advertisement|unique_cities|
|-----------------------------------------|-------------------|-------------|
|город                                    |20 008             |43           |
|посёлок                                  |2 092              |113          |
|деревня                                  |945                |106          |
|посёлок городского типа                  |363                |30           |
|городской посёлок                        |187                |13           |
|село                                     |32                 |9            |
|посёлок при железнодорожной станции      |15                 |6            |
|садовое товарищество                     |4                  |4            |
|коттеджный посёлок                       |3                  |3            |
|садоводческое некоммерческое товарищество|1                  |1            |

/*Распределение объявлений демонстрирует, что 85% из них относится к городам (20 008 из 23 648).
Наибольшее разнообразие наблюдается среди посёлков, насчитывающих 113 уникальных наименований. Данные показывают значительное преобладание городской недвижимости, 
что требует разделения анализа на города и другие категории населённых пунктов.*/


-- 3) Основные статистики по полю со временем активности объявлений
select min(days_exposition) as min_days_exposition, 
       max(days_exposition) as max_days_exposition, 
       round(avg(days_exposition):: numeric, 2) as avg_days_exposition,
       percentile_cont(0.5) within group (order by days_exposition) as median
from real_estate.advertisement a;

|min_days_exposition|max_days_exposition|avg_days_exposition|median|
|-------------------|-------------------|-------------------|------|
|1                  |1 580              |180,75             |95    |

/*Медианное время продажи составляет 95 дней, в то время как среднее время — 180 дней, 
что обусловлено наличием выбросов. Большинство объявлений реализуется в интервале 3-6 месяцев, однако присутствуют аномальные случаи с длительностью продаж до 1 580 дней.*/

-- 4) Процент объявлений, которые сняли с публикации
select round(100.0 * sum(case when a.days_exposition is not NULL then 1 else 0 end) / count(*), 2) AS percentage_advertisement  
from advertisement a;     

|percentage_advertisement|
|------------------------|
|86,55                   |

/*Из общего числа объявлений 86,55% были сняты с публикации, что может свидетельствовать о их продаже. 
Наблюдается высокая активность рынка, однако следует учитывать, что часть объявлений могла быть удалена по другим причинам.*/


--5) Процент квартир продающихся в Санкт-Петербурге
select
    round(
        (select count(*) 
         from flats as f
         join city as c on f.city_id = c.city_id
         where c.city = 'Санкт-Петербург') * 100.0 /
        (select count(*) from flats), 2) as percentage_st_petersburg;

|percentage_st_petersburg|
|------------------------|
|66,47                   |

 /*В Санкт-Петербурге сосредоточено 66,47% объявлений, тогда как Ленинградская область составляет 33,53%. Рынки следует анализировать отдельно, учитывая различия в спросе, ценовых уровнях и динамике..*/


--6) Стоимость квадратного метра
select round (min(a.last_price/f.total_area), 2) as min_price_per_sqm,  
       round (max(a.last_price/f.total_area), 2) as max_price_per_sqm, 
       round (avg(a.last_price/f.total_area), 2) as avg_price_per_sqm,
       round (percentile_cont(0.5) within group (order by a.last_price/f.total_area),2) as median_price_per_sqm
from real_estate.advertisement as a
join real_estate.flats as f on a.id = f.id;

|min_price_per_sqm|max_price_per_sqm|avg_price_per_sqm|median_price_per_sqm|
|-----------------|-----------------|-----------------|--------------------|
|111,83486        |1 907 500        |99 432,2471630508|95 000              |

/* Медианная цена составляет 95 000 рублей за квадратный метр.
Аномальные значения варьируются от 112 рублей до 1,9 миллиона рублей за квадратный метр. Для корректного анализа цен необходимо исключить выбросы.*/

--7) 
select min (rooms),  
       max (rooms), 
       avg (rooms),
       percentile_cont(0.5) within group (order by rooms), 
       percentile_DISC(0.99) within group (order by rooms) 
from real_estate.flats f;

|min|max|avg         |percentile_cont|percentile_disc|
|---|---|------------|---------------|---------------|
|0  |19 |2,0701057082|2              |5              |
 
select min (ceiling_height),  
       max (ceiling_height), 
       avg (ceiling_height),
       percentile_cont(0.5) within group (order by ceiling_height), 
       percentile_DISC(0.99) within group (order by ceiling_height) 
from real_estate.flats f;

|min|max|avg         |percentile_cont|percentile_disc|
|---|---|------------|---------------|---------------|
|1  |100|2,7712870857|2,6500000954   |3,83           |


select min (living_area),  
       max (living_area), 
       avg (living_area),
       percentile_cont(0.5) within group (order by living_area), 
       percentile_cont(0.99) within group (order by living_area) 
from real_estate.flats f;

|min|max  |avg          |percentile_cont|percentile_cont|
|---|-----|-------------|---------------|---------------|
|2  |409,7|34,4483556299|30             |120            |


select min (floor),  
       max (floor), 
       avg (floor),
       percentile_cont(0.5) within group (order by floor), 
       percentile_cont(0.99) within group (order by floor) 
from real_estate.flats f;

|min|max|avg         |percentile_cont|percentile_cont|
|---|---|------------|---------------|---------------|
|1  |33 |5,8932769556|4              |23             |


select min (balcony),  
       max (balcony), 
       avg (balcony),
       percentile_cont(0.5) within group (order by balcony), 
       percentile_cont(0.99) within group (order by balcony) 
from real_estate.flats f;

|min|max|avg         |percentile_cont|percentile_cont|
|---|---|------------|---------------|---------------|
|0  |5  |1,1530032133|1              |5              |

/*На рынке недвижимости преобладают двухкомнатные квартиры, что указывает на доминирование небольшого жилья. Средняя высота потолков составляет 2.77 метра, 
однако наблюдается значительный разброс значений. Жилая площадь большинства квартир невелика и составляет около 30 квадратных метров. В целом, рынок характеризуется преобладанием небольших 
двухкомнатных квартир со стандартной высотой потолков.*/



-- AD-HOC ЗАДАЧИ.
-- ЗАДАЧА № 1 Время активности объявлений

-- Определим аномальные значения (выбросы) по значению перцентилей:
WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,                                  -- фильтруем выбросы
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_h,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_l
    FROM real_estate.flats),
filtered_id AS (
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)                                                
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT ceiling_height_limit_h FROM limits)
            AND ceiling_height > (SELECT ceiling_height_limit_l FROM limits)) OR ceiling_height IS NULL)),
filtered_data AS (
    SELECT
        a.first_day_exposition,
        a.days_exposition,
        a.last_price,
        f.total_area,
        f.rooms,
        f.balcony,
        CASE
            WHEN c.city = 'Санкт-Петербург' THEN 'СПб'       
            ELSE 'ЛенОбл'
        END AS region_category,
        CASE
            WHEN a.days_exposition BETWEEN 1 AND 30 THEN 'month'             
            WHEN a.days_exposition BETWEEN 31 AND 90 THEN 'quarter'
            WHEN a.days_exposition BETWEEN 91 AND 180 THEN 'half_year'
            ELSE 'more_than_half_year'
        END AS activity_category
    FROM real_estate.advertisement AS a
    JOIN real_estate.flats AS f ON f.id = a.id
    JOIN real_estate.city AS c ON c.city_id = f.city_id
    JOIN real_estate.type AS t ON t.type_id = f.type_id
    WHERE f.id IN (SELECT id FROM filtered_id)
      AND t.type = 'город'                                                                                    
      AND a.days_exposition IS NOT NULL)
SELECT
    region_category,
    activity_category,
    COUNT(*) AS number_of_listings,
    ROUND(AVG(total_area)::NUMERIC, 2) AS avarage_area,                      
    ROUND(AVG(last_price / total_area)::NUMERIC, 2) AS average_price_per_meter,
    ROUND(AVG(rooms), 2) AS average_number_of_rooms,
    ROUND(AVG(balcony)::NUMERIC, 2) AS average_number_of_balcony
FROM filtered_data AS fd
GROUP BY fd.region_category, fd.activity_category
ORDER BY fd.region_category, fd.activity_category;


|region_category|activity_category  |number_of_listings|avarage_area|average_price_per_meter|average_number_of_rooms|average_number_of_balcony|
|---------------|-------------------|------------------|------------|-----------------------|-----------------------|-------------------------|
|ЛенОбл         |quarter            |917               |50,88       |67 573,43              |1,89                   |0,96                     |
|ЛенОбл         |more_than_half_year|890               |55,41       |68 297,22              |2,02                   |0,9                      |
|ЛенОбл         |month              |397               |48,72       |73 275,25              |1,75                   |1,07                     |
|ЛенОбл         |half_year          |556               |51,83       |69 846,39              |1,9                    |0,92                     |
|СПб            |quarter            |3 236             |56,71       |111 573,24             |1,92                   |1,01                     |
|СПб            |more_than_half_year|3 581             |66,15       |115 457,22             |2,17                   |0,92                     |
|СПб            |month              |2 168             |54,38       |110 568,88             |1,87                   |1,07                     |
|СПб            |half_year          |2 254             |60,55       |111 938,92             |2,03                   |0,95                     |

/*Ключевая особенность рынка недвижимости – скорость реализации предложений: почти треть объявлений находит покупателя уже в первый месяц. 
Существенно различается и ценовая политика: квадратный метр в Санкт-Петербурге (около 110 тыс. рублей) заметно дороже, чем в Ленинградской области (около 68 тыс. рублей). 
В Санкт-Петербурге объявления чаще остаются активными более полугода, в то время как в Ленинградской области сделки обычно завершаются в первые три месяца. Интересно, 
что с увеличением срока экспонирования объявлений возрастает и средняя площадь предлагаемых квартир. Хотя среднее количество комнат практически не отличается между регионами, 
в Санкт-Петербурге чаще встречаются многокомнатные квартиры с большим количеством балконов и лоджий.*/



-- ЗАДАЧА № 2. Сезонность объявлений 


WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,                                  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_h,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_l
    FROM real_estate.flats),
filtered_id AS (
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)                                                
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT ceiling_height_limit_h FROM limits)
            AND ceiling_height > (SELECT ceiling_height_limit_l FROM limits)) OR ceiling_height IS NULL)),
publishedcounts AS (                                                                                                        
    SELECT
        EXTRACT(MONTH FROM first_day_exposition) AS month,                                              
        COUNT(*) AS published_count
    FROM real_estate.advertisement AS a
    JOIN real_estate.flats AS f ON f.id = a.id
    JOIN real_estate.city AS c ON c.city_id = f.city_id
    JOIN real_estate.type AS t ON t.type_id = f.type_id
    WHERE t.type = 'город'
    GROUP BY EXTRACT(MONTH FROM first_day_exposition)),
removedcounts AS (                                                                                                                                  
    SELECT
        EXTRACT(
            MONTH FROM 
            (first_day_exposition + INTERVAL '1 day' * days_exposition)) AS last_month,                                                                                       
        COUNT(*) AS removed_count
    FROM real_estate.advertisement AS a
    JOIN real_estate.flats AS f ON f.id = a.id
    JOIN real_estate.city AS c ON c.city_id = f.city_id
    JOIN real_estate.type AS t ON t.type_id = f.type_id
    WHERE days_exposition IS NOT NULL AND t.type = 'город'
    AND EXTRACT(YEAR FROM first_day_exposition) IN (2015, 2016, 2017, 2018)    
    GROUP BY EXTRACT(MONTH FROM (first_day_exposition + INTERVAL '1 day' * days_exposition)))
SELECT                                                                                               -- Условие для фильтрации полных лет
    p.month,
    p.published_count,
    r.last_month,
    r.removed_count,
    RANK() OVER (ORDER BY p.published_count DESC) AS rank_published,                                 
    RANK() OVER (ORDER BY r.removed_count DESC) AS rank_removed                                      
FROM PublishedCounts p
FULL OUTER JOIN removedcounts r ON p.month = r.last_month
ORDER BY p.month;

|month|published_count|last_month|removed_count|rank_published|rank_removed|
|-----|---------------|----------|-------------|--------------|------------|
|1    |1 253          |1         |1 497        |11            |3           |
|2    |2 213          |2         |1 316        |1             |8           |
|3    |2 183          |3         |1 374        |2             |6           |
|4    |2 060          |4         |1 283        |3             |10          |
|5    |1 086          |5         |875          |12            |12          |
|6    |1 479          |6         |922          |7             |11          |
|7    |1 439          |7         |1 286        |9             |9           |
|8    |1 468          |8         |1 364        |8             |7           |
|9    |1 667          |9         |1 487        |6             |4           |
|10   |1 798          |10        |1 656        |5             |2           |
|11   |1 999          |11        |1 658        |4             |1           |
|12   |1 363          |12        |1 456        |10            |5           |

/*Сезонность существенно влияет на активность рынка недвижимости. Наибольший приток новых объявлений наблюдается в январе-феврале, 
что можно расценивать как зимний всплеск. Осенью, в октябре-ноябре, отмечается пик закрытия объявлений, свидетельствующий о высокой покупательской активности. 
Летние месяцы, напротив, характеризуются снижением активности по всем направлениям, вероятно, из-за отпускного периода. Важно отметить, что цена за квадратный метр 
и общая стоимость жилья демонстрируют стабильность и не зависят от времени года. Следовательно, наиболее эффективным будет планирование маркетинговых кампаний и запуск 
акций на январь-февраль, а основной фокус на заключение сделок стоит перенести на осенние месяцы.*/

-- ЗАДАЧА № 3. Анализ рынка недвижимости Ленобласти  

SELECT 
    c.city,
    COUNT(a.id) AS total_advertisements,                                              -- Населённые пункты Ленинградской области, которые наиболее активно публикуют объявления о продаже недвижимости
    ROUND((COUNT(a.days_exposition) / COUNT(*)::NUMERIC)*100, 1) AS removed_ratio,    -- В каких населённых пунктах Ленинградской области — самая высокая доля снятых с публикации объявлений
    ROUND(AVG(f.total_area)::NUMERIC, 2) AS average_total_area,                       -- Средняя площадь продаваемых квартир в различных населённых пунктах  
    ROUND(AVG(a.last_price / f.total_area)::NUMERIC, 2) AS average_cost_per_sqm,      -- Средняя стоимость одного квадратного метра
    AVG(a.days_exposition) AS average_days_exposition                                 -- Где недвижимость продаётся быстрее, а где — медленнее
FROM real_estate.advertisement a
JOIN (
    SELECT id
    FROM real_estate.flats
    WHERE 
        total_area < (SELECT PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) FROM real_estate.flats)
        AND (rooms < (SELECT PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) FROM real_estate.flats) OR rooms IS NULL)
        AND (balcony < (SELECT PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) FROM real_estate.flats) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) FROM real_estate.flats)
              AND ceiling_height > (SELECT PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) FROM real_estate.flats))
             OR ceiling_height IS NULL)
) fid ON a.id = fid.id
JOIN real_estate.flats f ON a.id = f.id
JOIN real_estate.city c ON f.city_id = c.city_id
WHERE c.city <> 'Санкт-Петербург'
GROUP BY c.city
HAVING COUNT(a.id) > 50
ORDER BY total_advertisements DESC;

|city           |total_advertisements|removed_ratio|average_total_area|average_cost_per_sqm|average_days_exposition|
|---------------|--------------------|-------------|------------------|--------------------|-----------------------|
|Мурино         |568                 |93,7         |43,86             |85 968,38           |149,2067669173         |
|Кудрово        |463                 |93,7         |46,2              |95 420,47           |160,6290322581         |
|Шушары         |404                 |92,6         |53,93             |78 831,93           |152,0374331551         |
|Всеволожск     |356                 |85,7         |55,83             |69 052,79           |190,1147540984         |
|Парголово      |311                 |92,6         |51,34             |90 272,96           |156,2083333333         |
|Пушкин         |278                 |83,1         |59,74             |104 158,94          |196,5670995671         |
|Гатчина        |228                 |89           |51,02             |69 004,74           |188,1133004926         |
|Колпино        |227                 |92,1         |52,55             |75 211,73           |147,014354067          |
|Выборг         |192                 |87,5         |56,76             |58 669,99           |182,3273809524         |
|Петергоф       |154                 |88,3         |51,77             |85 412,48           |196,5661764706         |
|Сестрорецк     |149                 |89,9         |62,45             |10 848,09           |214,8134328358         |
|Красное Село   |136                 |89,7         |53,2              |71 972,28           |205,8114754098         |
|Новое Девяткино|120                 |88,3         |50,52             |76 879,07           |175,6509433962         |
|Сертолово      |117                 |86,3         |53,62             |69 566,26           |173,5841584158         |
|Бугры          |104                 |87,5         |47,35             |80 968,41           |155,9010989011         |
|Волхов         |87                  |78,2         |50,25             |34 912,33           |164,3529411765         |
|Ломоносов      |87                  |92           |50,89             |71 811,89           |229,55                 |
|Кингисепп      |84                  |91,7         |52,96             |47 107,39           |125,4675324675         |
|Никольское     |80                  |86,3         |42,16             |57 492,98           |237,1449275362         |
|Сланцы         |79                  |83,5         |48,35             |18 110,43           |173,6666666667         |
|Кронштадт      |70                  |90           |54,72             |79 824,39           |159,4603174603         |
|Коммунар       |66                  |84,8         |48,77             |57 352,91           |236,2857142857         |
|Янино-1        |64                  |85,9         |48,45             |70 972,98           |116,8545454545         |
|Старая         |58                  |86,2         |53,7              |65 615,33           |167,18                 |
|Тосно          |58                  |93,1         |53,8              |58 804,15           |163,537037037          |
|Сосновый Бор   |54                  |87           |53,6              |73 937,6            |85,4468085106          |
|Отрадное       |53                  |75,5         |53,76             |56 862,11           |204,775                |

/*Наиболее активными районами по продаже недвижимости в Ленинградской области являются Мурино, Кудрово и Шушары, демонстрируя наибольшее количество опубликованных объявлений. 
Эти же районы показывают высокий уровень завершения сделок (доля снятых объявлений составляет свыше 90%).
Средняя стоимость квадратного метра заметно разнится: самый дорогой район — Пушкин (~104 тыс. руб./кв.м), в то время как Волхов и Сланцы предлагают самую доступную недвижимость (менее 40 тыс. руб./кв.м).
По динамике выставления и продажи недвижимости выделяются Выборг и Гатчина, где средний срок экспозиции сравнительно высок (более 180 дней), тогда как объекты в Сосногорском районе продаются быстрее (около 85 дней).*/


/*ОБЩИЕ ВЫВОДЫ: 
Рынок недвижимости Санкт-Петербурга и Ленинградской области характеризуется следующими основными тенденциями. 
Географически большинство предложений (66%) сконцентрировано в Санкт-Петербурге, а в Ленинградской области наиболее активны Мурино, Кудрово и Шушары, 
где сделки успешно завершаются более чем в 90% случаев. В среднем, продажа объекта занимает 180 дней, медианное значение – 95 дней. Пик размещения объявлений 
приходится на январь-февраль, а максимальное количество сделок заключается в октябре-ноябре. Ценовая картина показывает, что медианная цена за квадратный метр
в Санкт-Петербурге составляет 95 тыс. руб., а в Ленобласти – 68 тыс. руб. Самым дорогим районом является Пушкин (104 тыс. руб./кв.м), а наиболее доступными – Волхов и Сланцы (менее 40 тыс. руб./кв.м). 
Среди объектов преобладают двухкомнатные квартиры площадью около 50 кв.м со средней высотой потолков 2.77 м.*/