# Lead Intelligence & Performance Analytics Dashboard

## Overview
An interactive Power BI dashboard designed to monitor lead generation, call operations, agent productivity, and funnel performance. The project uses Power BI, Power Query, DAX, SQL, Excel, and data modeling.

## Business questions
- How many leads were created over a selected period?
- How are leads progressing through qualification, login, sanction, and disbursal stages?
- What are call attempt volume and call connectivity rates?
- How are agents performing against calling activity measures?
- How do Google Ads and Meta Ads spend, clicks, impressions, and CTR compare?
- How do results change by date and available lead filters?

## Files
- `Data_Analytics.pbix` — Power BI report.
- `Lead Intelligence & Performance Data.xlsx` — workbook containing task instructions and raw data sheets.
- `SQL_Queries.sql` — SQL solutions for the three assignment questions.
- `Data_Quality_and_Insights.md` — concise data-quality notes and sample insights.

## Data tables
- `leads`: lead details, acquisition fields, assigned agent, and funnel-stage dates/amounts.
- `call_logs`: call timestamps, lead IDs, call type, agent email, and duration in milliseconds.
- `google_ads_daily`: daily Google Ads campaign performance.
- `meta_ads_daily`: daily Meta Ads campaign/ad set performance.
- `ga_sessions_daily`: daily website sessions by channel.

## Measures and definitions
The assignment defines overall CTR as combined Google and Meta clicks divided by combined impressions. Total spend combines Google cost and Meta amount spent. Funnel stages are counted by their own event dates, rather than only by lead-created date. Call connectivity is based on calls with `call_duration_ms > 0`; inbound calls are excluded from outbound-attempt metrics.

## How to open
1. Open `Data_Analytics.pbix` in Power BI Desktop.
2. If Power BI asks for a source path, point it to the included Excel workbook and refresh the data.
3. Review the model relationships, measures, filters, and date selections.
4. Open `SQL_Queries.sql` for the SQL assignment answers.

## Notes
The workbook includes raw data and assignment instructions. Check that you are permitted to share the source workbook and report publicly before making the repository public. If not, use a private repository or replace the data with a sanitized sample. Confirm that the Power BI file refreshes correctly on another machine before sharing.
