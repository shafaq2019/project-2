# Project 2 : Sakila ( E-Commerce Revenue & Customer Analysis)

Project summary
This repository contains an analysis of the Sakila sample database to understand revenue growth, category and film performance, customer behaviour, and store/staff-level contributions. Analyses were performed using SQL (SQL Workbench / MySQL), exported results were validated in Excel (PivotTables), and dashboards were built in Power BI.

Tools
- SQL: SQL Workbench / MySQL (queries included in sql/)
- Excel: PivotTables and quick validation checks
- Power BI: dashboards and interactive visuals (put .pbix in powerbi/ if available)

Key analyses (high level)
- Category performance: total revenue, rentals, average revenue per rental, revenue rank
- Film performance: top / under-performing films by revenue and rentals, average revenue per rental
- Customer analytics: top spenders, most frequent customers, geographic averages, loyalty (recent active customers)
- Time-series trends: monthly, weekly, and daily revenue; peak rental hours; average rental duration
- Store & staff performance: revenue by store and payments processed by staff


How to reproduce (quick)
1. Connect your SQL client to the Sakila database (MySQL dialect assumed).  
2. Run the SQL scripts inside sql/ in numeric order. Each script has a short header describing its purpose.  
3. Export script outputs to CSV and import into Excel or Power BI to build dashboards or verify results.


Notes
- The queries are written in MySQL-compatible SQL (DATE_FORMAT, WEEK). If you use PostgreSQL, I can convert queries to Postgres syntax (to_char, date_trunc, extract).
- I used COALESCE where appropriate to avoid NULL propagation (payments, return dates, etc.).
- Replace placeholder references in docs/ with the actual figures after you run the scripts (I can help craft the executive summary once you provide numbers).

Contact
- Email: shafaqzaman012@gmail.com
- GitHub: https://github.com/shafaq2019
