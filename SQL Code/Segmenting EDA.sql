--Performance metrics across Hotel & Customer type
SELECT 
	--market_segment,
	customer_type,
	hotel,
	COUNT(*) AS total_bookings,
	SUM(is_canceled) AS num_cancellations,
	CAST(ROUND(100.0 * (SUM(is_canceled) / CAST(COUNT(*) AS NUMERIC)),1) AS DECIMAL (5,1)) AS cancellation_rate,
	AVG(lead_time) AS avg_leadtime,
	ROUND(AVG(adr),0) AS avg_adr,
	AVG(stays_in_weekend_nights) + AVG(stays_in_week_nights) AS avg_stay_nights
FROM dbo.hotel_bookings
GROUP BY customer_type, hotel
ORDER BY COUNT(*) DESC, ROUND(AVG(adr),0) DESC;

--CTE practice
WITH aggregations AS (
	SELECT
		hotel,
		customer_type,
		CAST(ROUND(100.0 * (SUM(is_canceled) / CAST(COUNT(*) AS NUMERIC)),1) AS DECIMAL (5,1)) AS cancellation_rate,
		AVG(stays_in_weekend_nights) + AVG(stays_in_week_nights) AS avg_stay_nights,
		ROUND(AVG(adr),0) AS avg_adr
	FROM dbo.hotel_bookings
	GROUP BY hotel, customer_type
)
SELECT 
	hotel,
	customer_type,
	cancellation_rate,
	avg_stay_nights,
	avg_adr
FROM aggregations
ORDER BY avg_adr DESC;

--Bookings volume by repeat guest and market segment
SELECT
	SUM(is_repeated_guest) AS repeat_guest,
	COUNT(*) AS bookings_volume,
	market_segment
FROM dbo.hotel_bookings
GROUP BY market_segment
ORDER BY SUM(is_repeated_guest) DESC;

--Total Stay Nights by Customer Type
SELECT
	SUM(stays_in_weekend_nights) + SUM(stays_in_week_nights) AS total_stay_nights,
	customer_type
	--market_segment
FROM dbo.hotel_bookings
GROUP BY customer_type --market_segment
ORDER BY SUM(stays_in_weekend_nights) + SUM(stays_in_week_nights) DESC;

--Cancellation volume by market segment
SELECT 
	market_segment,
	SUM(is_canceled) AS num_cancellations,
	COUNT(*) AS num_bookings,
	CAST(ROUND(100.0 * (SUM(is_canceled) / CAST(COUNT(*) AS NUMERIC)),1)AS DECIMAL(5,1)) AS cancellation_rate
FROM dbo.hotel_bookings
GROUP BY market_segment;

-- Cancellations by Customer Type and Repeat Guests
SELECT
	SUM(is_repeated_guest) AS repeat_guests,
	SUM(is_canceled) AS cancellations,
	customer_type
FROM dbo.hotel_bookings
GROUP BY customer_type;

-- AVG ADR by repeat and first-time guest
SELECT
	AVG(adr) AS avg_adr,
	CASE WHEN is_repeated_guest = 1 
		THEN 'repeat_guest'
		ELSE 'first-time guest'
		END AS repeat_guest_status
FROM dbo.hotel_bookings
GROUP BY 
	CASE WHEN is_repeated_guest = 1 
		THEN 'repeat_guest'
		ELSE 'first-time guest'
		END;

-- Booking Lead Time & Cancellation Rate by Guest Type
WITH repeat_status AS (
SELECT
	AVG(lead_time) AS avg_leadtime,
	CAST(ROUND(100.0 * (SUM(is_canceled) / CAST(COUNT(*) AS NUMERIC)),1)AS DECIMAL(5,1)) AS cancellation_rate,
	CASE WHEN is_repeated_guest = 1 
		THEN 'repeat_guest'
		ELSE 'first-time guest'
		END AS repeat_guest_status
	FROM dbo.hotel_bookings
	GROUP BY 
		CASE WHEN is_repeated_guest = 1 
		THEN 'repeat_guest'
		ELSE 'first-time guest'
		END
	)
SELECT
	avg_leadtime,
	cancellation_rate,
	repeat_guest_status
FROM repeat_status



--Change is_cancelled data type from BIT to TINYINT
ALTER TABLE dbo.hotel_bookings
ALTER COLUMN is_canceled TINYINT;
