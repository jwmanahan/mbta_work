# Set up --------------------------------------------------------------------------------------------------------------------------------------------
# Read libraries
# Load data: FMIS data for POs (including DASH_E_ERROR...), FMIS data for Reqs, Business Center data (all)

# Necessary Variables -------------------------------------------------------------------------------------------------------------------------------
# Most recent date in data
# Beginning of one month ago
# Beginning of two months ago
# Beginning of FY
# Buyer classifications: SE, Inventory, Non-Inventory

# Clean all data ------------------------------------------------------------------------------------------------------------------------------------
# Rename columns
# Filter out certain statuses, non-positive spend PO and req lines
# Dedup(?)
# Mutate variables for data integrity: a key of BU-PO?, HasPO
# Handle NAs
# Mutate variables for filtering: Is within one month, Is within two months, Req is in Biz Center data (outer join?), Spend bin per BU-PO (grouping)_
  # Is denied ever
# Mutate for output summarization: Req origin, PO buyer clasification (incl "SWC Buyer"), Bid Category (Single, Sole...), unique taxonomy_
  # Denial age bin, Req age bin
# Mutate req, solicitation, and PO spans


# Calculate output ----------------------------------------------------------------------------------------------------------------------------------
# POs by spend bin and time period
# POs by platform, time period, and spend bin (>|<) $1000
# POs by buyer (rolled up to buyer classification) and time period
# Vendors by (platform | direct voucher vs PO) ranked by (Count of POs | Sum of MBTA spend to them)
# POs by bid category
# POs by Taxonomy and (origin code | BU | buyer)
# Procurement timeline by buyer classification and timeline
# Denials by (age bin | size | level | user)
# Backlog by month (3 trailing) and current output
# Reqs by Age, BU, Buyer, and Is on hold (and roll-ups)

# Visualization -------------------------------------------------------------------------------------------------------------------------------------

# Output to folders ---------------------------------------------------------------------------------------------------------------------------------