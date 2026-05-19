--Date range of dataset: Apr 2015 - Sep 2017
SELECT
	MIN(arrival_date_month),
	MIN(arrival_date_year),
	MAX(arrival_date_month),
	MAX(arrival_date_year)
FROM dbo.hotel_bookings

--Avg ADR by Customer Type
SELECT 
	customer_type,
	ROUND(AVG(adr),0)
FROM dbo.hotel_bookings
GROUP BY customer_type;

--Avg ADR by Market Segment
SELECT
	market_segment,
	AVG(adr) AS avg_adr
FROM dbo.hotel_bookings
GROUP BY market_segment
ORDER BY AVG(adr) DESC;

--Avg ADR by Hotel type
SELECT
	hotel,
	AVG(adr) AS avg_adr
FROM dbo.hotel_bookings
GROUP BY hotel
ORDER BY AVG(adr) DESC;

--Bookings volume by Market Segment
SELECT
	COUNT(*) AS bookings_volume,
	market_segment
FROM dbo.hotel_bookings
GROUP BY market_segment
ORDER BY COUNT(*) DESC;

-- Total bookings volume
SELECT
	COUNT(*) AS num_bookings
FROM dbo.hotel_bookings;

-- AVG ADR
SELECT
	ROUND(AVG(adr),2) AS avg_ADR
FROM dbo.hotel_bookings;