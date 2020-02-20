Rscript -e "rmarkdown::render(input = 'sintef_obs_synergies.Rmd', output_format = 'html_document', output_dir = 'docs')"
Rscript -e "utils::browseURL(url = '/home/john/repos/druglogics/sintef-obs-synergies/docs/sintef_obs_synergies.html')"
