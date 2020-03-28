Rscript -e "rmarkdown::render(input = 'sintef_obs_synergies.Rmd', output_format = 'html_document', output_file = 'index.html', output_dir = 'docs')"
Rscript -e "utils::browseURL(url = 'docs/index.html')"
