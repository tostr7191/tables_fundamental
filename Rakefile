OUTDIR='./pdf'
task :default => ['gas_reserve.pdf', 'clean']

file "tmp/minimum_gas.csv" => [:intermediate]
file "tmp/gas_consumption.csv" => [:intermediate]

file "gas_reserve.pdf" => ['gas_reserve.tex', :intermediate] do
  sh "latexmk -silent -outdir=#{OUTDIR} -pdf -pdflatex='pdflatex -interaction=nonstopmode' -use-make gas_reserve.tex"
  sh "latexmk -silent -outdir=#{OUTDIR} -c"
end

directory 'tmp'

task :intermediate => ['tmp', 'generate.rb'] do
  ruby "generate.rb"
end

task :clean do
  rm_rf 'tmp'
end

task :clean_all => [:clean] do
  sh "latexmk -silent -outdir=#{OUTDIR} -C"
end
