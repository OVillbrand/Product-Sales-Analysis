# Project Goal

This SQL project analyzes a relational database to answer three key business questions:
1. Which products are the primary drivers of profit, and where is capital being wasted in overstock?
2. Are we meeting our delivery promises, and where are the geographic bottlenecks?
3.  Who are our "VIP" customers, and which sales reps are the most effective at managing them?

Based on these insights, the project provides actionable recommendations to improve delivery performance and return on investment (ROI).

# Context

This project serves as a standalone demonstration of fundamental to intermediate SQL proficiency. It focuses on the "extraction and transformation", utilizing complex joins, Common Table Expressions (CTEs). This analysis provides the expertise for future projects larger in scale both in terms of data and tech stack.

# Project Retrospective

### Key Findings

#### Analysis: Profitability & Inventory Optimization (Business Question 1)
**1. Profitability & Margins** The product catalog maintains healthy profitability, with individual margins ranging between **30% and 60%**. This would suggest a stable pricing strategy across all product lines, though the high-volume categories drive the vast majority of absolute dollar value.   
**2. Inventory Health (Stock-to-Sales Ratio)** The analysis identified a critical imbalance in capital allocation. By filtering for products with a stock-to-sales ratio below **0.2**, several high-demand items were flagged for immediate restock to avoid losing sales:
	**Critical Risk:** _1960 BSA Gold Star DBD34_ (Ratio: **0.015**)
    **High Risk:** _1968 Ford Mustang_ and _1928 Ford Phaeton Deluxe_.
    **In contrast**, capital is currently allocated in slower-moving inventory such as _The Mayflower_ and the _1996 Peterbilt 379 Stake Bed_, both of which exhibit ratios above **0.8**. While not currently in overstock territory (>1.0), these products represent lower capital efficiency.  
**3. Revenue Performance by Product Line** Total revenue is heavily concentrated in the automotive segments:
- **Classic Cars:** Primary driver at **$3,853,922.49**.
- **Vintage Cars:** Secondary driver at **$1,797,559.63**.
- **Niche Categories:** Unconventional vehicles (Trains, Boats, Airplanes) contribute significantly less to the bottom line, with **Trains** being the lowest revenue generator at **$188,532.92**.
**Recommendations**
- Based on the analysis and revenue distribution, inventory strategy should be rebalanced to improve capital efficiency. Products with consistently low stock-to-sales ratios (<0.2), such as the _1960 BSA Gold Star DBD34_, _1968 Ford Mustang_, and _1928 Ford Phaeton Deluxe_, should be prioritized for immediate restocking to prevent lost sales opportunities.
- Mean while slower-moving inventory with ratios above 0.8, including _The Mayflower_ and the _1996 Peterbilt 379 Stake Bed_, should be reduced to free up working capital and warehouse capacity.
- At a category level, capital should be reallocated away from low-revenue niche segments (Trains, Boats, Airplanes) and toward high-performing automotive categories, particularly _Classic Cars_ and _Vintage Cars_, which together account for the majority of total revenue. 
### Analysis: Logistics & Fulfillment Efficiency (Business Question 2)

**1. Fulfillment Benchmarks** The global average fulfillment time (from order date to ship date) is **3.7 days**. This provides a baseline against which all regional offices can be measured.  
**2. Regional Performance & Bottlenecks** The analysis revealed a significant performance gap between regional offices:
- **Top Performer:** **Sydney** leads in operational efficiency with an average fulfillment time of **3.3 days**.
- **Operational Outlier:** **Tokyo** exhibits a severe bottleneck, with an average fulfillment time of **8.3 days**—more than double the global average.
- **Standard Performance:** Most other cities (London, Paris, NYC) maintain a consistent range between **3.4 and 4.0 days**.  
**3. Delivery Promises & Data Integrity** the only late shipment on record is **Singapore**, with a significant delay of **56 days**.
- **Analytical Observation:** The fact that only one order in the entire dataset is recorded as "late" suggests one of two things: either the company has an industry-leading on-time delivery rate, or the "Required Date" field is set with an overly generous buffer.

**Recommendations**
- A targeted operational review should be conducted between the Sydney and Tokyo facilities to identify the drivers behind the observed performance gap. This review should assess whether the difference is caused by structural factors (such as shipment volume or product complexity) or operational factors (such as staffing levels, internal systems, or management practices).
- In parallel, the definition of the _Required Date_ field should be reviewed to ensure it reflects realistic customer delivery expectations and aligns with industry benchmarks. The fact that only one shipment is recorded as late suggests potential issues in how delivery promises are being captured in the data.
- Finally, the 56-day delay associated with the Singapore order should be treated as a critical exception and audited individually to verify whether it represents a true logistics failure or a data integrity error.
### Analysis: Customer Segmentation & Sales Performance (Business Question 3)
**1. Customer Tiering (LTV Analysis)** The customer base (98 total accounts) was segmented into three tiers based on Lifetime Value (LTV). Revenue is highly concentrated at the top:
- **Tier 1 (VIPs):** 32 accounts (33% of base) have generated over $100,000 in revenue.
- **The "Whales":** Two accounts—**Euro+ Shopping Channel ($820k)** and **Mini Gifts Distributors Ltd. ($591k)**—are massive outliers, significantly outpacing the rest of the customer base in both volume and frequency.
- **Tier 3:** 16 small-scale accounts contributing minimal revenue (e.g., Boards & Toys Co. at ~$7.9k), suggesting these should be considered  low-priority for high-touch sales efforts.  
**2. The Retention Crisis (At-Risk Accounts)** The analysis revealed a critical vulnerability: **68% of the customer base (67 out of 98 accounts)** is currently "At-Risk," having not placed an order in over 90 days.
- **High-Value Churn:** Most concerning are the Tier 1 at-risk accounts, such as **Australian Collectors, Co. ($180k revenue)** and **Muscle Machine Inc ($177k revenue)**, both dormant for over 180 days.
- **Extreme Latency:** Some accounts, managed by sales rep Mami Nishi, have been dormant for over **548 days**, indicating a total breakdown in the retention pipeline.  
**3. Sales Representative ROI & Efficiency** Performance was measured by total revenue and account management efficiency:
- **Revenue Leaders:** **Gerard Hernandez ($1.25M)** and **Leslie Jennings ($1.08M)** are the top drivers of total company value.
- **Efficiency Metric (Revenue per Account):** While Gerard Hernandez leads in total revenue, **Leslie Jennings** maintains a higher "Revenue per Account" (~$180k) with fewer clients, suggesting a more efficient management style.
- **Portfolio Health:** Several reps are currently "owning" high-value at-risk accounts (e.g., Andy Fixter managing the dormant Australian Collectors account), identifying a specific need for sales intervention.
**Recommendations**
- An immediate retention review should be conducted for the 32 Tier 1 accounts currently in the 90–180 day churn window, with priority given to accounts exceeding $150k in lifetime revenue. The objective is to determine whether churn drivers are external (market downturn, customer-side constraints) or internal (service quality, pricing, competitor substitution).
- In parallel, account portfolios should be rebalanced to improve revenue efficiency. High-value Tier 1 accounts should be gradually redistributed from sales representatives with large account loads (e.g., Pamela Castillo with 10 accounts) to high-efficiency performers such as Leslie Jennings, who demonstrates superior revenue per account.

### Technical hurdles 
The main challenge I faced in this project was similar to my last: deciding on the appropriate use of AI, specifically in contrast to my own areas of expertise. I have written READMEs and coded in SQL before, but I don't yet possess the "language" of a data analyst because it hasn't been taught to me. This led me to walk a fine line between my personal insights and recommendations and an LLM's tendency to format everything in its own "data-analytical" terms.  
The second issue worth mentioning is the age and size of the dataset. It is neither new nor particularly large, which led to some creative liberties, such as setting a "current date" in the code that is more recent than the actual data. Without this, the last orders placed would appear to have happened decades ago. I don't personally think this is an issue, as real-world data is often spotty or lacking in detail, but I do believe it was worth mentioning.

### Use of AI
In line with my professional goals, I followed a _“comprehension and capability first”_ approach to using AI. As with my previous projects, AI was used strictly as a technical assistant and debugging aid.
To be precise, I used AI to improve the clarity of documentation and to help refine SQL logic. To provide two examples, I used AI guidance to implement `NULLIF` in order to safely handle division-by-zero scenarios in inventory ratio calculations. This was a case where I had identified the problem but was unfamiliar with the appropriate SQLite function. Another case would be refining the business recommendations provided above, where after writing them out in my own words an LLM was used to improve readability and adjust the language to better fit a portfolio project. 
AI was not used to generate business insights or interpret analytical results. All conclusions were derived through independent analysis of the data.
