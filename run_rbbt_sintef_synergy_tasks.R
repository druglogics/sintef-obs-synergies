# source some functions
source(file = "fun.R")

# Find the Gold-Standard synergies per cell line
cell.lines = c("A498", "AGS", "Colo205", "DU145", "MDA-MB-468", "SF295", "SW620", "UACC62")
gs.list = list()
for (cell.line in cell.lines) {
  gs.list[[cell.line]] = run.sintef.task(task = "GS", cell.line)
}

# save the list
saveRDS(gs.list, file = "gs_list.rds")

df = tibble(task = character(), cell_line = character(),
  synergy_model = character(), params = character(), score = numeric())

# General data object
data.list = list()

# General Parameter
ci_methods = c("bliss", "hsa")

# from all (loose) to none (strict threshold)!
excess_thresholds = seq(from = 0, to = -0.5, by = -0.01)
proportional_excess_thresholds = seq(from = 0, to = 0.8, by = 0.05)

# AvgBliss/HSA method
task.name = "Avg"
for (cell.line in cell.lines) {
  gset = gs.list[[cell.line]]
  #for (ci_method in ci_methods) {
  # for (excess_threshold in excess_thresholds) {
  mset = run.sintef.task(task = task.name, cell.line = cell.line, ci_method = ci_methods[1], excess_threshold = excess_thresholds[1])
  df %>% add_row(task = task.name, cell_line = cell.line, synergy_model = ci_method, params = paste0("et_", excess_threshold), score = get.score(gset, mset))
  if (is_empty(mset)) break
  #}
  #}
}

# ConExcessBliss/HSA method
# from 1 (loose) to 5 consecutive points (max is 5 in each curve - so more strict)
consecutive_excess_count = 1:5


# ConPropExcessBliss/HSA method

