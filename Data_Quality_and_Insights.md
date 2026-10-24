# Data Quality Notes and Sample Insights

## Data-quality issues observed in the supplied workbook

1. **Duplicate lead IDs:** The `leads` sheet contains 19,468 data rows but only 19,392 unique `lead_id` values (76 duplicate IDs). Deduplicate by `lead_id` before counting unique leads or joining to call logs, and validate which row should be retained.
2. **Call logs with no matching lead:** 45 call-log rows refer to lead IDs that are not present in the `leads` sheet. Exclude these rows from metrics that explicitly require calls on known leads, and report the issue during data-quality checks.
3. **Expected nulls in funnel fields:** Fields such as `qualified_date`, `login_date`, `sanction_date`, and `disbursal_date` are often blank because not every lead reaches every funnel stage. Do not automatically replace these blanks with zero dates; treat them as stage-not-reached values.
4. **Call duration interpretation:** `call_duration_ms` is in milliseconds, and zero indicates a call was not connected. Convert units only for display and use `> 0` to define connected calls.

## Two sample insights from September 2025 raw data

1. **Lead funnel:** The deduplicated data contains 5,051 leads created in September 2025. There were 602 leads with a September qualification date, 179 with a September login date, and 56 with a September disbursal date. These are stage-event counts by each stage's own date, as specified in the assignment; they are not necessarily the same cohort of September-created leads.
2. **Calling activity:** In September 2025, known-lead outbound call logs contained 17,971 outbound calls across 5,188 unique leads attempted. Of those outbound calls, 6,025 had a positive duration, giving a call-level connectivity rate of approximately 33.5% (6,025 / 17,971).

## Important interpretation note

These insights are calculated from the supplied raw workbook using the assignment definitions where applicable. Validate that the Power BI measures apply the correct date context and filters before presenting these figures as dashboard results. The workbook contains no separate `Target Dashboard` sheet despite the task instructions referring to one, so any target screenshot or expected KPI values should be obtained separately if exact matching is required.
