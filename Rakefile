# Rakefile for pdftk and pdfocr docker images



task default: %w[pdftk pdfocr] 

desc 'Build pdftk'
task :pdftk do
  puts 'build pdftk'
  sh 'cd pdftk; touch .done'
end

desc 'Build pdfocr'
task :pdfocr do
  puts 'build pdfocr'
  sh 'cd pdfocr; touch .done'
end

