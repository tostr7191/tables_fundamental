OUTDIR='./pdf'
task :default => ['gas_reserve.pdf', 'clean']


file "gas_reserve.pdf" => ['gas_reserve.tex', 'tmp/minimum_gas.csv'] do
  sh "latexmk -outdir=#{OUTDIR} -pdf -pdflatex='pdflatex -interaction=nonstopmode' -use-make gas_reserve.tex"
  sh "latexmk -outdir=#{OUTDIR} -c"
end

directory 'tmp'

file "tmp/minimum_gas.csv" => ['tmp', 'generate.rb'] do
  ruby "generate.rb"
end

task :clean do
  rm_rf 'tmp'
end

task :clean_all do
  sh "latexmk -outdir=#{OUTDIR} -C"
end
