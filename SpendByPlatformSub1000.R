# Author: Jenna Goldberg
# Last Updated 6/25/18 by Jansen Manahan to add the < $1000 filter
# Pulls the total spend and count of POs below $1000 divided by the platform on which they were solicited

library(tidyverse)
library(readxl)
setwd("O:/Codebase/0_FMIS_Source_Data")
raw <- read_excel("July1-2017_June15-2018_Pull/REQ_TO_PO_SPILT_PO_SIDE_PUBLIC_July1_June15.xlsx", skip = 1)
Bids2018 <- read_excel("Bids2018_BizCenter.xlsx", col_names = FALSE, na = "N/A")
Bids2017 <- read_excel("Bids2017_BizCenter.xlsx", col_names = FALSE, na = "N/A")
setwd("O:/Codebase/2_PO Count and Spend by Platform/Under 1K")

#Aggregating PO Data 
colnames(raw)[colnames(raw) == "PO No."] <- "POID" # Equivalent to rename()
colnames(raw)[colnames(raw) == "Req ID"] <- "REQID"
Clean <-
  raw %>%
  group_by(.data$`POID`) %>%
  summarize(Amt = sum(.data$`Sum Amount`)) # Amt is the sum amount across the PO number; NOTE THAT THIS DOES NOT ACCOUNT FOR BUSINESS UNIT
Clean <-
  left_join(raw, Clean, key = POID) %>% # mutate might be cleaner here
  select(POID, Amt, Buyer, Bussiness_Unit, Origin, REQID, Vendor_Name, QuoteLink, `PO Date`) # great place to rename columns
Clean <-
  Clean %>%
  distinct() # why?  Also, probably shouldn't overwrite "Clean"

#Dealing with Biz Center Data - match via Req IDs from Bid Log Sheets. Will need a sheet of all req.ids from these. 
#Note that until 2018, these are split between Capital and Operating.  
All_Bids <- 
  dplyr::bind_rows(Bids2017, Bids2018) %>% 
  distinct() # removes about 2/3s of records (but why is it undertaken?)
Bids_List <- c(All_Bids$X__1) # X__1 is req IDs. Has Nulls.

# Identify FairMarkIt by existence of quotelink, Origin = SWC: Platform = Commbuys, Business Center by matching Req IDs
# Not using info directly from FairMarkIt since the existence of an FM bid does not determine that the best bid was made there
# It is possible to use gather the winning bid data from the FM JSON file, but has not yet been done well enough to integrate it
Clean <- Clean %>% mutate(Platform = if_else(.data$Origin == "SWC", "Commbuys",  
                                             if_else(.data$REQID %in% Bids_List, "Business Center",
                                             if_else(str_detect(.data$QuoteLink, "^h") == TRUE, "FairMarkIt"
                                            , "Uncategorized"))))
#NA = Uncategorized
Clean$Platform[is.na(Clean$Platform)] <- "Uncategorized"
#remove duplicate PO#s caused by multiple matched Req IDs
Clean <- Clean %>% distinct(POID, .keep_all = TRUE)

Blacklist <- c(
  4000087408, # The requisition and the PO don't match because the req is from MBTAF ($890000) and the PO is from MBTAN ($150)
  4000088447  # This is excluded because it is now 2 cents, changed from $10,300 probably a a workaround for cancelling the PO
)

# Filter out high value POs, which affects all following CSVs
Clean <-
  Clean %>%
  filter(.data$Amt <= 1000, !.data$POID %in% Blacklist) # <= 1000 meshes with the definition of under $1000 from folder 3_Under1000

#By Platform
POs_by_Platform <-
  Clean %>%
  filter(!.data$POID %in% Blacklist) %>% 
  group_by(.data$Platform) %>%
  summarize("QTY of POs" = n(), "Total Spend" = sum(.data$Amt))

#Export
write.csv(POs_by_Platform, "POs_by_Platform_Under_1K.csv")

# Use highlvl.r from the other folder under 2_By_Platform to get other information for POs under $1000 split by platorm
