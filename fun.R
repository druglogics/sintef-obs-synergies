library(stringr)

# Rbbt setup
rbbt.singularity.image = "~/soft/rbbt.SINTEF.img" # change appropriately
rbbt.singularity.cmd = paste('singularity exec -e', rbbt.singularity.image)
container_path.R = system(paste(rbbt.singularity.cmd, 'rbbt_Rutil.rb'), intern = TRUE)[1]
rbbt_source.R = paste(system(paste(rbbt.singularity.cmd,'cat', container_path.R), intern = TRUE), collapse="\n")
eval(parse(text=rbbt_source.R)) # Eval the code
rbbt.ruby.exec = function(code) {
  rbbt.ruby.exec.singularity(code, rbbt.singularity.image)
}

#' Run a synergy SINTEF task
#'
#' Use this function to call rbbt SINTEF workflow tasks that produce
#' synergies as a result given task-specific parameters.
#'
#' @param task 1 of 4 options: 'GS', 'Avg', 'ConExcess' or 'ConPropExcess'
#' @param cell.line name of the cell line
#'
#' @importFrom stringr str_replace_all
run.sintef.task = function(task, cell.line, ...) {
  arguments = list(...)

  if (task == "GS") {
    synergies = rbbt.job(workflow = "SINTEF", task = "synergy_classification_by_GS", cell_line = cell.line, log = "0", type = "array")
  } else if (task == "Avg") {
    synergies = rbbt.job(workflow = "SINTEF", task = "synergy_classification_by_avg", cell_line = cell.line, ci_method = arguments$ci_method, excess_threshold = arguments$excess_threshold, log = "0", type = "array")
  } else if (task == "ConExcess") {
    synergies = rbbt.job(workflow = "SINTEF", task = "synergy_classification_by_consecutive_excesses", cell_line = cell.line, ci_method = arguments$ci_method, consecutive_excess_count = arguments$consecutive_excess_count, excess_threshold = arguments$excess_threshold, log = "0", type = "array")
  } else if (task == "ConPropExcess") {
    synergies = rbbt.job(workflow = "SINTEF", task = "synergy_classification_by_consecutive_proportional_excesses", cell_line = cell.line, ci_method = arguments$ci_method, consecutive_excess_count = arguments$consecutive_excess_count, excess_proportional_threshold = arguments$excess_proportional_threshold, log = "0", type = "array")
  }

  # always remove `SF` drug
  synergies = synergies[!grepl(pattern = "SF", x = synergies)]
  synergies = str_replace_all(string = synergies, pattern = "~", replacement = "-")

  return(synergies)
}

#' Scoring function (F1 score)
#'
#' @param gset = vector of gold-standard synergies
#' @param mset = vector of method-produced synergies
get.score = function(gset, mset) {
  hits = sum(mset %in% gset)
  misses = sum(!mset %in% gset)

  gset.len = length(gset)
  mset.len = length(mset)

  score = (hits - misses + mset.len)/(gset.len + mset.len)
  return(score)
}

