library(dplyr)
source(file = "fun.R")

##################################################
# Find the Gold-Standard synergies per cell line #
##################################################

cell.lines = c("A498", "AGS", "Colo205", "DU145", "MDA-MB-468", "SF295", "SW620", "UACC62")
gs.list = list()
for (cell.line in cell.lines) {
  gs.list[[cell.line]] = run.sintef.task(task = "GS", cell.line)
}

# save the Gold-Standard list
saveRDS(gs.list, file = "gs_list.rds")

########################################################
# Score all SINTEF synergy tasks across parameter grid #
########################################################

# General data object
data.list = list()
index = 1

# Parameters
ci_methods = c("bliss", "hsa")
excess_thresholds = seq(from = 0, to = -0.5, by = -0.01) # ranging from loose to strict threshold!

# AvgBliss/HSA method
task.name = "Avg"

for (cell.line in cell.lines) {
  gset = gs.list[[cell.line]]
  for (ci_method in ci_methods) {
    for (excess_threshold in excess_thresholds) {
      mset = run.sintef.task(task = task.name, cell.line = cell.line, ci_method = ci_method, excess_threshold = excess_threshold)
      data.list[[index]] = tibble(task = task.name, cell_line = cell.line, ci_method = ci_method, excess_threshold = excess_threshold, f1.score = get.score(gset, mset))
      index = index + 1
    }
  }
}

# ConExcessBliss/HSA method
consecutive_excess_counts = 1:5 # more points => more strict, also max is 5 in each curve
task.name = "ConExcess"

for (cell.line in cell.lines) {
  gset = gs.list[[cell.line]]
  for (ci_method in ci_methods) {
    for (consecutive_excess_count in consecutive_excess_counts) {
      for (excess_threshold in excess_thresholds) {
        mset = run.sintef.task(task = task.name, cell.line = cell.line, ci_method = ci_method, consecutive_excess_count = consecutive_excess_count, excess_threshold = excess_threshold)
        data.list[[index]] = tibble(task = task.name, cell_line = cell.line, ci_method = ci_method, excess_threshold = excess_threshold, consecutive_excess_count = consecutive_excess_count, f1.score = get.score(gset, mset))
        index = index + 1
      }
    }
  }
}

# ConPropExcessBliss/HSA method
excess_proportional_thresholds = seq(from = 0, to = 0.8, by = 0.025) # ranging from loose to more strict!
task.name = "ConPropExcess"

for (cell.line in cell.lines) {
  gset = gs.list[[cell.line]]
  for (ci_method in ci_methods) {
    for (consecutive_excess_count in consecutive_excess_counts) {
      for (excess_proportional_threshold in excess_proportional_thresholds) {
        mset = run.sintef.task(task = task.name, cell.line = cell.line, ci_method = ci_method, consecutive_excess_count = consecutive_excess_count, excess_proportional_threshold = excess_proportional_threshold)
        data.list[[index]] = tibble(task = task.name, cell_line = cell.line, ci_method = ci_method, excess_proportional_threshold = excess_proportional_threshold, consecutive_excess_count = consecutive_excess_count, f1.score = get.score(gset, mset))
        index = index + 1
      }
    }
  }
}

res.data = bind_rows(data.list)
saveRDS(res.data, file = "res_data.rds")

