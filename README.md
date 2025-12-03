# CREDIT_CARD_CSV_ANALYSIS
This project performs complete end-to-end analysis of a Credit Card Transactions CSV dataset using SQL Server.
The goal of the project is to apply SQL data-engineering and analytics concepts to extract meaningful business insights from raw transactional data.
The analysis includes city-level spending insights, card-type trends, expense type behaviors, month-over-month growth, and cumulative spend calculations.
This project is ideal for learners practicing SQL analytics, window functions, CTEs, and real-world data handling.


Project Objectives :

Using SQL Server, this project answers the following business questions:

 1. Top 5 cities by total spends
Also calculate each city's percentage contribution to total credit card spending.
(Implemented using CTEs + window functions.)

2. Highest spending month for each card type
Identify the month in which each card type (Gold, Platinum, Silver, etc.) recorded its highest transaction total.

 3. Cumulative spending milestone (1,000,000)
For each card type, determine the exact transaction row at which cumulative spending crossed 1,000,000.

 4. City with lowest percentage spend for Gold card
Find which city contributes the least to total spending for Gold cardholders.

 5. Highest & lowest expense type for each city
For every city, identify:
Its highest expense type
Its lowest expense type

 6. Highest Month-over-Month growth (Dec 2013 → Jan 2014)
Find the card type & expense type combination that shows the highest spending growth between:

December 2013 → January 2014
