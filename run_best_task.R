library(dplyr)
source(file = "fun.R")

cell.lines = c("A498", "AGS", "Colo205", "DU145", "MDA-MB-468", "SF295", "SW620", "UACC62")

# Calculate best task's synergies per cell line (highest average F1-Score)
best.list = list()
for (cell.line in cell.lines) {
  best.list[[cell.line]] = run.sintef.task(task = "ConExcess", cell.line = cell.line, ci_method = "hsa", consecutive_excess_count = 2.0, excess_threshold = -0.17)
}

saveRDS(best.list, file = "best_data.rds")
